-- MariaDB dump 10.19  Distrib 10.5.11-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: fakebankingsystem
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
-- Table structure for table `Ban_Users`
--

DROP TABLE IF EXISTS `Ban_Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ban_Users` (
  `username` varchar(50) NOT NULL,
  `ban_times` int(11) NOT NULL DEFAULT 0,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ban_Users`
--

LOCK TABLES `Ban_Users` WRITE;
/*!40000 ALTER TABLE `Ban_Users` DISABLE KEYS */;
/*!40000 ALTER TABLE `Ban_Users` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Login_Request_Log`
--

LOCK TABLES `Login_Request_Log` WRITE;
/*!40000 ALTER TABLE `Login_Request_Log` DISABLE KEYS */;
/*!40000 ALTER TABLE `Login_Request_Log` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Signup_Request_Log`
--

LOCK TABLES `Signup_Request_Log` WRITE;
/*!40000 ALTER TABLE `Signup_Request_Log` DISABLE KEYS */;
/*!40000 ALTER TABLE `Signup_Request_Log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-07-17 14:04:24
