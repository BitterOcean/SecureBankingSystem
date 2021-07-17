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
from random import randint

HP = 0


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


def Accept(command, cmd, client, key):
    """
    :param command: Accept [username] [conf_label] [integrity_label]
    :param cmd: list('Accept', conf_label, integrity_label)
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    conf_label = ["TopSecret", "Secret", "Confidential", "Unclassified"]
    integrity_label = ["VeryTrusted", "Trusted", "SlightlyTrusted", "Untrusted"]

    if cmd[2] not in conf_label:
        print(bcolors.FAIL + "ERROR: Confidentiality label is not defined, Please try again and enter an allowable "
                             "Confidentiality label" + bcolors.ENDC)
        return 0
    if cmd[3] not in integrity_label:
        print(bcolors.FAIL + "ERROR: Integrity label is not defined. Please try again and enter an allowable "
                             "integrity label" + bcolors.ENDC)
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split()
    if replay[0] == "ok":
        print(bcolors.OKGREEN + "Accept request sent to the applicant successfully." + bcolors.ENDC)
        return 1  # accept request sent successfully
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no user with the given username." + bcolors.ENDC)
        return 0  # accept request failed
    elif replay[0] == "E1":
        print(bcolors.FAIL + "ERROR: There is no account registered for your username yet." + bcolors.ENDC)
        return 0  # accept request failed
    elif replay[0] == "E2":
        print(bcolors.FAIL + "ERROR: There is no pending join request from this username" + bcolors.ENDC)
        return 0  # accept request failed


def Create(command, cmd, client, key):
    conf_label = ["TopSecret", "Secret", "Confidential", "Unclassified"]
    integrity_label = ["VeryTrusted", "Trusted", "SlightlyTrusted", "Untrusted"]

    if not (0 <= int(cmd[1]) <= 3):
        print(bcolors.FAIL + "ERROR: Account type is out of range!!! Please try again" + bcolors.ENDC)
        return 0
    if float(cmd[2]) < 0:
        print(bcolors.FAIL + "ERROR: Amount of money received is negative. Please try again" + bcolors.ENDC)
        return 0
    if cmd[3] not in conf_label:
        print(
            bcolors.FAIL + "ERROR: Confidentiality label is not defined, Please try again and enter an allowable "
                           "Confidentiality label" + bcolors.ENDC)
        return 0
    if cmd[4] not in integrity_label:
        print(
            bcolors.FAIL + "ERROR: Integrity label is not defined. Please try again and enter an allowable integrity "
                           "label" + bcolors.ENDC)
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    print(bcolors.OKGREEN + "Your account has been created successfully!!, Your account number is: {}".format(
        replay) + bcolors.ENDC)


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
        print(bcolors.FAIL + "ERROR: Invalid origin account number. [Length(10)]" + bcolors.ENDC)
        return 0
    if not (cmd[1].isnumeric()):
        print(bcolors.FAIL + "ERROR: Invalid origin account number. [Digits Only]" + bcolors.ENDC)
        return 0
    if len(cmd[2]) != 10:
        print(bcolors.FAIL + "ERROR: Invalid destination account number. [Length(10)]" + bcolors.ENDC)
        return 0
    if not (cmd[2].isnumeric()):
        print(bcolors.FAIL + "ERROR: Invalid destination account number. [Digits Only]" + bcolors.ENDC)
        return 0
    if len(cmd[3]) > 11:
        print(bcolors.FAIL + "ERROR: Out of range amount. [Length(11)]" + bcolors.ENDC)
        return 0
    if float(cmd[3]) < 0:
        print(bcolors.FAIL + "ERROR: Invalid amount. [Positive Number Only]" + bcolors.ENDC)
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split()
    if replay[0] == "ok":
        print(bcolors.OKGREEN + "Deposit was successful." + bcolors.ENDC)
        return 1  # Deposit was successful
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no account with the given from_account_no." + bcolors.ENDC)
        return 0  # Deposit was failed
    elif replay[0] == "E1":
        print(bcolors.FAIL + "ERROR: There is no account with the given to_account_no." + bcolors.ENDC)
        return 0  # Deposit was failed
    elif replay[0] == "E2":
        print(bcolors.FAIL + "ERROR: Access denied. You are not permitted to withdraw from this account" + bcolors.ENDC)
        return 0  # Deposit was failed
    elif replay[0] == "E3":
        print(bcolors.FAIL + "ERROR: Your account balance is not enough." + bcolors.ENDC)
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


def Join(command, cmd, client, key):
    """
    :param command: Join [account_no]
    :param cmd: list('Join', account_no)
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    if len(cmd[1]) != 10:
        print(bcolors.FAIL + "ERROR: Invalid account number. [Length(10)]" + bcolors.ENDC)
        return 0
    if not (cmd[1].isnumeric()):
        print(bcolors.FAIL + "ERROR: Invalid account number. [Digits Only]" + bcolors.ENDC)
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split()
    if replay[0] == "ok":
        print(bcolors.OKGREEN + "Join request sent to the account owner successfully." + bcolors.ENDC)
        return 1  # join request sent successfully
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no account with the given account_no." + bcolors.ENDC)
        return 0  # join request failed
    elif replay[0] == "E1":
        print(
            bcolors.FAIL + "ERROR: This account is yours so you can not send join request for yourself" + bcolors.ENDC)
        return 0  # join request failed
    elif replay[0] == "E2":
        print(
            bcolors.FAIL + "ERROR: you have joint to this account before so you can not send join request for it again"
            + bcolors.ENDC)
        return 0  # join request failed


def key_exchange(client):
    global HP
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
    if not HP:
        print(bcolors.OKBLUE + "Key exchanged successfully.\n" + bcolors.ENDC)
    return session_key


def Login(command, client, key):
    global HP
    while True:
        range_start = 10 ** 4
        range_end = (10 ** 5) - 1
        random_number = randint(range_start, range_end)
        if int(input(bcolors.WARNING + "Please enter this number ({}): ".format(random_number) + bcolors.ENDC)) == random_number:
            break
        else:
            print(bcolors.FAIL + "ERROR: Wrong number. Please try again" + bcolors.ENDC)

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)

    replay = replay.split()
    if replay[0] == "ok":
        print(bcolors.OKGREEN + "Logged in successfully." + bcolors.ENDC)
        return 1  # Login successfully
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: Username do not match. Please try again" + bcolors.ENDC)
        return 0  # Login failed
    elif replay[0] == "E1":
        print(bcolors.FAIL + "ERROR: Password do not match. Please try again" + bcolors.ENDC)
        return 0  # Login failed
    elif replay[0] == "ban":
        print(bcolors.FAIL + "ERROR: Your Account is ban for {} seconds. try again later"
              .format(replay[1]) + bcolors.ENDC)
        return 0  # Login failed
    elif replay[0] == "honeypot":
        print(bcolors.FAIL + "ERROR: Password do not match. Please try again" + bcolors.ENDC)
        HP = 1
        return -1  # Login failed => go honeypot


def Show_Account(command, cmd, client, key):
    """
    :param command: Show_MyAccount
    :param cmd: List('Show_Account', account_no)
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    if len(cmd[1]) != 10:
        print(bcolors.FAIL + "ERROR: Invalid account number. [Length(10)]" + bcolors.ENDC)
        return 0
    if not (cmd[1].isnumeric()):
        print(bcolors.FAIL + "ERROR: Invalid account number. [Digits Only]" + bcolors.ENDC)
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split('~')
    if replay[0] == "ok":
        return [1, replay[1]]
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no account with the given account_no." + bcolors.ENDC)
        return [0]
    elif replay[0] == "E1":
        print(bcolors.FAIL + "ERROR: Access denied. You are not permitted to get this account's information"
              + bcolors.ENDC)
        return [0]


def Show_MyAccount(command, client, key):
    """
    :param command: Show_MyAccount
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split('~')
    if replay[0] == "ok":
        return [1, replay[1]]
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no account registered for your username yet." + bcolors.ENDC)
        return [0]


def Show_MyJoinRequests(command, client, key):
    """
    :param command: Show_MyJoinRequests
    :param client: socket of current client to server
    :param key: session key
    :return: status code (1: successful, 0: failure)
    """
    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split('~')
    if replay[0] == "ok":
        return [1, replay[1]]
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no account registered for your username yet." + bcolors.ENDC)
        return [0]


def Signup(command, client, key):
    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)

    replay = replay.split()
    if replay[0] == "ok":
        print(bcolors.OKGREEN + "Signup successfully." + bcolors.ENDC)
        return 1  # Signup successfully
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: This username already exists. Please select another one." + bcolors.ENDC)
        return 0  # Signup failed
    elif replay[0] == "E1":
        print(bcolors.FAIL + "ERROR: Password is not strong enough. {}".format(replay[3:]) + bcolors.ENDC)
        return 0  # Signup failed
    elif replay[0] == "E2":
        print(bcolors.FAIL + "ERROR: Failed to sign up. Please try again." + bcolors.ENDC)
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
        print(bcolors.FAIL + "ERROR: Invalid account number. [Length(10)]" + bcolors.ENDC)
        return 0
    if not (cmd[1].isnumeric()):
        print(bcolors.FAIL + "ERROR: Invalid account number. [Digits Only]" + bcolors.ENDC)
        return 0
    if len(cmd[2]) > 11:
        print(bcolors.FAIL + "ERROR: Out of range amount. [Length(11)]" + bcolors.ENDC)
        return 0
    if float(cmd[2]) < 0:
        print(bcolors.FAIL + "ERROR: Invalid amount. [Positive Number Only]" + bcolors.ENDC)
        return 0

    command = encrypt(command, key)
    client.send(command.encode('utf-8'))

    replay = client.recv(1024)
    replay = replay.decode('utf-8')
    replay = decrypt(replay, key)
    replay = replay.split()
    if replay[0] == "ok":
        print(bcolors.OKGREEN + "Withdrawal was successful." + bcolors.ENDC)
        return 1  # Withdrawal was successful
    elif replay[0] == "E0":
        print(bcolors.FAIL + "ERROR: There is no account with the given account_no." + bcolors.ENDC)
        return 0  # Withdrawal was failed
    elif replay[0] == "E1":
        print(bcolors.FAIL + "ERROR: Access denied. You are not permitted to withdraw from this account" + bcolors.ENDC)
        return 0  # Withdrawal was failed
    elif replay[0] == "E2":
        print(bcolors.FAIL + "ERROR: Your account balance is not enough." + bcolors.ENDC)
        return 0  # Withdrawal was failed


if __name__ == '__main__':
    login = False
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    if client == 0:
        print(bcolors.FAIL + "ERROR: Unable to create client socket !!!" + bcolors.ENDC)

    client.connect((socket.gethostname(), 8080))
    print(bcolors.WARNING + "Connecting to server ... \n" + bcolors.ENDC)

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
                '\tCreate              \tCreate [account_type] [amount] [conf_label] [integrity_label]\n' +
                '\t|____ Account Types:  \n' +
                '\t|\t |___ Short-term saving account = 0\n' +
                '\t|\t |___ Long-term saving account = 1\n' +
                '\t|\t |___ Current account = 2\n' +
                '\t|\t |___ Gharz al-Hasna saving account = 3\n' +
                '\t|____ Confidentiality labels:    \n' +
                '\t|\t |___ TopSecret\n' +
                '\t|\t |___ Secret\n' +
                '\t|\t |___ Confidential\n' +
                '\t|\t |___ Unclassified\n' +
                '\t|____ Integrity labels:    \n' +
                '\t|\t |___ VeryTrusted\n' +
                '\t|\t |___ Trusted\n' +
                '\t|\t |___ SlightlyTrusted\n' +
                '\t|\t |___ Untrusted\n' +
                '\tJoin                \tJoin [account_no]\n' +
                '\tShow_MyJoinRequests \tShow_MyJoinRequests\n' +
                '\tAccept              \tAccept [username] [conf_label] [integrity_label]\n' +
                '\tShow_MyAccount      \tShow_MyAccount\n' +
                '\tShow_Account        \tShow_Account [account_no]\n' +
                '\tDeposit             \tDeposit [from_account_no] [to_account_no] [amount]\n' +
                '\tWithdraw            \tWithdraw [account_no] [amount]\n' +
                '\tHelp\n' +
                '\tExit\n'
        )

        print(bcolors.HEADER + help_message1 + bcolors.ENDC)

        while True:
            command = input(bcolors.HEADER + '> ' + bcolors.ENDC)
            cmd = command.split()

            if login:
                if cmd[0] == "Create" and len(cmd) == 5:
                    Create(command, cmd, client, session_key)

                elif cmd[0] == "Join" and len(cmd) == 2:
                    Join(command, cmd, client, session_key)

                elif cmd[0] == "Show_MyJoinRequests" and len(cmd) == 1:
                    replay = Show_MyJoinRequests(command, client, session_key)
                    if replay[0]:
                        print(bcolors.WARNING + replay[1] + bcolors.ENDC)

                elif cmd[0] == "Accept" and len(cmd) == 4:
                    Accept(command, cmd, client, session_key)

                elif cmd[0] == "Show_MyAccount" and len(cmd) == 1:
                    replay = Show_MyAccount(command, client, session_key)
                    if replay[0]:
                        print(bcolors.WARNING + replay[1] + bcolors.ENDC)

                elif cmd[0] == "Show_Account" and len(cmd) == 2:
                    replay = Show_Account(command, cmd, client, session_key)
                    if replay[0]:
                        print(bcolors.WARNING + replay[1] + bcolors.ENDC)

                elif cmd[0] == "Deposit" and len(cmd) == 4:
                    Deposit(command, cmd, client, session_key)

                elif cmd[0] == "Withdraw" and len(cmd) == 3:
                    Withdraw(command, cmd, client, session_key)

                elif cmd[0] == "Help" and len(cmd) == 1:
                    print(bcolors.HEADER + help_message2 + bcolors.ENDC)

                elif cmd[0] == "Exit" and len(cmd) == 1:
                    command = encrypt(command, session_key)
                    client.send(command.encode('utf-8'))
                    replay = client.recv(1024)
                    replay = replay.decode('utf-8')
                    replay = decrypt(replay, session_key)
                    print(bcolors.OKCYAN + replay + bcolors.ENDC)
                    break

                else:
                    print(bcolors.WARNING + "Command is wrong!!!" + bcolors.ENDC)

            else:
                if cmd[0] == "Signup" and len(cmd) == 3:
                    Signup(command, client, session_key)

                elif cmd[0] == "Login" and len(cmd) == 3:
                    log = Login(command, client, session_key)
                    if log == 1:
                        print()
                        print(bcolors.HEADER + help_message2 + bcolors.ENDC)
                        login = True
                    # honeypot
                    elif log == -1:
                        client.close()
                        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                        client.connect((socket.gethostname(), 8000))
                        data = client.recv(1024)
                        data = data.decode('utf-8')
                        if data == "Server Is Busy !!":
                            print(bcolors.FAIL + "Internal Server Error: Service Unavailable !!" + bcolors.ENDC)
                            client.close()
                            break
                        else:
                            session_key = key_exchange(client)

                elif cmd[0] == "Help" and len(cmd) == 1:
                    print(bcolors.HEADER + help_message1 + bcolors.ENDC)

                elif cmd[0] == "Exit" and len(cmd) == 1:
                    command = encrypt(command, session_key)
                    client.send(command.encode('utf-8'))
                    replay = client.recv(1024)
                    replay = replay.decode('utf-8')
                    replay = decrypt(replay, session_key)
                    print(bcolors.OKCYAN + replay + bcolors.ENDC)
                    break

                else:
                    print(bcolors.WARNING + "Command is wrong!!!" + bcolors.ENDC)

        client.close()
