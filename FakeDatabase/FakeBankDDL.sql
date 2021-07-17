USE fakebankingsystem
GO

DROP TABLE IF EXISTS Ban_Users;
DROP TABLE IF EXISTS Login_Request_Log;
DROP TABLE IF EXISTS Signup_Request_Log;


CREATE TABLE Ban_Users(
	username VARCHAR(50) NOT NULL,
	ban_times INT NOT NULL DEFAULT 0,
	started_at DATETIME,
  finished_at DATETIME
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


CREATE TABLE Signup_Request_Log (
  signup_log_ID INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NULL,
  `password` VARCHAR(300) NULL,
  salt VARCHAR(100) NULL,
	`status` VARCHAR(1) CHECK(`status` in ('1', '0') ), -- 0: failure, 1: successful
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);