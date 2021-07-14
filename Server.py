import json
import base64
import socket
import string
import _thread
import secrets
import hashlib
import mysql.connector
from Crypto import Random
from datetime import datetime
from Crypto.Cipher import AES
from Crypto.Util import Counter
from password_strength import PasswordPolicy
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.kdf.hkdf import HKDF
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives import hashes, serialization

count = 0
policy = PasswordPolicy.from_names(
    length = 10,  # min length: 8
    uppercase = 1,  # need min. 2 uppercase letters
    numbers = 1,  # need min. 2 digits
    special = 1,  # need min. 2 special characters
    nonletters = 1,  # need min. 2 non-letter characters (digits, specials, anything)
    entropybits = 30,  # need a password that has minimum 30 entropy bits (the power of its alphabet)
)
connection = mysql.connector.connect(
    host = 'localhost',
    database = 'securebankingsystem',
    user = 'pynative',
    password = 'pynative@#29'
)

def client_service(client):
    global count
    login = False
    username = ""
    data = ""

    session_key = key_exchange(client)
    while True:
        try:
            data = client.recv(1024)
        except:
            if not data:
                c_IP, c_port = client.getpeername()
                print('Client with ip = {} and port = {} has been disconnected at time {}.'.format(c_IP, c_port, str(datetime.now())))
                client.close()
                count = count - 1
                return 1

        data = data.decode('utf-8')
        data = decrypt(data, session_key)
        command = data.split()

        if login:
            if command[0] == "Create" and len(command) == 5:
                print()

            elif command[0] == "Exit" and len(command) == 1:
                break

        else:
            if command[0] == "Signup" and len(command) == 3:
                if check_username(command[1]) == 0:
                    pass_str = is_password_strong(command[1], command[2])
                    if pass_str == '1':
                        add_user(command[1], command[2])
                        msg = "ok " + str(datetime.now())
                    else:
                        msg = "E1 " + str(datetime.now()) + " " + pass_str
                else:
                    msg = "E0 " + str(datetime.now())

                # Signup log

                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Login" and len(command) == 3:
                if check_username(command[1]) == 1:
                    if check_password(command[1], command[2]):
                        login = True
                        username = command[1]
                        msg = "ok " + str(datetime.now())
                    else:
                        msg = "E1 " + str(datetime.now())
                else:
                    msg = "E0 " + str(datetime.now())

                # Login log

                msg = encrypt(msg, session_key)
                client.send(msg.encode('utf-8'))

            elif command[0] == "Exit" and len(command) == 1:
                break

    client.close()
    count = count - 1

def check_username(username):
    cursor = connection.cursor()
    args = []
    args.append(username)
    args.append(0)
    result_args = cursor.callproc('check_user', args)
    cursor.close()
    return result_args[1]

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

def add_user(username, password):
    cursor = connection.cursor()
    salt = ''.join(secrets.choice(string.ascii_letters) for _ in range(25))
    hash_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()
    hash_password = str(hash_password)
    args = []
    args.append(username)
    args.append(hash_password)
    args.append(salt)
    cursor.callproc('add_user', args)
    cursor.close()

def check_password(username, password):
    cursor = connection.cursor()
    args = []
    args.append(username)
    args.append(0)
    args.append(0)
    result_args = cursor.callproc('get_password_salt', args)
    salt = str(result_args[2])
    hash_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()
    hash_password = str(hash_password)
    if hash_password == str(result_args[1]):
        cursor.close()
        return 1
    cursor.close()
    return 0

def key_exchange(client):
    backend = default_backend()
    client_recv = client.recv(1024)
    client_public_key = serialization.load_pem_public_key(client_recv, backend)
    server_private_key = ec.generate_private_key(ec.SECP256R1(), backend)
    server_public_key = server_private_key.public_key()
    client.send(server_public_key.public_bytes(serialization.Encoding.PEM, serialization.PublicFormat.SubjectPublicKeyInfo))
    shared_data = server_private_key.exchange(ec.ECDH(), client_public_key)
    secret_key = HKDF(hashes.SHA256(), 32, None, b'Key Exchange', backend).derive(shared_data)
    session_key = secret_key[-16:]
    return session_key

def encrypt(plaintext, key):
    nonce1 = Random.get_random_bytes(8)
    countf = Counter.new(64, nonce1)
    cipher = AES.new(key, AES.MODE_CTR, counter = countf)
    ciphertext_bytes = cipher.encrypt(plaintext.encode('utf-8'))
    nonce = base64.b64encode(nonce1).decode('utf-8')
    ciphertext = base64.b64encode(ciphertext_bytes).decode('utf-8')
    result = json.dumps({'nonce': nonce, 'ciphertext': ciphertext})
    return result

def decrypt(ciphertext, key):
    b64 = json.loads(ciphertext)
    nonce = base64.b64decode(b64['nonce'].encode('utf-8'))
    plaintext = base64.b64decode(b64['ciphertext'])
    countf = Counter.new(64, nonce)
    cipher = AES.new(key, AES.MODE_CTR, counter = countf)
    plaintext = cipher.decrypt(plaintext)
    result = plaintext.decode('utf-8')
    return result

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
            print("Client with ip = {} has been connected at time {}".format(addr, str(datetime.now())))
            client.send(" ".encode('utf-8'))

            _thread.start_new_thread(client_service, (client,))

    server.close()
    connection.close()