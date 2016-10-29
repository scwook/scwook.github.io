-- MySQL dump 10.13  Distrib 5.5.49, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: olog
-- ------------------------------------------------------
-- Server version 5.5.49-0+deb7u1

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
-- Current Database: `olog`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `olog` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `olog`;

--
-- Table structure for table `attributes`
--

DROP TABLE IF EXISTS `attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `property_id` int(11) unsigned NOT NULL,
  `name` varchar(200) NOT NULL,
  `state` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`id`),
  KEY `attributes_property_id_fk` (`property_id`),
  CONSTRAINT `attributes_property_id_fk` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attributes`
--

LOCK TABLES `attributes` WRITE;
/*!40000 ALTER TABLE `attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entries`
--
This is a schema of MySQL for 


DROP TABLE IF EXISTS `entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entries` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entries`
--

LOCK TABLES `entries` WRITE;
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logbooks`
--

DROP TABLE IF EXISTS `logbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logbooks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `is_tag` int(1) unsigned NOT NULL DEFAULT '0',
  `owner` varchar(45) DEFAULT NULL,
  `state` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logbooks`
--

LOCK TABLES `logbooks` WRITE;
/*!40000 ALTER TABLE `logbooks` DISABLE KEYS */;
INSERT INTO `logbooks` VALUES (1,'Operations',0,NULL,'Active'),(2,'Electronics Maintenance',0,NULL,'Active'),(3,'Mechanical Technicians',0,NULL,'Active'),(4,'LOTO',0,NULL,'Active'),(5,'Inverpower Power Supplies',1,NULL,'Active'),(6,'RF Area',1,NULL,'Active'),(7,'Kicker',1,NULL,'Active'),(8,'Bumps',1,NULL,'Active'),(9,'Septums',1,NULL,'Active'),(10,'Large Power Supplies',1,NULL,'Active'),(11,'Timing Systems',1,NULL,'Active');
/*!40000 ALTER TABLE `logbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `modified` datetime NOT NULL,
  `source` varchar(80) NOT NULL DEFAULT '',
  `owner` varchar(32) NOT NULL,
  `description` mediumtext NOT NULL,
  `md5entry` varchar(32) NOT NULL DEFAULT '',
  `state` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  `level` enum('Info','Problem','Request','Suggestion','Urgent') NOT NULL DEFAULT 'Info',
  `entry_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `entry_id_fk` (`entry_id`),
  CONSTRAINT `entry_id_fk` FOREIGN KEY (`entry_id`) REFERENCES `entries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_attributes`
--

DROP TABLE IF EXISTS `logs_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs_attributes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `log_id` int(11) unsigned NOT NULL,
  `attribute_id` int(11) unsigned NOT NULL,
  `value` varchar(200) NOT NULL,
  `grouping_num` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `logs_attributes_attribute_id_fk` (`attribute_id`),
  KEY `logs_attributes_log_id_fk` (`log_id`),
  CONSTRAINT `logs_attributes_attribute_id_fk` FOREIGN KEY (`attribute_id`) REFERENCES `attributes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `logs_attributes_log_id_fk` FOREIGN KEY (`log_id`) REFERENCES `logs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_attributes`
--

LOCK TABLES `logs_attributes` WRITE;
/*!40000 ALTER TABLE `logs_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs_logbooks`
--

DROP TABLE IF EXISTS `logs_logbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs_logbooks` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `log_id` int(11) unsigned NOT NULL,
  `logbook_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `log_id_fk` (`log_id`),
  KEY `logbook_id_fk` (`logbook_id`) USING BTREE,
  CONSTRAINT `log_id_fk` FOREIGN KEY (`log_id`) REFERENCES `logs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `logbook_id_fk` FOREIGN KEY (`logbook_id`) REFERENCES `logbooks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs_logbooks`
--

LOCK TABLES `logs_logbooks` WRITE;
/*!40000 ALTER TABLE `logs_logbooks` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs_logbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `properties`
--

DROP TABLE IF EXISTS `properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `properties` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `state` enum('Active','Inactive') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `properties`
--

LOCK TABLES `properties` WRITE;
/*!40000 ALTER TABLE `properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_version`
--

DROP TABLE IF EXISTS `schema_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_version` (
  `version_rank` int(11) NOT NULL,
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`version`),
  KEY `schema_version_vr_idx` (`version_rank`),
  KEY `schema_version_ir_idx` (`installed_rank`),
  KEY `schema_version_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_version`
--

LOCK TABLES `schema_version` WRITE;
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;
INSERT INTO `schema_version` VALUES (1,1,'1.00','Base version','INIT','Base version',NULL,'root','2016-05-13 05:23:05',0,1),(2,2,'2.00','ALTER logbooks status to state','SQL','V2.00__ALTER_logbooks_status_to_state.sql',-1775352058,'root','2016-05-13 05:23:05',15,1),(3,3,'2.01','ALTER logs status to state','SQL','V2.01__ALTER_logs_status_to_state.sql',104011789,'root','2016-05-13 05:23:05',11,1),(4,4,'2.02','ALTER properties status to state','SQL','V2.02__ALTER_properties_status_to_state.sql',-680189563,'root','2016-05-13 05:23:05',19,1),(5,5,'2.03','ALTER attributes status to state','SQL','V2.03__ALTER_attributes_status_to_state.sql',-207252449,'root','2016-05-13 05:23:05',12,1),(6,6,'2.04','ALTER logs logbooks drop columns','SQL','V2.04__ALTER_logs_logbooks_drop_columns.sql',-2067581210,'root','2016-05-13 05:23:05',5,1),(7,7,'2.05','CREATE entries','SQL','V2.05__CREATE_entries.sql',-16098960,'root','2016-05-13 05:23:05',3,1),(8,8,'2.06','ALTER logs md5recent','SQL','V2.06__ALTER_logs_md5recent.sql',-1367573323,'root','2016-05-13 05:23:05',4,1),(9,9,'2.07','DROP statuses','SQL','V2.07__DROP_statuses.sql',-1470090610,'root','2016-05-13 05:23:05',2,1),(10,10,'2.08','ALTER logs level to ENUM','SQL','V2.08__ALTER_logs_level_to_ENUM.sql',-308002669,'root','2016-05-13 05:23:05',11,1),(11,11,'2.09','DROP levels','SQL','V2.09__DROP_levels.sql',-352522219,'root','2016-05-13 05:23:05',2,1),(12,12,'2.10','ALTER logs','SQL','V2.10__ALTER_logs.sql',-16433912,'root','2016-05-13 05:23:05',14,1),(13,13,'2.11','ALTER fix all fkeys','SQL','V2.11__ALTER_fix_all_fkeys.sql',-340063373,'root','2016-05-13 05:23:05',51,1);
/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subscriptions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) unsigned NOT NULL,
  `email` varchar(250) NOT NULL DEFAULT '',
  `webhook` varchar(250) DEFAULT NULL,
  `level_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subscriptions_tag_id_fk` (`tag_id`),
  CONSTRAINT `subscriptions_tag_id_fk` FOREIGN KEY (`tag_id`) REFERENCES `logbooks` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-05-16  9:36:30
