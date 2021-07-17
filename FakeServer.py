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

count = 0
load_dotenv()
connection = mysql.connector.connect(
    host='localhost',
    database='fakebankingsystem',
    user=os.getenv('DATABASE_USERNAME'),
    password=os.getenv('DATABASE_PASSWORD')
)


def client_service(client):
    global count
    data = ""
    number_of_tries = 11

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

        if command[0] == "Signup" and len(command) == 3:
            msg = "E2 " + str(datetime.now())

            # Signup log
            add_signup_log(command[1], command[2], "0")

            msg = encrypt(msg, session_key)
            client.send(msg.encode('utf-8'))

        elif command[0] == "Login" and len(command) == 3:
            is_ban, ban_time = check_ban(command[1])
            if not is_ban:
                msg = "E1 " + str(datetime.now())
                number_of_tries += 1
            else:
                msg = "ban " + str(ban_time) + " " + str(datetime.now())

            if (number_of_tries % 5 == 0) and (not check_ban(command[1])[0]):
                update_ban(command[1])

            # Login log
            add_login_log(command[1], command[2], client.getpeername()[0], client.getpeername()[1], "0")

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


def check_ban(username):
    cursor = connection.cursor()
    args = [username, 0, 0]
    result_args = cursor.callproc('check_ban', args)
    cursor.close()
    return result_args[1], result_args[2]


def decrypt(ciphertext, key):
    b64 = json.loads(ciphertext)
    nonce = base64.b64decode(b64['nonce'].encode('utf-8'))
    plaintext = base64.b64decode(b64['ciphertext'])
    countf = Counter.new(64, nonce)
    cipher = AES.new(key, AES.MODE_CTR, counter=countf)
    plaintext = cipher.decrypt(plaintext)
    result = plaintext.decode('utf-8')
    return result


def encrypt(plaintext, key):
    nonce1 = Random.get_random_bytes(8)
    countf = Counter.new(64, nonce1)
    cipher = AES.new(key, AES.MODE_CTR, counter=countf)
    ciphertext_bytes = cipher.encrypt(plaintext.encode('utf-8'))
    nonce = base64.b64encode(nonce1).decode('utf-8')
    ciphertext = base64.b64encode(ciphertext_bytes).decode('utf-8')
    result = json.dumps({'nonce': nonce, 'ciphertext': ciphertext})
    return result


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


def update_ban(username):
    cursor = connection.cursor()
    args = [username]
    cursor.callproc('update_ban', args)
    cursor.close()


if __name__ == '__main__':
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    if server == 0:
        print("Error in server socket creation !!!")

    server.bind((socket.gethostname(), 8000))
    server.listen(10)
    print("Honeypot Server is listening for any connection ... ")

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
