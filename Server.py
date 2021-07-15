import _thread
import base64
import hashlib
import json
import os
import secrets
import socket
import string
from datetime import datetime

import mysql.connector
from Crypto import Random
from Crypto.Cipher import AES
from Crypto.Util import Counter
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.kdf.hkdf import HKDF
from dotenv import load_dotenv
from password_strength import PasswordPolicy

count = 0
load_dotenv()
policy = PasswordPolicy.from_names(
    length=10,  # min length: 8
    uppercase=1,  # need min. 2 uppercase letters
    numbers=1,  # need min. 2 digits
    special=1,  # need min. 2 special characters
    nonletters=1,  # need min. 2 non-letter characters (digits, specials, anything)
    entropybits=30,  # need a password that has minimum 30 entropy bits (the power of its alphabet)
)
connection = mysql.connector.connect(
    host='localhost',
    database='securebankingsystem',
    user=os.getenv('DATABASE_USERNAME'),
    password=os.getenv('DATABASE_PASSWORD')
)


def client_service(client):
    global count
    login = False
    username = ""
    data = ""
    wrong_password = 10

    session_key = key_exchange(client)
    while True:
        try:
            data = client.recv(1024)
            data = data.decode('utf-8')
        except:
            if not data:
                c_IP, c_port = client.getpeername()
                print('Client with ip = {} and port = {} has been disconnected at time {}.'
                      .format(c_IP, c_port, str(datetime.now())))
                client.close()
                count = count - 1
                return 1

        data = decrypt(data, session_key)
        command = data.split()

        if login:
            if command[0] == "Create" and len(command) == 5:
                conf_label = ["TopSecret", "Secret", "Confidential", "Unclassified"]
                integrity_label = ["VeryTrusted", "Trusted", "SlightlyTrusted", "Untrusted"]
                account_type = ["Short-term saving account", "Long-term saving account", "Current account",
                                "Gharz al-Hasna saving account"]

                account_no = add_account(username, account_type[int(command[1])], float(command[2]),
                                         str(conf_label.index(command[3]) + 1),
                                         str(integrity_label.index(command[4]) + 1))

                msg = encrypt(account_no, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Deposit" and len(command) == 4:
                """
                :command: Deposit [from_account_no] [to_account_no] [amount]
                :Access Control Strategy to withdraw from_account_no:
                    1. Integrity(User)       >= Integrity(Account)
                    2. Confidentiality(User) <= Confidentiality(Account)
                :Access Control Strategy to deposit to_account_no: everyone has access
                :In Database:    
                    conf_label = {
                      "TopSecret"    : '1',
                      "Secret"       : '2',
                      "Confidential" : '3',
                      "Unclassified" : '4',
                    }
                    integrity_label = {
                      "VeryTrusted"    : '1',
                      "Trusted"        : '2',
                      "SlightlyTrusted": '3',
                      "Untrusted"      : '4',
                    }
                """
                status = '0'
                if check_account_number(int(command[1])) == 1:  # from_account_no exists
                    if check_account_number(int(command[2])) == 1:  # to_account_no exists
                        if is_account_owner(username, command[1]) or (  # DAC
                                # MAC
                                int(is_user_joint_account(username, int(command[1])))
                                and
                                int(get_user_integrity_label(int(command[1]), username)) <=
                                int(get_account_integrity_label(int(command[1])))
                                and
                                int(get_user_conf_label(int(command[1]), username)) >=
                                int(get_account_conf_label(int(command[1])))
                        ):  # have write permission
                            if check_balance(int(command[1]), int(command[3])):  # enough balance
                                deposit(username, int(command[1]), int(command[2]), int(command[3]))
                                msg = "ok " + str(datetime.now())
                                status = '1'
                            else:
                                msg = "E3 " + str(datetime.now())  # NOT enough balance
                        else:
                            msg = "E2 " + str(datetime.now())  # Access denied
                    else:
                        msg = "E1 " + str(datetime.now())  # to_account_no exists
                else:
                    msg = "E0 " + str(datetime.now())  # from_account_no NOT exists

                add_deposit_log(username, command[1], command[2], command[3], client.getpeername()[0],
                                client.getpeername()[1], status)

                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Withdraw" and len(command) == 3:
                """
                :command: Withdraw [account_no] [amount]
                :Access Control Strategy to withdraw from account_no:
                    1. Integrity(User)       >= Integrity(Account)
                    2. Confidentiality(User) <= Confidentiality(Account)
                :In Database:    
                    conf_label = {
                      "TopSecret"    : '1',
                      "Secret"       : '2',
                      "Confidential" : '3',
                      "Unclassified" : '4',
                    }
                    integrity_label = {
                      "VeryTrusted"    : '1',
                      "Trusted"        : '2',
                      "SlightlyTrusted": '3',
                      "Untrusted"      : '4',
                    }
                """
                status = '0'
                if check_account_number(int(command[1])) == 1:  # account_no exists
                    if is_account_owner(username, command[1]) or (  # DAC
                            # MAC
                            int(is_user_joint_account(username, int(command[1])))
                            and
                            int(get_user_integrity_label(int(command[1]), username)) <=
                            int(get_account_integrity_label(int(command[1])))
                            and
                            int(get_user_conf_label(int(command[1]), username)) >=
                            int(get_account_conf_label(int(command[1])))
                    ):  # have write permission
                        if check_balance(int(command[1]), int(command[2])):  # enough balance
                            withdraw(username, int(command[1]), int(command[2]))
                            msg = "ok " + str(datetime.now())
                            status = '1'
                        else:
                            msg = "E2 " + str(datetime.now())  # NOT enough balance
                    else:
                        msg = "E1 " + str(datetime.now())  # Access denied
                else:
                    msg = "E0 " + str(datetime.now())  # account_no NOT exists

                add_withdraw_log(username, command[1], command[2], client.getpeername()[0], client.getpeername()[1],
                                 status)

                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Exit" and len(command) == 1:
                msg = "Good bye ..."
                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))
                break

        else:
            if command[0] == "Signup" and len(command) == 3:
                status = 0
                if check_username(command[1]) == 0:
                    pass_str = is_password_strong(command[1], command[2])
                    if pass_str == '1':
                        add_user(command[1], command[2])
                        msg = "ok " + str(datetime.now())
                        status = 1
                    else:
                        msg = "E1 " + str(datetime.now()) + " " + pass_str
                else:
                    msg = "E0 " + str(datetime.now())

                # Signup log
                add_signup_log(command[1], command[2], str(status))

                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Login" and len(command) == 3:
                status = 0
                if check_username(command[1]) == 1:
                    is_ban, ban_time = check_ban(command[1])
                    if not is_ban:
                        if check_password(command[1], command[2]):
                            login = True
                            username = command[1]
                            wrong_password = 10
                            msg = "ok " + str(datetime.now())
                            status = 1
                        else:
                            msg = "E1 " + str(datetime.now())
                            wrong_password += -1
                    else:
                        msg = "ban " + str(ban_time) + " " + str(datetime.now())
                else:
                    msg = "E0 " + str(datetime.now())

                if (wrong_password == 5 or wrong_password == 0) and (not check_ban(command[1])[0]):
                    update_ban(command[1])
                # elif  wrong_password < 0:
                    # honeypot

                # Login log
                add_login_log(command[1], command[2], client.getpeername()[0], client.getpeername()[1], str(status))

                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Exit" and len(command) == 1:
                msg = "Good bye ..."
                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))
                break

    c_IP, c_port = client.getpeername()
    print('Client with ip = {} and port = {} has been disconnected at time {}.'
          .format(c_IP, c_port, str(datetime.now())))
    client.close()
    count = count - 1


def add_account(username, account_type, amount, conf_label, integrity_label):
    cursor = connection.cursor()
    args = [username, account_type, amount, conf_label, integrity_label, 0]
    result_args = cursor.callproc('add_account', args)
    cursor.close()
    return result_args[5]


def add_deposit_log(username, from_account_no, to_account_no, amount, ip, port, status):
    """
    :param username: username of the client who send deposit request VARCHAR(50)
    :param from_account_no: origin account number INT(20)
    :param to_account_no: destination account number INT(20)
    :param amount: DECIMAL(11, 4)
    :param ip: VARCHAR(20)
    :param port: VARCHAR(20)
    :param status: status code VARCHAR(1) check(0: failure, 1: successful)
    """
    cursor = connection.cursor()
    args = [username, from_account_no, to_account_no, amount, ip, port, status]
    cursor.callproc('add_deposit_log', args)
    cursor.close()


def add_withdraw_log(username, account_no, amount, ip, port, status):
    """
    :param username: username of the client who send deposit request VARCHAR(50)
    :param account_no: destination account number INT(20)
    :param amount: DECIMAL(11, 4)
    :param ip: VARCHAR(20)
    :param port: VARCHAR(20)
    :param status: status code VARCHAR(1) check(0: failure, 1: successful)
    """
    cursor = connection.cursor()
    args = [username, account_no, amount, ip, port, status]
    cursor.callproc('add_withdraw_log', args)
    cursor.close()


def add_login_log(username, password, status, ip, port):
    cursor = connection.cursor()
    salt = ''.join(secrets.choice(string.ascii_letters) for _ in range(25))
    hash_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()
    hash_password = str(hash_password)
    args = [username, hash_password, salt, status, ip, port]
    cursor.callproc('add_login_log', args)
    cursor.close()


def add_signup_log(username, password, status):
    cursor = connection.cursor()
    salt = ''.join(secrets.choice(string.ascii_letters) for _ in range(25))
    hash_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()
    hash_password = str(hash_password)
    args = [username, hash_password, salt, status]
    cursor.callproc('add_signup_log', args)
    cursor.close()


def add_user(username, password):
    cursor = connection.cursor()
    salt = ''.join(secrets.choice(string.ascii_letters) for _ in range(25))
    hash_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()
    hash_password = str(hash_password)
    args = [username, hash_password, salt]
    cursor.callproc('add_user', args)
    cursor.close()


def check_account_number(account_no):
    cursor = connection.cursor()
    args = [account_no, 0]
    result_args = cursor.callproc('check_account_number', args)
    cursor.close()
    return result_args[1]


def check_balance(account_no, amount):
    """
    :param account_no: account number INT(10)
    :param amount: DECIMAL(11, 4)
    :return: status code (1:  enough balance, 0: NOT enough balance)
    """
    cursor = connection.cursor()
    args = [account_no, amount, 0]
    result_args = cursor.callproc('check_balance', args)
    cursor.close()
    return result_args[1]


def check_ban(username):
    cursor = connection.cursor()
    args = [username, 0, 0]
    result_args = cursor.callproc('check_ban', args)
    cursor.close()
    return result_args[1], result_args[2]


def check_password(username, password):
    cursor = connection.cursor()
    args = [username, 0, 0]
    result_args = cursor.callproc('get_password_salt', args)
    salt = str(result_args[2])
    hash_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()
    hash_password = str(hash_password)
    if hash_password == str(result_args[1]):
        cursor.close()
        return 1
    cursor.close()
    return 0


def check_username(username):
    cursor = connection.cursor()
    args = [username, 0]
    result_args = cursor.callproc('check_user', args)
    cursor.close()
    return result_args[1]


def decrypt(ciphertext, key):
    b64 = json.loads(ciphertext)
    nonce = base64.b64decode(b64['nonce'].encode('utf-8'))
    plaintext = base64.b64decode(b64['ciphertext'])
    countf = Counter.new(64, nonce)
    cipher = AES.new(key, AES.MODE_CTR, counter=countf)
    plaintext = cipher.decrypt(plaintext)
    result = plaintext.decode('utf-8')
    return result


def deposit(username, from_account_no, to_account_no, amount):
    """
    :param username: username of Depositor VARCHAR(50)
    :param from_account_no: origin account number INT(10)
    :param to_account_no: destination account number INT(10)
    :param amount: DECIMAL(11, 4)
    """
    cursor = connection.cursor()
    args = [username, from_account_no, to_account_no, amount]
    cursor.callproc('deposit', args)
    cursor.close()


def encrypt(plaintext, key):
    nonce1 = Random.get_random_bytes(8)
    countf = Counter.new(64, nonce1)
    cipher = AES.new(key, AES.MODE_CTR, counter=countf)
    ciphertext_bytes = cipher.encrypt(plaintext.encode('utf-8'))
    nonce = base64.b64encode(nonce1).decode('utf-8')
    ciphertext = base64.b64encode(ciphertext_bytes).decode('utf-8')
    result = json.dumps({'nonce': nonce, 'ciphertext': ciphertext})
    return result


def get_account_conf_label(account_no):
    """
    :param account_no: account number INT(10)
    :return: confirmation label VARCHAR(1) CHECK('1', '2', '3', '4')
    :conf_labels: {
      "TopSecret"    : '1',
      "Secret"       : '2',
      "Confidential" : '3',
      "Unclassified" : '4',
    }
    """
    cursor = connection.cursor()
    args = [account_no, '']
    result_args = cursor.callproc('get_account_conf_label', args)
    cursor.close()
    return result_args[1]


def get_account_integrity_label(account_no):
    """
    :param account_no: account number INT(10)
    :return: Integrity label VARCHAR(1) CHECK('1', '2', '3', '4')
    :integrity_labels: {
          "VeryTrusted"    : '1',
          "Trusted"        : '2',
          "SlightlyTrusted": '3',
          "Untrusted"      : '4',
        }
    """
    cursor = connection.cursor()
    args = [account_no, '']
    result_args = cursor.callproc('get_account_integrity_label', args)
    cursor.close()
    return result_args[1]


def get_user_conf_label(account_no, username):
    """
    :param account_no: account number INT(10)
    :param username: username VARCHAR(50)
    :return: confirmation label VARCHAR(1) CHECK('1', '2', '3', '4')
    :conf_labels: {
      "TopSecret"    : '1',
      "Secret"       : '2',
      "Confidential" : '3',
      "Unclassified" : '4',
    }
    """
    cursor = connection.cursor()
    args = [username, account_no, '']
    result_args = cursor.callproc('get_user_conf_label', args)
    cursor.close()
    return result_args[2]


def get_user_integrity_label(account_no, username):
    """
    :param account_no: account number INT(10)
    :param username: username VARCHAR(50)
    :return: Integrity label VARCHAR(1) CHECK('1', '2', '3', '4')
    :integrity_labels: {
          "VeryTrusted"    : '1',
          "Trusted"        : '2',
          "SlightlyTrusted": '3',
          "Untrusted"      : '4',
        }
    """
    cursor = connection.cursor()
    args = [username, account_no, '']
    result_args = cursor.callproc('get_user_integrity_label', args)
    cursor.close()
    return result_args[2]


def is_account_owner(username, account_no):
    """
    :param account_no: account number INT(10)
    :param username: username VARCHAR(50)
    :return: status code 0: username is not
             the owner of this account_no
             and 1 for otherwise
    """
    cursor = connection.cursor()
    args = [username, account_no, 0]
    result_args = cursor.callproc('is_account_owner', args)
    cursor.close()
    return result_args[2]


def is_password_strong(username, password):
    if password.find(username) != -1:
        return "Password should not include username !!!"

    condition = policy.test(password)
    if condition:
        return ''.join(str(condition))

    file = open("Top List Passwords.txt", "r")
    for i in file:
        i = str(i).strip()
        if i == password:
            return "Password is in top 1,000,000 weak passwords !!!"

    return '1'


def is_user_joint_account(username, account_no):
    """
    :param account_no: account number INT(10)
    :param username: username VARCHAR(50)
    :return: status code 0: username is not
             joint with this account_no
             and 1 for otherwise
    """
    cursor = connection.cursor()
    args = [username, account_no, 0]
    result_args = cursor.callproc('is_user_joint_account', args)
    cursor.close()
    return result_args[2]


def update_ban(username):
    cursor = connection.cursor()
    args = [username]
    cursor.callproc('update_ban', args)
    cursor.close()


def key_exchange(client):
    backend = default_backend()
    client_recv = client.recv(1024)
    client_public_key = serialization.load_pem_public_key(client_recv, backend)
    server_private_key = ec.generate_private_key(ec.SECP256R1(), backend)
    server_public_key = server_private_key.public_key()
    client.send(
        server_public_key.public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo))
    shared_data = server_private_key.exchange(ec.ECDH(), client_public_key)
    secret_key = HKDF(hashes.SHA256(), 32, None, b'Key Exchange', backend).derive(shared_data)
    session_key = secret_key[-16:]
    return session_key


def withdraw(username, account_no, amount):
    """
    :param username: VARCHAR(50)
    :param account_no: account number INT(10)
    :param amount: DECIMAL(11, 4)
    """
    cursor = connection.cursor()
    args = [username, account_no, amount]
    cursor.callproc('withdraw', args)
    cursor.close()


if __name__ == '__main__':
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    if server == 0:
        print("Error in server socket creation !!!")

    server.bind((socket.gethostname(), 8080))
    server.listen(10)
    print("Server is listening for any connection ... ")

    while True:
        client, addr = server.accept()
        count = count + 1

        if count == 10:
            print("Server Is Busy !!")
            client.send("Server Is Busy !!".encode('utf-8'))

            client.close()
            count = count - 1
        else:
            print("Client with ip = {} has been connected at time {}"
                  .format(addr, str(datetime.now())))
            client.send(" ".encode('utf-8'))

            _thread.start_new_thread(client_service, (client,))

    server.close()
    connection.close()
