-- MySQL dump 10.13  Distrib 5.7.37, for Linux (x86_64)
--
-- Host: localhost    Database: eventbot
-- ------------------------------------------------------
-- Server version	5.7.37-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `entries`
--

DROP TABLE IF EXISTS `entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(250) NOT NULL,
  `us_number` varchar(250) DEFAULT NULL,
  `them_number` varchar(250) DEFAULT NULL,
  `user` varchar(250) DEFAULT NULL,
  `orig_url` varchar(2000) NOT NULL,
  `filename` varchar(1500) NOT NULL,
  `time_captured` varchar(500) DEFAULT NULL,
  `status` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entries`
--

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
INSERT INTO `entries` VALUES (1,'text','+17028422772','+13032644789',NULL,'https://edition.cnn.com/','vqqru4062663423.png',NULL,'PROCESSED'),(2,'text','+17028422772','+13032644789',NULL,'https://archive.org/','nyhlg4074286464.png',NULL,'PROCESSED'),(3,'web',NULL,NULL,'nano','https://news.google.com/topstories?hl=en-US&gl=US&ceid=US:en','mbhcl5503548252.png',NULL,'PROCESSED'),(4,'web',NULL,NULL,'nano','https://www.cnn.com/','eziuf1550378892.png',NULL,'PROCESSED'),(5,'web',NULL,NULL,'nano','https://archive.org/','fdiuv763150291.png',NULL,'PROCESSED'),(6,'text','+17028422772','+13032644789',NULL,'https://edition.cnn.com/','swtgu7677924224.png',NULL,'PROCESSED'),(7,'web',NULL,NULL,'nano','https://www.google.com/','xagzj6088269869.png',NULL,'PROCESSED'),(8,'text','+17028422772','+13032644789',NULL,'https://edition.cnn.com/','hbhbr506814176.png',NULL,'PROCESSED'),(9,'text','+17028422772','+13032644789',NULL,'https://edition.cnn.com/','gwsuc8358050313.png',NULL,'PROCESSED'),(10,'text','+17028422772','+13032644789',NULL,'https://edition.cnn.com/','vzcko7927169494.png','16:55:41 Mar 4, 2022','PROCESSED'),(11,'web',NULL,NULL,'nano','https://edition.cnn.com/','swljs644379388.png','16:56:39 Mar 4, 2022','PROCESSED'),(12,'text','+17028422772','+13032644789',NULL,'https://archive.org/','nkwms808787110.png','16:58:54 Mar 4, 2022','PROCESSED'),(13,'web',NULL,NULL,'nano','https://news.google.com/topstories?hl=en-US&gl=US&ceid=US:en','ydrsu4481961244.png','17:03:30 Mar 4, 2022','PROCESSED'),(14,'web',NULL,NULL,'nano','https://archive.org/','flgve5028215937.png','17:04:14 Mar 4, 2022','PROCESSED'),(15,'text','+17028422772','+13032644789',NULL,'https://edition.cnn.com/','htyep8500503660.png','17:04:03 Mar 4, 2022','PROCESSED'),(16,'web',NULL,NULL,'nano','https://www.youtube.com/','twaxn7236857292.png','17:03:49 Mar 4, 2022','PROCESSED'),(17,'text','+17028422772','+13032644789',NULL,'https://mobile.twitter.com/','rutud896633265.png','19:00:50 Mar 4, 2022','PROCESSED'),(18,'web',NULL,NULL,'nano','https://lawrence.paperhouse.cc/','meeqp2888982266.png','20:11:15 Mar 4, 2022','PROCESSED'),(19,'web',NULL,NULL,'lawrence','https://www.cnn.com/2022/03/04/tech/russia-blocks-facebook/index.html','clhdq3874543548.png','03:26:39 Mar 5, 2022','PROCESSED'),(20,'web',NULL,NULL,'lawrence','https://www.cnn.com/','pppof6555779049.png','03:28:48 Mar 5, 2022','PROCESSED'),(21,'web',NULL,NULL,'lawrence','http://en.kalitribune.com/the-invisible-empire-introduction-to-alexander-dugins-foundations-of-geopolitics-pt-1/','byhxe5315219076.png','17:02:32 Mar 5, 2022','PROCESSED'),(22,'web',NULL,NULL,'lawrence','https://www.foxnews.com/','hwduz4717603782.png','19:53:43 Mar 5, 2022','PROCESSED'),(23,'web',NULL,NULL,'nano','https://www.cnn.com','oosib1881754583.png','20:36:02 Mar 5, 2022','PROCESSED'),(24,'web',NULL,NULL,'nano','https://archive.org/','aqzbq1179126943.png','20:38:55 Mar 5, 2022','PROCESSED'),(25,'web',NULL,NULL,'nano','https://edition.cnn.com/','vqpap7251667796.png','20:45:39 Mar 5, 2022','PROCESSED'),(26,'web',NULL,NULL,'nano','https://archive.org/','tpyil8249557052.png','20:46:57 Mar 5, 2022','PROCESSED'),(27,'web',NULL,NULL,'nano','https://cnn.com/','dlicg3933740632.png','20:51:49 Mar 5, 2022','PROCESSED'),(28,'web',NULL,NULL,'nano','https://www.cnn.com','vvjaj1584282387.png','23:00:51 Mar 5, 2022','PROCESSED'),(29,'web',NULL,NULL,'nano','https://www.medicalnewstoday.com/','dtjfd8804773309.png','23:02:32 Mar 5, 2022','PROCESSED'),(30,'web',NULL,NULL,'nano','https://www.medicalnewstoday.com/','cjucm8428282714.png','23:06:22 Mar 5, 2022','PROCESSED'),(31,'web',NULL,NULL,'nano','https://themississippilink.com/category/top-stories/?gclid=CjwKCAiAsYyRBhACEiwAkJFKovtiAZTs1WSpGigvsYPgUWqA8ZeQWd1h6armGkQQ2EkHPq5Ruyk9URoCoXkQAvD_BwE','lfuvs9383737188.png','23:06:33 Mar 5, 2022','PROCESSED'),(32,'web',NULL,NULL,'nano','https://edition.cnn.com/2020/01/10/australia/australia-fires-climate-protest-morrison-intl-hnk/index.html','swebm1995878042.png','23:10:49 Mar 5, 2022','PROCESSED'),(33,'web',NULL,NULL,'nano','https://edition.cnn.com/2020/01/10/australia/australia-fires-climate-protest-morrison-intl-hnk/index.html','pvmqk9532895931.png','04:39:04 Mar 6, 2022','PROCESSED'),(34,'web',NULL,NULL,'2020api','https://nypost.com/2022/03/04/latest-russia-ukraine-news-live-updates-of-the-war/','ucgel4640560874.png','04:40:03 Mar 6, 2022','PROCESSED'),(35,'web',NULL,NULL,'2020api','https://www.wcvb.com/article/procession-for-trooper-tamar-bucci-stoneham-march-5-2022','qitas1908985933.png','04:44:12 Mar 6, 2022','PROCESSED'),(36,'web',NULL,NULL,'2020api','https://www.theepochtimes.com/','flsph5958137319.png','04:47:32 Mar 6, 2022','PROCESSED'),(37,'web',NULL,NULL,'2020api','https://www.theepochtimes.com/visa-mastercard-abruptly-suspend-all-operations-in-russia_4319335.html','sngad7719082045.png','05:06:23 Mar 6, 2022','PROCESSED'),(38,'web',NULL,NULL,'2020api','https://www.theverge.com/2022/3/5/22963433/visa-mastercard-suspend-services-russia-ukraine','ncpxi1907562565.png','05:24:25 Mar 6, 2022','PROCESSED'),(39,'api',NULL,NULL,'nano','https://archive.org/','rmgqq9458214169.png','14:16:02 Mar 6, 2022','PROCESSED');
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `numbers`
--

DROP TABLE IF EXISTS `numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `numbers` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `number` varchar(255) NOT NULL,
  `number_sid` varchar(255) NOT NULL,
  `account_sid` varchar(255) NOT NULL,
  `auth_token` varchar(255) NOT NULL,
  `country` varchar(6) NOT NULL,
  `country_code` varchar(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `numbers`
--

LOCK TABLES `numbers` WRITE;
/*!40000 ALTER TABLE `numbers` DISABLE KEYS */;
INSERT INTO `numbers` VALUES (1,'+17192159888','PN51e7948f70d63f189556c30a0248b06d','AC2c73f55c634b0a2cb8ac46f89ae5c648','d8dd7984d03526161f80c6583bd80fd7','US','+1'),(2,'+17028422772','PNf5c8c78d35ef8e03b25ff4bb01a66e08','ACda021f5f91421483f8ad333ceedd38bb','be2c0ffdc00d48605d79bac222d62b8e','US','+1');
/*!40000 ALTER TABLE `numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spreadsheets`
--

DROP TABLE IF EXISTS `spreadsheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spreadsheets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(250) NOT NULL,
  `url` varchar(2000) NOT NULL,
  `last_edited_row` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spreadsheets`
--

LOCK TABLES `spreadsheets` WRITE;
/*!40000 ALTER TABLE `spreadsheets` DISABLE KEYS */;
INSERT INTO `spreadsheets` VALUES (1,'main_log','https://docs.google.com/spreadsheets/d/1gSyECzO5QNPkwFYFUbRJkhj6WdfyF3x_SABpisXr7t0/edit','97,98');
/*!40000 ALTER TABLE `spreadsheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tokens` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(250) DEFAULT NULL,
  `user` varchar(250) NOT NULL,
  `token` varchar(1500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokens`
--

LOCK TABLES `tokens` WRITE;
/*!40000 ALTER TABLE `tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(6) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(255) NOT NULL,
  `pass` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'nano','da8838a2c4bf7e76a12b6566636a2b29'),(3,'lawrence','ac1c8d64fd23ae5a7eac5b7f7ffee1fa'),(4,'2020api','f4c68158a6867b42f0debff4e02f6cc5');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-03-06 14:18:44
