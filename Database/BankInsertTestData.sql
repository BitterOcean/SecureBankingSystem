USE securebankingsystem
GO

-- User
DELETE FROM User;
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-1', 'Test-password-1', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-2', 'Test-password-2', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-3', 'Test-password-3', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-4', 'Test-password-4', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-5', 'Test-password-5', '1234');

-- Account
DELETE FROM Account;
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-1', 'Short-term saving account', 1000000, '1', '1');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-2', 'Short-term saving account', 1000000, '2', '2');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-3', 'Short-term saving account', 1000000, '3', '3');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-4', 'Short-term saving account', 1000000, '4', '4');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-5', 'Short-term saving account', 1000000, '1', '2');

-- Account-User
DELETE FROM Account_User;
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000001, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000002, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000003, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000004, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-2', 1000000000, '1', '1');

-- Transaction
DELETE FROM `Transaction`;
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount, `status`) VALUES ('Test-username-1', 1000000000, 1000000001, 100000, '1'); -- deposit
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount, `status`) VALUES ('Test-username-1', 1000000000, 1000000000, -100000, '1'); -- withdraw
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount, `status`) VALUES ('Test-username-1', 1000000000, 1000000001, 200000, '1'); -- deposit
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount, `status`) VALUES ('Test-username-1', 1000000000, 1000000000, -200000, '1'); -- withdraw
