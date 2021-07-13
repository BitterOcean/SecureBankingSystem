-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 14, 2021 at 12:14 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `securebankingsystem`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_account` (IN `_account_no` VARCHAR(10), IN `_username` VARCHAR(50), IN `_type` VARCHAR(30), IN `_amount` DECIMAL(15,4), IN `_conf_lable` VARCHAR(1), IN `_integrity_lable` VARCHAR(1))  BEGIN
	START TRANSACTION;
	INSERT INTO account (account_no, opener_ID, `type`, amount, conf_lable, integrity_lable)
	VALUES (_account_no, _username, _type, _amount, _conf_lable, _integrity_lable);
    INSERT INTO account_user(username, account_no, conf_lable, integrity_lable)
    VALUES (_username, _account_no, _conf_lable, _integrity_lable);
	COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `add_user` (IN `_username` VARCHAR(50), IN `_password` VARCHAR(200), IN `_salt` VARCHAR(100))  BEGIN
	START TRANSACTION;
	INSERT INTO user (username, `password`, salt)
	VALUES (_username, _password, _salt);
	COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_account_number` (IN `_account_no` VARCHAR(10), OUT `_status` INT)  BEGIN
	DECLARE NumOfAccounts DECIMAL DEFAULT 0;
    SELECT COUNT(*)
    INTO NumOfAccounts
    FROM account
    WHERE account_no = _account_no;
    IF NumOfAccounts > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_ban` (IN `_username` VARCHAR(50), OUT `_status` INT, OUT `remaining_time` INT)  BEGIN
	DECLARE ban DECIMAL DEFAULT 0;
    
    SELECT COUNT(*)
    INTO ban
    FROM ban_users
    WHERE username = _username and ban_times <> 0 
    and CURRENT_TIMESTAMP < finished_at;
    
    SELECT TIME_TO_SEC(TIMEDIFF(finished_at, CURRENT_TIMESTAMP)) diff
    INTO remaining_time
    FROM ban_users
    WHERE username = _username;
    
    IF ban > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
        SET remaining_time = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `check_user` (IN `_username` VARCHAR(50), OUT `_status` INT)  BEGIN
	DECLARE NumOfUsers DECIMAL DEFAULT 0;
    SELECT COUNT(*)
    INTO NumOfUsers
    FROM user
    WHERE username = _username;
    IF NumOfUsers > 0 THEN
        SET _status = 1;
    ELSE
        SET _status = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_password_salt` (IN `_username` VARCHAR(50), OUT `_password` VARCHAR(200), OUT `_salt` VARCHAR(100))  BEGIN
    SELECT `password`
    INTO _password
    FROM user
    WHERE username = _username;
    SELECT salt
    INTO _salt
    FROM user
    WHERE username = _username;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_ban` (IN `_username` VARCHAR(50))  BEGIN
	DECLARE _ban_times INT DEFAULT 0;
	SELECT ban_times
    INTO _ban_times
    FROM ban_users
    WHERE username = _username;
	
    START TRANSACTION;
	UPDATE ban_users
    SET
    	ban_times = _ban_times + 1,
        started_at = CURRENT_TIMESTAMP,
        finished_at = CURRENT_TIMESTAMP + INTERVAL 30 SECOND
    WHERE
    	username = _username;
	COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `account`
--

CREATE TABLE `account` (
  `account_no` varchar(10) NOT NULL,
  `opener_ID` varchar(50) NOT NULL,
  `type` varchar(30) NOT NULL CHECK (`type` in ('Short-term saving account','Long-term saving account','Current account','Gharz al-Hasna saving account')),
  `amount` decimal(15,4) NOT NULL,
  `conf_lable` varchar(1) DEFAULT NULL CHECK (`conf_lable` in ('1','2','3','4')),
  `integrity_lable` varchar(1) DEFAULT NULL CHECK (`integrity_lable` in ('1','2','3','4')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `account_user`
--

CREATE TABLE `account_user` (
  `account_user_ID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `account_no` varchar(10) NOT NULL,
  `conf_lable` varchar(1) DEFAULT NULL CHECK (`conf_lable` in ('1','2','3','4')),
  `integrity_lable` varchar(1) DEFAULT NULL CHECK (`integrity_lable` in ('1','2','3','4')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ban_users`
--

CREATE TABLE `ban_users` (
  `username` varchar(50) NOT NULL,
  `ban_times` int(11) NOT NULL DEFAULT 0,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ban_users`
--

INSERT INTO `ban_users` (`username`, `ban_times`, `started_at`, `finished_at`) VALUES
('mazrouee99', 7, '2021-07-14 02:38:32', '2021-07-14 02:39:02');

-- --------------------------------------------------------

--
-- Table structure for table `login_request_log`
--

CREATE TABLE `login_request_log` (
  `login_log_ID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(200) NOT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `mac` varchar(20) NOT NULL,
  `ip` varchar(20) NOT NULL,
  `port` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `signup_request_log`
--

CREATE TABLE `signup_request_log` (
  `signup_log_ID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `transaction_ID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `from_account_no` varchar(10) NOT NULL,
  `to_account_no` varchar(10) NOT NULL,
  `amount` decimal(7,4) NOT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `username` varchar(50) NOT NULL,
  `password` varchar(200) NOT NULL,
  `salt` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`username`, `password`, `salt`, `created_at`) VALUES
('mazrouee99', '12345', 'gjjk', '2021-07-14 01:30:42');

--
-- Triggers `user`
--
DELIMITER $$
CREATE TRIGGER `auto_insert_ban_user` AFTER INSERT ON `user` FOR EACH ROW INSERT INTO Ban_Users ( username, ban_times, started_at, finished_at )
    VALUES(NEW.username, 0, NULL, NULL)
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD PRIMARY KEY (`account_no`),
  ADD KEY `opener_ID` (`opener_ID`);

--
-- Indexes for table `account_user`
--
ALTER TABLE `account_user`
  ADD PRIMARY KEY (`account_user_ID`),
  ADD KEY `username` (`username`),
  ADD KEY `account_no` (`account_no`);

--
-- Indexes for table `ban_users`
--
ALTER TABLE `ban_users`
  ADD KEY `username` (`username`);

--
-- Indexes for table `login_request_log`
--
ALTER TABLE `login_request_log`
  ADD PRIMARY KEY (`login_log_ID`);

--
-- Indexes for table `signup_request_log`
--
ALTER TABLE `signup_request_log`
  ADD PRIMARY KEY (`signup_log_ID`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_ID`),
  ADD KEY `username` (`username`),
  ADD KEY `from_account_no` (`from_account_no`),
  ADD KEY `to_account_no` (`to_account_no`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_user`
--
ALTER TABLE `account_user`
  MODIFY `account_user_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `login_request_log`
--
ALTER TABLE `login_request_log`
  MODIFY `login_log_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `signup_request_log`
--
ALTER TABLE `signup_request_log`
  MODIFY `signup_log_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `account`
--
ALTER TABLE `account`
  ADD CONSTRAINT `account_ibfk_1` FOREIGN KEY (`opener_ID`) REFERENCES `user` (`username`);

--
-- Constraints for table `account_user`
--
ALTER TABLE `account_user`
  ADD CONSTRAINT `account_user_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `account_user_ibfk_2` FOREIGN KEY (`account_no`) REFERENCES `account` (`account_no`);

--
-- Constraints for table `ban_users`
--
ALTER TABLE `ban_users`
  ADD CONSTRAINT `ban_users_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`username`) REFERENCES `user` (`username`),
  ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`from_account_no`) REFERENCES `account` (`account_no`),
  ADD CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`to_account_no`) REFERENCES `account` (`account_no`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
