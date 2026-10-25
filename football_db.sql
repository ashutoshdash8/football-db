-- MySQL dump 10.13  Distrib 9.6.0, for Win64 (x86_64)
--
-- Host: localhost    Database: football_db
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '66bf1a5b-bcf5-11f1-8c63-b491b9ec747d:1-183';

--
-- Current Database: `football_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `football_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `football_db`;

--
-- Table structure for table `coach`
--

DROP TABLE IF EXISTS `coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach` (
  `coach_id` int NOT NULL AUTO_INCREMENT,
  `coach_name` varchar(80) NOT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `experience_years` int DEFAULT '0',
  `team_id` int NOT NULL,
  PRIMARY KEY (`coach_id`),
  UNIQUE KEY `team_id` (`team_id`),
  CONSTRAINT `coach_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
INSERT INTO `coach` VALUES (1,'Rahul Verma','India',12,1),(2,'Carlos Mendes','Portugal',18,2),(3,'Arjun Sen','India',10,3),(4,'Marco Ricci','Italy',15,4);
/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goals`
--

DROP TABLE IF EXISTS `goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goals` (
  `goal_id` int NOT NULL AUTO_INCREMENT,
  `match_id` int NOT NULL,
  `player_id` int NOT NULL,
  `goal_minute` int NOT NULL,
  PRIMARY KEY (`goal_id`),
  KEY `match_id` (`match_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `goals_ibfk_1` FOREIGN KEY (`match_id`) REFERENCES `matches` (`match_id`) ON DELETE CASCADE,
  CONSTRAINT `goals_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`),
  CONSTRAINT `goals_chk_1` CHECK ((`goal_minute` between 1 and 120))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goals`
--

LOCK TABLES `goals` WRITE;
/*!40000 ALTER TABLE `goals` DISABLE KEYS */;
INSERT INTO `goals` VALUES (1,1,5,23),(2,1,4,67),(3,1,10,55),(4,2,15,12),(5,2,20,34),(6,2,20,78),(7,3,5,9),(8,3,15,88),(9,4,10,30),(10,4,9,45),(11,4,19,60),(12,5,20,15),(13,5,5,50),(14,5,5,81),(15,6,15,40),(16,6,14,70),(17,6,8,85);
/*!40000 ALTER TABLE `goals` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_goal_after_insert` AFTER INSERT ON `goals` FOR EACH ROW BEGIN
    DECLARE v_team INT;
    SELECT team_id INTO v_team FROM player WHERE player_id = NEW.player_id;
    UPDATE matches
       SET home_score = home_score + (v_team = home_team_id),
           away_score = away_score + (v_team = away_team_id)
     WHERE match_id = NEW.match_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matches` (
  `match_id` int NOT NULL AUTO_INCREMENT,
  `match_date` date NOT NULL,
  `home_team_id` int NOT NULL,
  `away_team_id` int NOT NULL,
  `stadium_id` int NOT NULL,
  `home_score` int NOT NULL DEFAULT '0',
  `away_score` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`match_id`),
  KEY `home_team_id` (`home_team_id`),
  KEY `away_team_id` (`away_team_id`),
  KEY `stadium_id` (`stadium_id`),
  CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`home_team_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`away_team_id`) REFERENCES `team` (`team_id`),
  CONSTRAINT `matches_ibfk_3` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`),
  CONSTRAINT `matches_chk_1` CHECK ((`home_team_id` <> `away_team_id`))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */;
INSERT INTO `matches` VALUES (1,'2026-09-05',1,2,1,2,1),(2,'2026-09-06',3,4,3,1,2),(3,'2026-09-12',1,3,1,1,1),(4,'2026-09-13',2,4,2,2,1),(5,'2026-09-19',4,1,4,1,2),(6,'2026-09-20',2,3,2,1,2);
/*!40000 ALTER TABLE `matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player` (
  `player_id` int NOT NULL AUTO_INCREMENT,
  `player_name` varchar(80) NOT NULL,
  `jersey_no` int NOT NULL,
  `player_position` enum('GK','DF','MF','FW') NOT NULL,
  `dob` date DEFAULT NULL,
  `nationality` varchar(50) DEFAULT NULL,
  `team_id` int NOT NULL,
  PRIMARY KEY (`player_id`),
  UNIQUE KEY `team_id` (`team_id`,`jersey_no`),
  CONSTRAINT `player_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `team` (`team_id`) ON DELETE CASCADE,
  CONSTRAINT `player_chk_1` CHECK ((`jersey_no` between 1 and 99))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES (1,'Aman Singh',1,'GK','1998-03-14','India',1),(2,'Vikram Rao',4,'DF','1997-07-21','India',1),(3,'Sahil Khan',8,'MF','1999-01-09','India',1),(4,'Rohan Mehta',10,'MF','2000-11-30','India',1),(5,'Karan Joshi',9,'FW','1996-05-17','India',1),(6,'Nikhil Pawar',1,'GK','1995-02-25','India',2),(7,'Joao Silva',5,'DF','1994-09-12','Portugal',2),(8,'Aditya Naik',6,'MF','1999-04-03','India',2),(9,'Rafael Costa',7,'MF','1998-08-19','Brazil',2),(10,'Diego Alves',9,'FW','1997-12-05','Brazil',2),(11,'Soumya Das',1,'GK','1996-06-28','India',3),(12,'Biswajit Roy',3,'DF','1998-10-02','India',3),(13,'Arnab Ghosh',8,'MF','1999-03-23','India',3),(14,'Tanmay Bose',10,'MF','2001-01-15','India',3),(15,'Subhas Dey',9,'FW','1995-07-07','India',3),(16,'Karthik Raj',1,'GK','1997-04-11','India',4),(17,'Suresh Kumar',2,'DF','1996-09-30','India',4),(18,'Ethan Brooks',8,'MF','1999-12-12','England',4),(19,'Vijay Anand',11,'MF','2000-02-20','India',4),(20,'Luca Romano',9,'FW','1998-06-06','Italy',4);
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `points_table`
--

DROP TABLE IF EXISTS `points_table`;
/*!50001 DROP VIEW IF EXISTS `points_table`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `points_table` AS SELECT 
 1 AS `team_id`,
 1 AS `team_name`,
 1 AS `played`,
 1 AS `won`,
 1 AS `drawn`,
 1 AS `lost`,
 1 AS `goals_for`,
 1 AS `goals_against`,
 1 AS `points`,
 1 AS `goal_diff`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `stadium`
--

DROP TABLE IF EXISTS `stadium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stadium` (
  `stadium_id` int NOT NULL AUTO_INCREMENT,
  `stadium_name` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `capacity` int NOT NULL,
  PRIMARY KEY (`stadium_id`),
  CONSTRAINT `stadium_chk_1` CHECK ((`capacity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stadium`
--

LOCK TABLES `stadium` WRITE;
/*!40000 ALTER TABLE `stadium` DISABLE KEYS */;
INSERT INTO `stadium` VALUES (1,'Capital Arena','Delhi',60000),(2,'Marine Drive Stadium','Mumbai',55000),(3,'Hooghly Stadium','Kolkata',68000),(4,'Marina Ground','Chennai',40000);
/*!40000 ALTER TABLE `stadium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `team_name` varchar(80) NOT NULL,
  `city` varchar(50) NOT NULL,
  `founded_year` int DEFAULT NULL,
  `stadium_id` int NOT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE KEY `team_name` (`team_name`),
  KEY `stadium_id` (`stadium_id`),
  CONSTRAINT `team_ibfk_1` FOREIGN KEY (`stadium_id`) REFERENCES `stadium` (`stadium_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES (1,'Delhi Titans FC','Delhi',2015,1),(2,'Mumbai Strikers FC','Mumbai',2012,2),(3,'Kolkata Royals FC','Kolkata',1998,3),(4,'Chennai Warriors FC','Chennai',2008,4);
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `top_scorers`
--

DROP TABLE IF EXISTS `top_scorers`;
/*!50001 DROP VIEW IF EXISTS `top_scorers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `top_scorers` AS SELECT 
 1 AS `player_id`,
 1 AS `player_name`,
 1 AS `team_name`,
 1 AS `total_goals`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'football_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_team_squad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_team_squad`(IN p_team_id INT)
BEGIN
    SELECT jersey_no, player_name, player_position, nationality
    FROM player WHERE team_id = p_team_id ORDER BY jersey_no;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `football_db`
--

USE `football_db`;

--
-- Final view structure for view `points_table`
--

/*!50001 DROP VIEW IF EXISTS `points_table`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `points_table` AS select `s`.`team_id` AS `team_id`,`s`.`team_name` AS `team_name`,`s`.`played` AS `played`,`s`.`won` AS `won`,`s`.`drawn` AS `drawn`,`s`.`lost` AS `lost`,`s`.`goals_for` AS `goals_for`,`s`.`goals_against` AS `goals_against`,((`s`.`won` * 3) + `s`.`drawn`) AS `points`,(`s`.`goals_for` - `s`.`goals_against`) AS `goal_diff` from (select `t`.`team_id` AS `team_id`,`t`.`team_name` AS `team_name`,count(`m`.`match_id`) AS `played`,sum((case when (((`m`.`home_team_id` = `t`.`team_id`) and (`m`.`home_score` > `m`.`away_score`)) or ((`m`.`away_team_id` = `t`.`team_id`) and (`m`.`away_score` > `m`.`home_score`))) then 1 else 0 end)) AS `won`,sum((case when ((`m`.`match_id` is not null) and (`m`.`home_score` = `m`.`away_score`)) then 1 else 0 end)) AS `drawn`,sum((case when (((`m`.`home_team_id` = `t`.`team_id`) and (`m`.`home_score` < `m`.`away_score`)) or ((`m`.`away_team_id` = `t`.`team_id`) and (`m`.`away_score` < `m`.`home_score`))) then 1 else 0 end)) AS `lost`,sum((case when (`m`.`home_team_id` = `t`.`team_id`) then `m`.`home_score` when (`m`.`away_team_id` = `t`.`team_id`) then `m`.`away_score` else 0 end)) AS `goals_for`,sum((case when (`m`.`home_team_id` = `t`.`team_id`) then `m`.`away_score` when (`m`.`away_team_id` = `t`.`team_id`) then `m`.`home_score` else 0 end)) AS `goals_against` from (`team` `t` left join `matches` `m` on((`t`.`team_id` in (`m`.`home_team_id`,`m`.`away_team_id`)))) group by `t`.`team_id`,`t`.`team_name`) `s` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `top_scorers`
--

/*!50001 DROP VIEW IF EXISTS `top_scorers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `top_scorers` AS select `p`.`player_id` AS `player_id`,`p`.`player_name` AS `player_name`,`t`.`team_name` AS `team_name`,count(`g`.`goal_id`) AS `total_goals` from ((`player` `p` join `team` `t` on((`p`.`team_id` = `t`.`team_id`))) join `goals` `g` on((`g`.`player_id` = `p`.`player_id`))) group by `p`.`player_id`,`p`.`player_name`,`t`.`team_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-25 18:54:08
