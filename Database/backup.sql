-- MariaDB dump 10.19  Distrib 10.5.11-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: securebankingsystem
-- ------------------------------------------------------
-- Server version	10.5.11-MariaDB-1:10.5.11+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Accept_Request_Log`
--

DROP TABLE IF EXISTS `Accept_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Accept_Request_Log` (
  `accept_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `sender_username` varchar(50) DEFAULT NULL,
  `applicant_username` varchar(50) DEFAULT NULL,
  `conf_lable` varchar(1) DEFAULT NULL,
  `integrity_lable` varchar(1) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`accept_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Accept_Request_Log`
--

LOCK TABLES `Accept_Request_Log` WRITE;
/*!40000 ALTER TABLE `Accept_Request_Log` DISABLE KEYS */;
INSERT INTO `Accept_Request_Log` VALUES (1,'mamad','maryam','1','1','192.168.43.82','48110','1','2021-07-17 00:58:39'),(2,'maryam','boo','4','3','192.168.43.82','48108','1','2021-07-17 01:04:59');
/*!40000 ALTER TABLE `Accept_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Account`
--

DROP TABLE IF EXISTS `Account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Account` (
  `account_no` int(10) NOT NULL AUTO_INCREMENT,
  `opener_ID` varchar(50) NOT NULL,
  `type` varchar(30) NOT NULL CHECK (`type` in ('Short-term saving account','Long-term saving account','Current account','Gharz al-Hasna saving account')),
  `amount` decimal(19,4) NOT NULL,
  `conf_lable` varchar(1) DEFAULT NULL CHECK (`conf_lable` in ('1','2','3','4')),
  `integrity_lable` varchar(1) DEFAULT NULL CHECK (`integrity_lable` in ('1','2','3','4')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`account_no`),
  KEY `opener_ID` (`opener_ID`),
  CONSTRAINT `Account_ibfk_1` FOREIGN KEY (`opener_ID`) REFERENCES `User` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000003 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO `Account` VALUES (1000000000,'maryam','Short-term saving account',1000000.0000,'1','1','2021-07-17 00:57:13',NULL),(1000000001,'mamad','Short-term saving account',1000000.0000,'1','1','2021-07-17 00:57:54',NULL),(1000000002,'boo','Short-term saving account',1000000.0000,'3','2','2021-07-17 01:04:03',NULL);
/*!40000 ALTER TABLE `Account` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER auto_account_updated_at
BEFORE UPDATE
ON Account
FOR EACH ROW
  SET NEW.updated_at = CURRENT_TIMESTAMP */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Account_User`
--

DROP TABLE IF EXISTS `Account_User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Account_User` (
  `account_user_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `account_no` int(10) NOT NULL,
  `conf_lable` varchar(1) DEFAULT NULL CHECK (`conf_lable` in ('1','2','3','4')),
  `integrity_lable` varchar(1) DEFAULT NULL CHECK (`integrity_lable` in ('1','2','3','4')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`account_user_ID`),
  KEY `username` (`username`),
  KEY `account_no` (`account_no`),
  CONSTRAINT `Account_User_ibfk_1` FOREIGN KEY (`username`) REFERENCES `User` (`username`),
  CONSTRAINT `Account_User_ibfk_2` FOREIGN KEY (`account_no`) REFERENCES `Account` (`account_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account_User`
--

LOCK TABLES `Account_User` WRITE;
/*!40000 ALTER TABLE `Account_User` DISABLE KEYS */;
INSERT INTO `Account_User` VALUES (1,'maryam',1000000001,'1','1','2021-07-17 00:58:39'),(2,'boo',1000000000,'4','3','2021-07-17 01:04:59');
/*!40000 ALTER TABLE `Account_User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ban_Users`
--

DROP TABLE IF EXISTS `Ban_Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ban_Users` (
  `username` varchar(50) NOT NULL,
  `ban_times` int(11) NOT NULL DEFAULT 0,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  KEY `username` (`username`),
  CONSTRAINT `Ban_Users_ibfk_1` FOREIGN KEY (`username`) REFERENCES `User` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ban_Users`
--

LOCK TABLES `Ban_Users` WRITE;
/*!40000 ALTER TABLE `Ban_Users` DISABLE KEYS */;
INSERT INTO `Ban_Users` VALUES ('maryam',0,NULL,NULL),('mamad',0,NULL,NULL),('boo',0,NULL,NULL);
/*!40000 ALTER TABLE `Ban_Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Deposit_Request_Log`
--

DROP TABLE IF EXISTS `Deposit_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Deposit_Request_Log` (
  `deposit_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `from_account_no` int(20) DEFAULT NULL,
  `to_account_no` int(20) DEFAULT NULL,
  `amount` decimal(11,4) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`deposit_log_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Deposit_Request_Log`
--

LOCK TABLES `Deposit_Request_Log` WRITE;
/*!40000 ALTER TABLE `Deposit_Request_Log` DISABLE KEYS */;
/*!40000 ALTER TABLE `Deposit_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Join_Request`
--

DROP TABLE IF EXISTS `Join_Request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Join_Request` (
  `join_ID` int(11) NOT NULL AUTO_INCREMENT,
  `applicant_username` varchar(50) NOT NULL,
  `desired_account_no` int(10) NOT NULL,
  `status` varchar(1) NOT NULL DEFAULT '0' CHECK (`status` in ('0','1')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`join_ID`),
  KEY `applicant_username` (`applicant_username`),
  KEY `desired_account_no` (`desired_account_no`),
  CONSTRAINT `Join_Request_ibfk_1` FOREIGN KEY (`applicant_username`) REFERENCES `User` (`username`),
  CONSTRAINT `Join_Request_ibfk_2` FOREIGN KEY (`desired_account_no`) REFERENCES `Account` (`account_no`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Join_Request`
--

LOCK TABLES `Join_Request` WRITE;
/*!40000 ALTER TABLE `Join_Request` DISABLE KEYS */;
INSERT INTO `Join_Request` VALUES (1,'maryam',1000000001,'1','2021-07-17 00:58:08','2021-07-17 00:58:39'),(2,'boo',1000000000,'1','2021-07-17 01:04:19','2021-07-17 01:04:59');
/*!40000 ALTER TABLE `Join_Request` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER auto_join_updated_at
BEFORE UPDATE
ON Join_Request
FOR EACH ROW
  SET NEW.updated_at = CURRENT_TIMESTAMP */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Join_Request_Log`
--

DROP TABLE IF EXISTS `Join_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Join_Request_Log` (
  `join_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `applicant_username` varchar(50) DEFAULT NULL,
  `desired_account_no` int(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`join_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Join_Request_Log`
--

LOCK TABLES `Join_Request_Log` WRITE;
/*!40000 ALTER TABLE `Join_Request_Log` DISABLE KEYS */;
INSERT INTO `Join_Request_Log` VALUES (1,'maryam',1000000001,'192.168.43.82','48108','1','2021-07-17 00:58:08'),(2,'boo',1000000000,'192.168.43.82','48118','1','2021-07-17 01:04:19');
/*!40000 ALTER TABLE `Join_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Login_Request_Log`
--

DROP TABLE IF EXISTS `Login_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Login_Request_Log` (
  `login_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(300) DEFAULT NULL,
  `salt` varchar(100) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`login_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Login_Request_Log`
--

LOCK TABLES `Login_Request_Log` WRITE;
/*!40000 ALTER TABLE `Login_Request_Log` DISABLE KEYS */;
INSERT INTO `Login_Request_Log` VALUES (1,'maryam','f4c42e53c6bb80ca3aa0cda2b6453772a656426b776ffda38dd6eb8f6d33912d','zBoWLjTeGzPddwSOhudiooIQo','192.168.43.82','48102','0','2021-07-17 00:55:36'),(2,'maryam','3c5c0e700c17e55cc06d1303524675e207981c77c008ca03e4716ae5beb53c98','GHSsWDzrhHaaDzqBRVxatofJE','192.168.43.82','48104','0','2021-07-17 00:56:12'),(3,'maryam','99fc54aae37b2c9c21c5633624cbefe7cad56691080c1986ee8cd11b52d776a6','BnLwijIVChauuOTiDazzpGlhG','192.168.43.82','48104','0','2021-07-17 00:56:27'),(4,'maryam','874dba2cb905264d93f297319e953245ffe17a82c7c4bad73e7b0c209a3fc6e3','poHkWHehhfBsEoCTnXGzcwMUC','192.168.43.82','48108','1','2021-07-17 00:56:39'),(5,'mamad','013fef5d40b51b2e380bddfc1425a6507d7fa49b5596fa1631e959b6f73acdf9','fohLsaFnnttJfghxXTtFDatgK','192.168.43.82','48110','1','2021-07-17 00:57:31'),(6,'boo','7b86cd58b860d23e1f3f25c95d4e22e240bfbc219cde25b0cd233e970f6b9299','QBayxLzduYzKwjasLzzhgdOiC','192.168.43.82','48118','1','2021-07-17 01:03:05');
/*!40000 ALTER TABLE `Login_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ShowAccount_Request_Log`
--

DROP TABLE IF EXISTS `ShowAccount_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ShowAccount_Request_Log` (
  `showAccount_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `account_no` int(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`showAccount_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowAccount_Request_Log`
--

LOCK TABLES `ShowAccount_Request_Log` WRITE;
/*!40000 ALTER TABLE `ShowAccount_Request_Log` DISABLE KEYS */;
INSERT INTO `ShowAccount_Request_Log` VALUES (1,'maryam',1000000001,'192.168.43.82','48108','1','2021-07-17 01:00:37'),(2,'boo',1000000000,'192.168.43.82','48118','0','2021-07-17 01:05:19');
/*!40000 ALTER TABLE `ShowAccount_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ShowMyAccount_Request_Log`
--

DROP TABLE IF EXISTS `ShowMyAccount_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ShowMyAccount_Request_Log` (
  `showMyAccount_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`showMyAccount_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowMyAccount_Request_Log`
--

LOCK TABLES `ShowMyAccount_Request_Log` WRITE;
/*!40000 ALTER TABLE `ShowMyAccount_Request_Log` DISABLE KEYS */;
INSERT INTO `ShowMyAccount_Request_Log` VALUES (1,'maryam','192.168.43.82','48108','1','2021-07-17 00:58:53'),(2,'boo','192.168.43.82','48118','1','2021-07-17 01:05:10');
/*!40000 ALTER TABLE `ShowMyAccount_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ShowMyJoinRequests_Log`
--

DROP TABLE IF EXISTS `ShowMyJoinRequests_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ShowMyJoinRequests_Log` (
  `showMyJoinRequests_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`showMyJoinRequests_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowMyJoinRequests_Log`
--

LOCK TABLES `ShowMyJoinRequests_Log` WRITE;
/*!40000 ALTER TABLE `ShowMyJoinRequests_Log` DISABLE KEYS */;
INSERT INTO `ShowMyJoinRequests_Log` VALUES (1,'mamad','192.168.43.82','48110','1','2021-07-17 00:58:17'),(2,'maryam','192.168.43.82','48108','1','2021-07-17 01:04:26');
/*!40000 ALTER TABLE `ShowMyJoinRequests_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Signup_Request_Log`
--

DROP TABLE IF EXISTS `Signup_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Signup_Request_Log` (
  `signup_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(300) DEFAULT NULL,
  `salt` varchar(100) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`signup_log_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Signup_Request_Log`
--

LOCK TABLES `Signup_Request_Log` WRITE;
/*!40000 ALTER TABLE `Signup_Request_Log` DISABLE KEYS */;
INSERT INTO `Signup_Request_Log` VALUES (1,'maryam','0add76d7b93dd97496d52c0715bb3aadf3e0f3340eb46be2afe0b158dcf1a64f','PiYWTOoognyJpfbClhzmSgcnV','0','2021-07-17 00:54:45'),(2,'maryam','31b31ed9bc55d4d17009d48259bf97caae4501630f0a0dbb404003ba4a70f62b','nWlHMXYPjwIXkDhBZakWXTtat','1','2021-07-17 00:54:57'),(3,'mamad','1c8b6c0efcbc73e1227c1a640f25cded127d147ba2f7e88f9f9fca296fc5e3f9','wTZxjHsXsvzMvpQpkvhKlaZFL','0','2021-07-17 00:55:09'),(4,'mamad','5df98a556ff70d38f2107f9f2fa3eae14bbe1d65cfd807ce82ac2bc05d7dfa72','KtOnggXzUyrrgeBaXEFgASnRa','1','2021-07-17 00:55:24'),(5,'boo','b81479ac1ab6ace07af2c317658eaa140ccffb83238487b424aa6c512ff493bb','xjWXGoyAqhfPQBDwriDTukyve','1','2021-07-17 01:02:43');
/*!40000 ALTER TABLE `Signup_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Transaction`
--

DROP TABLE IF EXISTS `Transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Transaction` (
  `transaction_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `from_account_no` int(10) NOT NULL,
  `to_account_no` int(10) NOT NULL,
  `amount` decimal(11,4) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`transaction_ID`),
  KEY `username` (`username`),
  KEY `from_account_no` (`from_account_no`),
  KEY `to_account_no` (`to_account_no`),
  CONSTRAINT `Transaction_ibfk_1` FOREIGN KEY (`username`) REFERENCES `User` (`username`),
  CONSTRAINT `Transaction_ibfk_2` FOREIGN KEY (`from_account_no`) REFERENCES `Account` (`account_no`),
  CONSTRAINT `Transaction_ibfk_3` FOREIGN KEY (`to_account_no`) REFERENCES `Account` (`account_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transaction`
--

LOCK TABLES `Transaction` WRITE;
/*!40000 ALTER TABLE `Transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `Transaction` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER auto_update_account_balance_after_transaction
AFTER INSERT
ON `Transaction`
FOR EACH ROW
BEGIN
  
  UPDATE Account
  SET amount = CASE
                  WHEN amount + NEW.amount >= 0 THEN amount + NEW.amount
                  ELSE amount
                END
  WHERE account_no = NEW.to_account_no;
  
  IF NEW.to_account_no <> NEW.from_account_no THEN
    UPDATE Account
    SET amount = CASE
                  WHEN amount - NEW.amount >= 0 THEN amount - NEW.amount
                  ELSE amount
                END
    WHERE account_no = NEW.from_account_no;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `username` varchar(50) NOT NULL,
  `password` varchar(200) NOT NULL,
  `salt` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('boo','39af12d45a3fe026b2f958087cabf20373373fc382d590537c6879179e7c23c7','AAsxzhnSjkKevArGQBARVeVvk','2021-07-17 01:02:43'),('mamad','1b185d16143316fc6ce578c88b7f816d80f738a57cd1b5de3e5df1356d315c2e','nwYPvaXPbOJCWbXRcrOxJfkyd','2021-07-17 00:55:24'),('maryam','01d5255ef3699effbb1c8bab55e630f18536c9a31d5e0b29294b8e612769ed60','IRuaJsJoDurZAOHzgonFxqJdG','2021-07-17 00:54:57');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER auto_insert_ban_user
AFTER INSERT
ON User
FOR EACH ROW
  INSERT INTO Ban_Users ( username, ban_times, started_at, finished_at )
    VALUES(NEW.username, 0, NULL, NULL) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Withdraw_Request_Log`
--

DROP TABLE IF EXISTS `Withdraw_Request_Log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Withdraw_Request_Log` (
  `deposit_log_ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `account_no` int(20) DEFAULT NULL,
  `amount` decimal(11,4) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `port` varchar(20) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL CHECK (`status` in ('1','0')),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`deposit_log_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Withdraw_Request_Log`
--

LOCK TABLES `Withdraw_Request_Log` WRITE;
/*!40000 ALTER TABLE `Withdraw_Request_Log` DISABLE KEYS */;
/*!40000 ALTER TABLE `Withdraw_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-17  1:07:38
