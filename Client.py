import base64
import json
import socket

from Crypto import Random
from Crypto.Cipher import AES
from Crypto.Util import Counter
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import ec
from cryptography.hazmat.primitives.kdf.hkdf import HKDF


def Create(command, cmd, client, key):
    conf_label = ["TopSecret", "Secret", "Confidential", "Unclassified"]
    integrity_label = ["VeryTrusted", "Trusted", "SlightlyTrusted", "Untrusted"]

    if not (0 <= int(cmd[1]) <= 3):
        print("ERROR: Account type is out of range!!! Please try again")
        return 0
    if float(cmd[2]) < 0:
        print("ERROR: Amount of money received is negative. Please try again")
        return 0
    if cmd[3] not in conf_label:
        print("ERROR: Confidentiality label is not defined, Please try again and enter an allowable Confidentiality "
              "label")
        return 0
    if cmd[4] not in integrity_label:
        print("ERROR: Integrity label is not defined. Please try again and enter an allowable integrity label")
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    print("Your account has been created successfully!!, Your account number is: {}"
          .format(replay))


def decrypt(ciphertext, key):
    b64 = json.loads(ciphertext)
    nonce = base64.b64decode(b64['nonce'].encode('utf-8'))
    plaintext = base64.b64decode(b64['ciphertext'])
    countf = Counter.new(64, nonce)
    cipher = AES.new(key, AES.MODE_CTR, counter=countf)
    plaintext = cipher.decrypt(plaintext)
    result = plaintext.decode('utf-8')
    return result


def Deposit(command, cmd, client, key):
    """
    :param command: deposit [from_account_no] [to_account_no] [amount]
    :param cmd: list('deposit', from_account_no, to_account_no, amount)
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    if len(cmd[1]) != 10:
        print("ERROR: Invalid origin account number. [Length(10)]")
        return 0
    if not (cmd[1].isnumeric()):
        print("ERROR: Invalid origin account number. [Digits Only]")
        return 0
    if len(cmd[2]) != 10:
        print("ERROR: Invalid destination account number. [Length(10)]")
        return 0
    if not (cmd[2].isnumeric()):
        print("ERROR: Invalid destination account number. [Digits Only]")
        return 0
    if len(cmd[3]) > 11:
        print("ERROR: Out of range amount. [Length(11)]")
        return 0
    if float(cmd[3]) < 0:
        print("ERROR: Invalid amount. [Positive Number Only]")
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split()
    if replay[0] == "ok":
        print("Deposit was successful.")
        return 1  # Deposit was successful
    elif replay[0] == "E0":
        print("ERROR: There is no account with the given from_account_no.")
        return 0  # Deposit was failed
    elif replay[0] == "E1":
        print("ERROR: There is no account with the given to_account_no.")
        return 0  # Deposit was failed
    elif replay[0] == "E2":
        print("ERROR: Access denied. You are not permitted to withdraw from this account")
        return 0  # Deposit was failed
    elif replay[0] == "E3":
        print("ERROR: Your account balance is not enough.")
        return 0  # Deposit was failed


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
    client_private_key = ec.generate_private_key(ec.SECP256R1(), backend)
    client_public_key = client_private_key.public_key()
    client.send(client_public_key.public_bytes(serialization.Encoding.PEM,
                                               serialization.PublicFormat.SubjectPublicKeyInfo))
    server_recv = client.recv(1024)
    server_public_key = serialization.load_pem_public_key(server_recv, backend)
    shared_data = client_private_key.exchange(ec.ECDH(), server_public_key)
    secret_key = HKDF(hashes.SHA256(), 32, None, b'Key Exchange', backend).derive(shared_data)
    session_key = secret_key[-16:]
    print("Key exchanged successfully.\n")
    return session_key


def Login(command, client, key):
    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)

    replay = replay.split()
    if replay[0] == "ok":
        print("Logged in successfully.")
        return 1  # Login successfully
    elif replay[0] == "E0":
        print("ERROR: Username do not match. Please try again")
        return 0  # Login failed
    elif replay[0] == "E1":
        print("ERROR: Password do not match. Please try again")
        return 0  # Login failed
    elif replay[0] == "ban":
        print("ERROR: Your Account is ban for {} seconds. try again later"
              .format(replay[1]))
        return 0  # Login failed


def request(command, client, session_key):
    cipher_text = encrypt(command, session_key)
    if cipher_text is None:
        return 0
    if cipher_text is not None:
        client.send(cipher_text.encode('utf-8'))
        return 1


def show(command, client, session_key):
    cipher_text = encrypt(command, session_key)
    if cipher_text is None:
        return 0
    if cipher_text is not None:
        client.send(cipher_text.encode('utf-8'))
        replay = client.recv(1024)
        replay = replay.decode('utf-8')
        plain_text = decrypt(replay, session_key)
        if plain_text is None:
            return 0
        if plain_text is not None:
            return plain_text


def Signup(command, client, key):
    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)

    replay = replay.split()
    if replay[0] == "ok":
        print("Signup successfully.")
        return 1  # Signup successfully
    elif replay[0] == "E0":
        print("ERROR: This username already exists. Please select another one.")
        return 0  # Signup failed
    elif replay[0] == "E1":
        print("ERROR: Password is not strong enough. {}".format(replay[3:]))
        return 0  # Signup failed


def Withdraw(command, cmd, client, key):
    """
    :param command: withdraw [account_no] [amount]
    :param cmd: list('withdraw', account_no, amount)
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    if len(cmd[1]) != 10:
        print("ERROR: Invalid account number. [Length(10)]")
        return 0
    if not (cmd[1].isnumeric()):
        print("ERROR: Invalid account number. [Digits Only]")
        return 0
    if len(cmd[2]) > 11:
        print("ERROR: Out of range amount. [Length(11)]")
        return 0
    if float(cmd[2]) < 0:
        print("ERROR: Invalid amount. [Positive Number Only]")
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split()
    if replay[0] == "ok":
        print("Withdrawal was successful.")
        return 1  # Withdrawal was successful
    elif replay[0] == "E0":
        print("ERROR: There is no account with the given account_no.")
        return 0  # Withdrawal was failed
    elif replay[0] == "E1":
        print("ERROR: Access denied. You are not permitted to withdraw from this account")
        return 0  # Withdrawal was failed
    elif replay[0] == "E2":
        print("ERROR: Your account balance is not enough.")
        return 0  # Withdrawal was failed


if __name__ == '__main__':
    login = False
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    if client == 0:
        print("ERROR: Unable to create client socket !!!")

    client.connect((socket.gethostname(), 8080))
    print("Connecting to server ... \n")

    data = client.recv(1024)
    data = data.decode('utf-8')
    if data == "Server Is Busy !!":
        print(data)
        client.close()

    else:
        session_key = key_exchange(client)
        help_message1 = (
                'Available commands:\n' +
                '\tSignup   \tSignup [username] [password]\n' +
                '\tLogin    \tLogin [username] [password]\n' +
                '\tHelp     \n' +
                '\tExit     \n'
        )
        help_message2 = (
                'Available commands:\n' +
                '\tCreate           \tCreate [account_type] [amount] [conf_label] [integrity_label]\n' +
                '\t\tAccount Type:  Short-term saving account = 0, Long-term saving account = 1, Current account = 2, '
                'Gharz al-Hasna saving account = 3\n' +
                '\tJoin             \tJoin [account_no]\n' +
                '\tAccept           \tAccept [username] [conf_label] [integrity_label]\n' +
                '\tShow_MyAccount   \tShow_MyAccount\n' +
                '\tShow_Account     \tShow_Account [account_no]\n' +
                '\tDeposit          \tDeposit [from_account_no] [to_account_no] [amount]\n' +
                '\tWithdraw         \tWithdraw [account_no] [amount]\n' +
                '\tHelp\n' +
                '\tExit\n'
        )

        print(help_message1)

        while True:
            command = input('> ')
            cmd = command.split()

            if login:
                if cmd[0] == "Create" and len(cmd) == 5:
                    Create(command, cmd, client, session_key)

                elif cmd[0] == "Join" and len(cmd) == 2:
                    replay = request(command, client, session_key)
                    if replay != 0:
                        print("Request Sent!")

                elif cmd[0] == "Accept" and len(cmd) == 4:
                    replay = request(command, client, session_key)
                    if replay != 0:
                        print("Request Sent!")

                elif cmd[0] == "Show_MyAccount" and len(cmd) == 1:
                    replay = show(command, client, session_key)
                    if replay != 0:
                        print(replay)

                elif cmd[0] == "Show_Account" and len(cmd) == 2:
                    replay = show(command, client, session_key)
                    if replay != 0:
                        print(replay)

                elif cmd[0] == "Deposit" and len(cmd) == 4:
                    Deposit(command, cmd, client, session_key)

                elif cmd[0] == "Withdraw" and len(cmd) == 3:
                    Withdraw(command, cmd, client, session_key)

                elif cmd[0] == "Help" and len(cmd) == 1:
                    print(help_message2)

                elif cmd[0] == "Exit" and len(cmd) == 1:
                    command = encrypt(command, session_key)
                    client.send(command.encode('utf-8'))
                    replay = client.recv(1024)
                    replay = replay.decode('utf-8')
                    replay = decrypt(replay, session_key)
                    print(replay)
                    break

                else:
                    print("Command is wrong!!!")

            else:
                if cmd[0] == "Signup" and len(cmd) == 3:
                    Signup(command, client, session_key)

                elif cmd[0] == "Login" and len(cmd) == 3:
                    if Login(command, client, session_key):
                        print()
                        print(help_message2)
                        login = True

                elif cmd[0] == "Help" and len(cmd) == 1:
                    print(help_message1)

                elif cmd[0] == "Exit" and len(cmd) == 1:
                    command = encrypt(command, session_key)
                    client.send(command.encode('utf-8'))
                    replay = client.recv(1024)
                    replay = replay.decode('utf-8')
                    replay = decrypt(replay, session_key)
                    print(replay)
                    break

                else:
                    print("Command is wrong!!!")

        client.close()
