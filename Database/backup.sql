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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Accept_Request_Log`
--

LOCK TABLES `Accept_Request_Log` WRITE;
/*!40000 ALTER TABLE `Accept_Request_Log` DISABLE KEYS */;
INSERT INTO `Accept_Request_Log` VALUES (1,'reza','maryam','4','3','192.168.43.82','48658','1','2021-07-18 10:08:55');
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
) ENGINE=InnoDB AUTO_INCREMENT=1000000002 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account`
--

LOCK TABLES `Account` WRITE;
/*!40000 ALTER TABLE `Account` DISABLE KEYS */;
INSERT INTO `Account` VALUES (1000000000,'maryam','Short-term saving account',1000000.0000,'1','1','2021-07-18 10:05:21','2021-07-18 10:24:22'),(1000000001,'reza','Short-term saving account',900000.0000,'1','1','2021-07-18 10:07:32','2021-07-18 10:10:58');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Account_User`
--

LOCK TABLES `Account_User` WRITE;
/*!40000 ALTER TABLE `Account_User` DISABLE KEYS */;
INSERT INTO `Account_User` VALUES (1,'maryam',1000000001,'4','3','2021-07-18 10:08:55');
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
INSERT INTO `Ban_Users` VALUES ('maryam',2,'2021-07-17 13:55:39','2021-07-17 13:56:09'),('reza',0,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Deposit_Request_Log`
--

LOCK TABLES `Deposit_Request_Log` WRITE;
/*!40000 ALTER TABLE `Deposit_Request_Log` DISABLE KEYS */;
INSERT INTO `Deposit_Request_Log` VALUES (1,'reza',1000000000,1000000001,100000.0000,'192.168.43.82','48666','0','2021-07-18 10:10:41'),(2,'reza',1000000001,1000000000,100000.0000,'192.168.43.82','48666','1','2021-07-18 10:10:58');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Join_Request`
--

LOCK TABLES `Join_Request` WRITE;
/*!40000 ALTER TABLE `Join_Request` DISABLE KEYS */;
INSERT INTO `Join_Request` VALUES (1,'maryam',1000000001,'1','2021-07-18 10:07:52','2021-07-18 10:08:55');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Join_Request_Log`
--

LOCK TABLES `Join_Request_Log` WRITE;
/*!40000 ALTER TABLE `Join_Request_Log` DISABLE KEYS */;
INSERT INTO `Join_Request_Log` VALUES (1,'maryam',1000000001,'192.168.43.82','48600','1','2021-07-18 10:07:52');
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Login_Request_Log`
--

LOCK TABLES `Login_Request_Log` WRITE;
/*!40000 ALTER TABLE `Login_Request_Log` DISABLE KEYS */;
INSERT INTO `Login_Request_Log` VALUES (1,'maryam','09b0835cf0f24ebb6d1fb8f22ebd0bec678fd64433849e73c77f45237e129008','hmALKZvBqaLeQkFCvElOpiRHW','192.168.43.82','60864','1','2021-07-17 13:44:35'),(2,'maryam','0125923078f280e8dfac997a555277ffcf6baadd00d0a087ef7eeb1cce3a9b02','kpkhLQiQGbtpUVoJzPwcgSStb','192.168.43.82','32902','1','2021-07-17 13:52:43'),(3,'a','fd1444dadb31fa5c788d3ff860c967d44a258ad5bf7066b6322fa2dbdd22d37b','zCPeBPzthcQTljQKpPCeZQcEv','192.168.43.82','32904','0','2021-07-17 13:53:26'),(4,'a','b9ebb1214085bf688dd14857111635f523bce9d09f2cc47d909166a9130c4512','VzprvUuzZcPGmcnAfFBuSClaf','192.168.43.82','32904','0','2021-07-17 13:53:48'),(5,'a','21aa0be82dfc0ccccb21c8eecbd06729d1caec53f86701705386332c05157333','JoMNHMTNwqBLeDAKEZOlJsdNn','192.168.43.82','32904','0','2021-07-17 13:53:53'),(6,'a','149d0be33f098bb90fb1b311da37f04c4d15e083cea717b674a2eccf6f07aa6d','oGOjlbulvUdduUZpnDAubOgyE','192.168.43.82','32904','0','2021-07-17 13:54:00'),(7,'a','19df4958d0d3105abc83785df99ca24a147fa9d0d9e82301c2adde061d8ef1f3','IYqfTIZpCpIIubMAGRMbWucfX','192.168.43.82','32904','0','2021-07-17 13:54:09'),(8,'a','7446576e4353f95226b56fa1dbaf4fc0925367838aa67fa9fec29fbe355fffe5','sIcPeaSHeVChmcTUMDSlisrVm','192.168.43.82','32904','0','2021-07-17 13:54:12'),(9,'a','0a8794b86924b5dcf316516fa549ed110d3582a625e057188bd66ddcd31c937a','wbMQHiOpXOmfOiyVVpyJkRBeh','192.168.43.82','32904','0','2021-07-17 13:54:15'),(10,'maryam','139b8572f35b16aee670cf17a16bba3e1366a3a1b370d54be1ced77ba91eb474','sSjhBEwzdeBMediRjOcgxSdJD','192.168.43.82','32904','0','2021-07-17 13:54:36'),(11,'maryam','0b0b82a07ddef19cc6369d6309ad727186a938c3a687e3dbe5ba95ba7ad8fbee','JNyVtQltmIhwubkKQdIzoHblw','192.168.43.82','32904','0','2021-07-17 13:54:42'),(12,'maryam','a488f0f61c805ee4e527d26193220f9bbc331ee31e8851f65abf4bfcb6682c5d','pBQPXptBYiSpFXbaqhbLLYwNJ','192.168.43.82','32904','0','2021-07-17 13:54:45'),(13,'maryam','4580804f074ffb398e847f2128b296ebc5a23cc088073ccb85368c06fd3756ac','CXDONKwGqiWlbzqfNTmPzACgh','192.168.43.82','32904','0','2021-07-17 13:54:48'),(14,'maryam','f01246f8e02ee294ee10c98beaf1561a32f4bbff8de3304bf0f9590514c75e4c','achmLocmQFOYNgaSZSXocyoVF','192.168.43.82','32904','0','2021-07-17 13:54:53'),(15,'maryam','2a91f662144ca639614ac2f856f015a9cbfbe3dadd40704b469e585214e0f54b','LPNbazpmkWDZvuymeLdRFrCHo','192.168.43.82','32904','0','2021-07-17 13:54:56'),(16,'maryam','3d22d0100ba2a103e1d670509742dcbebbed10dc433083f426415003c3f648c7','WTyEuZMrsKmdOPBbwGTIDaRIn','192.168.43.82','32904','0','2021-07-17 13:55:02'),(17,'maryam','632b23cdd53d355484423e5b90f441ccea24c8fb43ec0651149c3c5703d4796f','ztXoHLTHYuFoqwSJHmtZHbYLX','192.168.43.82','32904','0','2021-07-17 13:55:07'),(18,'maryam','879223305f040eda1c5d63b8ca145354adae5ec1983166d6c207792618285ad5','luLVmJReEGiNhigHHQQfBspvj','192.168.43.82','32904','0','2021-07-17 13:55:12'),(19,'maryam','c59e22c53f380a5eb2e934ebfca9f6c6d90ba169dac62420337c553f01d806c8','KTUsSBqjylYeBnEbGGMACFLom','192.168.43.82','32904','0','2021-07-17 13:55:16'),(20,'maryam','8ba1502d49457d6a47ecc31878d7c9b403b52c8f945f9794f327efca1d30e6a1','hucXBBrponobUszjeHhNlOkVA','192.168.43.82','32904','0','2021-07-17 13:55:19'),(21,'maryam','78d7bafd5ed0e7ec555fefb0dac63d733bd470ea5dc6613a7c3772c3ac367842','iXOqmPRrWyJdOyQgKLvaGvvdf','192.168.43.82','32904','0','2021-07-17 13:55:22'),(22,'maryam','9c1b4ed1a03a43ea68259759356ab283389033ce569434cd27effcde7f64abbb','GjaeWnftiwJGPjunggNLjhuHy','192.168.43.82','32904','0','2021-07-17 13:55:25'),(23,'maryam','3eaa521da1643442310ceb2bcee9aace23a4b4cf259406ea08fbabc8a5bb0cc0','TKFuvtokapyLQhDgLOvSxjKDN','192.168.43.82','32904','0','2021-07-17 13:55:29'),(24,'maryam','4443d96b60502a304a557abd3e4daf0a823f58216c57407fc2ff4283b80c26da','nRvcSiwLfVzEJcJmgwVzlHSBL','192.168.43.82','32904','0','2021-07-17 13:55:32'),(25,'maryam','11f4b510ad9923adb9006273a2e5435021665e31654b9ad45e89ce5adcd3a287','HidLrofIkzQcFuClvSoXemQvC','192.168.43.82','32904','0','2021-07-17 13:55:37'),(26,'maryam','e012761bfb3889024b1ecf16fb9c2412ae47cea90b6bad0d19f00c5083c7dda0','zcVPtvVnlFRneLwZNbNPZVOhF','192.168.43.82','32904','0','2021-07-17 13:55:40'),(27,'maryam','001fd0bba54cfacc93f212eaee3214b859ab4990dde23cfb81473a66bd2193f1','VMrDGEBalTrYwSjIdVtPIAKbt','192.168.43.82','32904','0','2021-07-17 13:55:41'),(28,'maryam','a9f13fb00c6294e9a48f35c50988a1e30224f84d85471ead3a3b6603d43e5f6c','gKgeEnkiReMgNmPIESAurDwYv','192.168.43.82','32904','0','2021-07-17 13:55:44'),(29,'maryam','6c12d625979e23e95a130dca977278f4d22bedeb7bc1ec5996378d7a4a156e71','NaeuLBAmWoPVCAZFBAkcvUJBG','192.168.43.82','32904','0','2021-07-17 13:55:46'),(30,'maryam','db2d256a10b32d18a3d3ea92356d1e0541b05bd0d4ef67f7bc5c206b1af4611f','vYWWaqnYUUUtXlNfaxOzhJnUJ','192.168.43.82','32904','0','2021-07-17 13:55:56'),(31,'maryam','f7fd7f5a5f3ecd601051c327f723caf86022db87b208bc2964438c215776778c','YZhHZvNwZnokCYiyUdkAOjDgx','192.168.43.82','32904','0','2021-07-17 13:56:38'),(32,'maryam','938459f35c3104d697106cc29758cf2f464c652928fa4094455c865b5d738f3e','VIjdBhvjndESkhHDpUrTHLGMq','192.168.43.82','32904','0','2021-07-17 13:56:41'),(33,'maryam','aa28f1ab313b54c7d2a729265e76e31f72a2f5e8fbd9aaa47d4c8791ae173072','McQfQwKOOFFsLRRJxzvdoaQGO','192.168.43.82','48600','1','2021-07-18 10:02:48'),(34,'reza','e03209ff33d8390bd9d4a3adf446e0fe4f7e1af7e6c09f17d6822d8f071a9419','LiOwnuUbkzSjEDRBJDmTLJURo','192.168.43.82','48658','1','2021-07-18 10:07:20'),(35,'reza','7de0bbb10113c86d1e624caad4234349d15ef2846f3b6266021922fcc0e31f9c','hwuZZXLMblpyAqipESORQiOCU','192.168.43.82','48666','1','2021-07-18 10:10:22'),(36,'maryam','c6f267397bfb794eb620c0e0da404a2b271fc3efe68310dcd5641c3682aab0a1','dlrpHATYqvVwSuStCLtjUsOIQ','192.168.43.82','48794','1','2021-07-18 10:22:39'),(37,'reza','55e867bfcd2facc699b83e867a4570c2b949871ccc13a795e8fc5de9961aeac2','XfDDkxkmrYErHkuQZIDPeODme','192.168.43.82','48800','1','2021-07-18 10:23:02'),(38,'maryam','d06fc624566d32e58c0164c10cd4db66959a07f364b6c81dfe28877dab79a870','mgoBKkpGCFUSTGhbSwQiFOTOT','192.168.43.82','49190','1','2021-07-18 10:36:10'),(39,'reza','f09ea7dbe32a207c3464d36e4793ce4af2dfbb1ca422a47b0149d857f9904cc3','bwpXifInMJmUSwsYYYhYgnCzb','192.168.43.82','49192','1','2021-07-18 10:36:39');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowAccount_Request_Log`
--

LOCK TABLES `ShowAccount_Request_Log` WRITE;
/*!40000 ALTER TABLE `ShowAccount_Request_Log` DISABLE KEYS */;
INSERT INTO `ShowAccount_Request_Log` VALUES (1,'maryam',1000000000,'192.168.43.82','48600','1','2021-07-18 10:08:16'),(2,'maryam',1000000001,'192.168.43.82','48600','0','2021-07-18 10:08:33'),(3,'maryam',1000000001,'192.168.43.82','48600','0','2021-07-18 10:09:03'),(4,'reza',1000000001,'192.168.43.82','48666','1','2021-07-18 10:11:17'),(5,'maryam',1000000000,'192.168.43.82','48600','1','2021-07-18 10:12:45'),(6,'reza',1000000001,'192.168.43.82','48800','1','2021-07-18 10:23:16'),(7,'maryam',1000000000,'192.168.43.82','48794','1','2021-07-18 10:23:35'),(8,'maryam',1000000000,'192.168.43.82','48794','1','2021-07-18 10:24:32'),(9,'reza',1000000000,'192.168.43.82','49192','0','2021-07-18 10:36:54'),(10,'reza',1000000001,'192.168.43.82','49192','1','2021-07-18 10:37:03'),(11,'maryam',1000000001,'192.168.43.82','49190','0','2021-07-18 10:37:11'),(12,'maryam',1000000000,'192.168.43.82','49190','1','2021-07-18 10:37:17');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowMyAccount_Request_Log`
--

LOCK TABLES `ShowMyAccount_Request_Log` WRITE;
/*!40000 ALTER TABLE `ShowMyAccount_Request_Log` DISABLE KEYS */;
INSERT INTO `ShowMyAccount_Request_Log` VALUES (1,'maryam','192.168.43.82','32902','0','2021-07-17 13:52:50'),(2,'maryam','192.168.43.82','48600','0','2021-07-18 10:03:24'),(3,'maryam','192.168.43.82','48600','1','2021-07-18 10:05:29'),(4,'maryam','192.168.43.82','48600','1','2021-07-18 10:09:14'),(5,'reza','192.168.43.82','48800','1','2021-07-18 10:23:09'),(6,'maryam','192.168.43.82','48794','1','2021-07-18 10:23:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ShowMyJoinRequests_Log`
--

LOCK TABLES `ShowMyJoinRequests_Log` WRITE;
/*!40000 ALTER TABLE `ShowMyJoinRequests_Log` DISABLE KEYS */;
INSERT INTO `ShowMyJoinRequests_Log` VALUES (1,'reza','192.168.43.82','48658','1','2021-07-18 10:07:56');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Signup_Request_Log`
--

LOCK TABLES `Signup_Request_Log` WRITE;
/*!40000 ALTER TABLE `Signup_Request_Log` DISABLE KEYS */;
INSERT INTO `Signup_Request_Log` VALUES (1,'maryam','1645d9d0852d3605de7180abbfb5053913045852f1fa9ceaeac59c0d4055f8e2','QpujiiFPIJfEjzvgJcxjlmsym','1','2021-07-17 13:44:25'),(2,'reza','f76c7a92d5a3673e0c90242962dc82f4b78b00a2776497d8711e9dce9dabcf15','iVRSrXsTuuUWtmMThyCmZBfwW','1','2021-07-18 10:07:02');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Transaction`
--

LOCK TABLES `Transaction` WRITE;
/*!40000 ALTER TABLE `Transaction` DISABLE KEYS */;
INSERT INTO `Transaction` VALUES (1,'reza',1000000001,1000000000,100000.0000,'2021-07-18 10:10:58'),(2,'maryam',1000000000,1000000000,-100000.0000,'2021-07-18 10:24:22');
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
INSERT INTO `User` VALUES ('maryam','a1bc5dcacc2715015a1471aeed9617c638679cd3f25b81d29d5707dc0814f13f','tCGFPoXNkatrRDsNNoqAEXqmX','2021-07-17 13:44:24'),('reza','3ffcf222cdb922eb0c212de4ce7ae0461ccf0b30e203253c9f3daf56e9afb57a','ajFTZoXVYhCuGdGGSasdYMzXG','2021-07-18 10:07:02');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Withdraw_Request_Log`
--

LOCK TABLES `Withdraw_Request_Log` WRITE;
/*!40000 ALTER TABLE `Withdraw_Request_Log` DISABLE KEYS */;
INSERT INTO `Withdraw_Request_Log` VALUES (1,'maryam',1000000001,1000.0000,'192.168.43.82','48794','0','2021-07-18 10:24:08'),(2,'maryam',1000000000,100000.0000,'192.168.43.82','48794','1','2021-07-18 10:24:23');
/*!40000 ALTER TABLE `Withdraw_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `fail_login_count`
--

DROP TABLE IF EXISTS `fail_login_count`;
/*!50001 DROP VIEW IF EXISTS `fail_login_count`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `fail_login_count` (
  `username` tinyint NOT NULL,
  `login_counts` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `login_audit`
--

DROP TABLE IF EXISTS `login_audit`;
/*!50001 DROP VIEW IF EXISTS `login_audit`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `login_audit` (
  `username` tinyint NOT NULL,
  `ip` tinyint NOT NULL,
  `port` tinyint NOT NULL,
  `num_of_tries` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `fail_login_count`
--

/*!50001 DROP TABLE IF EXISTS `fail_login_count`*/;
/*!50001 DROP VIEW IF EXISTS `fail_login_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `fail_login_count` AS select `Login_Request_Log`.`username` AS `username`,count(0) AS `login_counts` from `Login_Request_Log` where timestampdiff(HOUR,`Login_Request_Log`.`created_at`,current_timestamp()) <= 24 and `Login_Request_Log`.`status` = '0' and `Login_Request_Log`.`username` in (select `User`.`username` from `User`) group by `Login_Request_Log`.`username` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `login_audit`
--

/*!50001 DROP TABLE IF EXISTS `login_audit`*/;
/*!50001 DROP VIEW IF EXISTS `login_audit`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `login_audit` AS select distinct `Login_Request_Log`.`username` AS `username`,`Login_Request_Log`.`ip` AS `ip`,`Login_Request_Log`.`port` AS `port`,count(0) AS `num_of_tries` from (`Login_Request_Log` join `fail_login_count` on(`Login_Request_Log`.`username` = `fail_login_count`.`username`)) where timestampdiff(HOUR,`Login_Request_Log`.`created_at`,current_timestamp()) <= 24 and `Login_Request_Log`.`status` = '0' and `fail_login_count`.`login_counts` > 1 group by `Login_Request_Log`.`username`,`Login_Request_Log`.`ip`,`Login_Request_Log`.`port` order by `Login_Request_Log`.`username` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-18 10:41:16
