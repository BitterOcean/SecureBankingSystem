-- conf_label = {
--   "TopSecret"    : '1',
--   "Secret"       : '2',
--   "Confidential" : '3',
--   "Unclassified" : '4',
-- }

-- integrity_label = {
--   "VeryTrusted"    : '1',
--   "Trusted"        : '2',
--   "SlightlyTrusted": '3',
--   "Untrusted"      : '4',
-- }
USE securebankingsystem
GO

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Account_User;
DROP TABLE IF EXISTS `Transaction`;
DROP TABLE IF EXISTS Join_Request;
DROP TABLE IF EXISTS Signup_Request_Log;
DROP TABLE IF EXISTS Login_Request_Log;
DROP TABLE IF EXISTS Create_Request_Log;
DROP TABLE IF EXISTS Join_Request_Log;
DROP TABLE IF EXISTS Accept_Request_Log;
drop TABLE IF EXISTS ShowMyJoinRequests_Log;
DROP TABLE IF EXISTS ShowMyAccount_Request_Log;
DROP TABLE IF EXISTS ShowAccount_Request_Log;
DROP TABLE IF EXISTS Deposit_Request_Log;
DROP TABLE IF EXISTS Withdraw_Request_Log;
DROP TABLE IF EXISTS Ban_Users;
SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE User (
  username VARCHAR(50) PRIMARY KEY,
  `password` VARCHAR(200) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Account (
  account_no INT(10) AUTO_INCREMENT PRIMARY KEY,
  opener_ID VARCHAR(50) NOT NULL,
  `type` VARCHAR(30) NOT NULL
    CHECK(type IN (
      'Short-term saving account',
      'Long-term saving account',
      'Current account',
      'Gharz al-Hasna saving account'
    )),
  amount DECIMAL(19, 4) NOT NULL,
	conf_lable VARCHAR(1) CHECK(conf_lable IN ('1','2','3','4') ),
	integrity_lable VARCHAR(1) CHECK(integrity_lable IN ('1','2','3','4')),
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL,
	FOREIGN KEY (opener_ID) REFERENCES User(username)
);
ALTER TABLE Account AUTO_INCREMENT = 1000000000;


CREATE TABLE Account_User (
  account_user_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  account_no INT(10) NOT NULL,
  conf_lable VARCHAR(1) CHECK(conf_lable IN ('1','2','3','4') ),
	integrity_lable VARCHAR(1) CHECK(integrity_lable IN ('1','2','3','4')),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (username) REFERENCES User(username),
  FOREIGN KEY (account_no) REFERENCES Account(account_no)
);


CREATE TABLE `Transaction` (
  transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  from_account_no INT(10) NOT NULL,
  to_account_no INT(10) NOT NULL,
  amount DECIMAL(11, 4) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (username) REFERENCES User(username),
  FOREIGN KEY (from_account_no) REFERENCES Account(account_no),
  FOREIGN KEY (to_account_no) REFERENCES Account(account_no)
);


CREATE TABLE Join_Request (
  join_ID INT AUTO_INCREMENT PRIMARY KEY,
  applicant_username VARCHAR(50) NOT NULL,
  desired_account_no INT(10) NOT NULL,
  `status` VARCHAR(1) NOT NULL DEFAULT '0' CHECK(`status` IN ('0', '1')), -- 0: pending, 1: accept
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL,
  FOREIGN KEY (applicant_username) REFERENCES User(username),
  FOREIGN KEY (desired_account_no) REFERENCES Account(account_no)
);


CREATE TABLE Signup_Request_Log (
  signup_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NULL,
  `password` VARCHAR(300) NULL,
  salt VARCHAR(100) NULL,
	`status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Login_Request_Log (
  login_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NULL,
	`password` VARCHAR(300) NULL,
  salt VARCHAR(100) NULL,
	ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
	`status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Join_Request_Log (
  join_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  applicant_username VARCHAR(50) NULL,
  desired_account_no INT(50) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Accept_Request_Log (
  accept_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  sender_username VARCHAR(50) NULL,
  applicant_username VARCHAR(50) NULL,
  conf_lable VARCHAR(1) NULL,
	integrity_lable VARCHAR(1) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ShowMyAccount_Request_Log (
  showMyAccount_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ShowMyJoinRequests_Log (
  showMyJoinRequests_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ShowAccount_Request_Log (
  showAccount_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NULL,
  account_no INT(50) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Deposit_Request_Log (
  deposit_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NULL,
  from_account_no INT(20) NULL,
  to_account_no INT(20) NULL,
  amount DECIMAL(11, 4) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Withdraw_Request_Log (
  deposit_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NULL,
  account_no INT(20) NULL,
  amount DECIMAL(11, 4) NULL,
  ip VARCHAR(20) NULL,
	port VARCHAR(20) NULL,
  `status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Ban_Users(
	username VARCHAR(50) NOT NULL,
	ban_times INT NOT NULL DEFAULT 0,
	started_at DATETIME,
  finished_at DATETIME,
  FOREIGN KEY (username) REFERENCES User(username)
);


CREATE OR REPLACE VIEW fail_login_count
AS
	SELECT username, COUNT(*) AS login_counts
	FROM Login_Request_Log
	WHERE TIMESTAMPDIFF(HOUR,created_at ,CURRENT_TIMESTAMP) <= 24
    AND status = '0'
    AND username IN(SELECT username FROM User)
	GROUP BY username;


CREATE OR REPLACE VIEW login_audit
AS
	SELECT DISTINCT username, ip, port, COUNT(*) AS num_of_tries
	FROM Login_Request_Log
	  INNER JOIN fail_login_count USING (username)
	WHERE TIMESTAMPDIFF(HOUR,created_at ,CURRENT_TIMESTAMP) <= 24
	  AND status = '0'
    AND login_counts >= 10
  GROUP BY username, ip, port
  ORDER BY username DESC;
