USE securebankingsystem
GO


DROP TABLE IF EXISTS User;
CREATE TABLE User (
  username VARCHAR(50) PRIMARY KEY,
  `password` VARCHAR(200) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS Account;
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
  amount DECIMAL(15, 4) NOT NULL,
	conf_lable VARCHAR(1) CHECK(conf_lable IN ('1','2','3','4') ),
	integrity_lable VARCHAR(1) CHECK(integrity_lable IN ('1','2','3','4')),
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (opener_ID) REFERENCES User(username)
);
ALTER TABLE Account AUTO_INCREMENT = 1000000000;


DROP TABLE IF EXISTS Account_User;
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


DROP TABLE IF EXISTS `Transaction`;
CREATE TABLE `Transaction` (
  transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  from_account_no INT(10) NOT NULL,
  to_account_no INT(10) NOT NULL,
  amount DECIMAL(7, 4) NOT NULL,
  `status` VARCHAR(1) CHECK(`status` IN ('1', '0') ),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (username) REFERENCES User(username),
  FOREIGN KEY (from_account_no) REFERENCES Account(account_no),
  FOREIGN KEY (to_account_no) REFERENCES Account(account_no)
);


DROP TABLE IF EXISTS Join_Request;
CREATE TABLE Join_Request (
  join_ID INT AUTO_INCREMENT PRIMARY KEY,
  applicant_username VARCHAR(50) NOT NULL,
  desired_account_no INT(10) NOT NULL,
  `status` VARCHAR(1) NOT NULL DEFAULT '0' CHECK(`status` IN ('0', '1')), -- 0: pending, 1: accept
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (applicant_username) REFERENCES User(username),
  FOREIGN KEY (desired_account_no) REFERENCES Account(account_no)
);


DROP TABLE IF EXISTS Signup_Request_Log;
CREATE TABLE Signup_Request_Log (
  signup_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  `password` VARCHAR(200) NOT NULL,
	`status` VARCHAR(1) CHECK(`status` IN ('1', '0') ),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


CREATE OR REPLACE TABLE Login_Request_Log (
  login_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
	`password` VARCHAR(200) NOT NULL,
	`status` VARCHAR(1) CHECK(`status` in ('1', '0') ),
	ip VARCHAR(20) NOT NULL,
	port VARCHAR(20) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE IF EXISTS Ban_Users;
CREATE TABLE Ban_Users(
	username VARCHAR(50) NOT NULL,
	ban_times INT NOT NULL DEFAULT 0,
	started_at DATETIME,
  finished_at DATETIME,
  FOREIGN KEY (username) REFERENCES User(username)
);
