USE securebankingsystem
GO

-- -- Make DB empty
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `Transaction`;
TRUNCATE TABLE Account_User;
TRUNCATE TABLE Join_Request;
TRUNCATE TABLE Account;
TRUNCATE TABLE Ban_Users;
TRUNCATE TABLE User;
TRUNCATE TABLE Signup_Request_Log;
TRUNCATE TABLE Login_Request_Log;
SET FOREIGN_KEY_CHECKS = 1;
ALTER TABLE Account AUTO_INCREMENT = 1000000000;

-- User
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-1', 'Test-password-1', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-2', 'Test-password-2', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-3', 'Test-password-3', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-4', 'Test-password-4', '1234');
INSERT INTO User (username, `password`, salt) VALUES ('Test-username-5', 'Test-password-5', '1234');

-- Account
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-1', 'Short-term saving account', 1000000, '1', '1');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-2', 'Short-term saving account', 1000000, '2', '2');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-3', 'Short-term saving account', 1000000, '3', '3');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-4', 'Short-term saving account', 1000000, '4', '4');
INSERT INTO Account (opener_ID, `type`, amount, conf_lable, integrity_lable) VALUES ('Test-username-5', 'Short-term saving account', 1000000, '1', '2');

-- Account-User
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000001, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000002, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000003, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-1', 1000000004, '1', '1');
INSERT INTO Account_User (username, account_no, conf_lable, integrity_lable) VALUES ('Test-username-2', 1000000000, '1', '1');

-- Transaction
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount) VALUES ('Test-username-1', 1000000000, 1000000001, 100000); -- deposit
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount) VALUES ('Test-username-1', 1000000000, 1000000000, -100000); -- withdraw
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount) VALUES ('Test-username-1', 1000000000, 1000000001, 200000); -- deposit
INSERT INTO `Transaction` (username, from_account_no, to_account_no, amount) VALUES ('Test-username-1', 1000000000, 1000000000, -200000); -- withdraw

-- Join Request
INSERT INTO Join_Request (applicant_username, desired_account_no, `status`) VALUES ('Test-username-2', 1000000002, '0');
INSERT INTO Join_Request (applicant_username, desired_account_no, `status`) VALUES ('Test-username-2', 1000000003, '0');
INSERT INTO Join_Request (applicant_username, desired_account_no, `status`) VALUES ('Test-username-2', 1000000004, '0');

-- Accept Join_Request
CALL accept_join_request('Test-username-2', 1000000002, '1', '2');