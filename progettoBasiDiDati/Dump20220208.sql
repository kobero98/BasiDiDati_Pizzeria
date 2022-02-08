CREATE DATABASE  IF NOT EXISTS `pizzeria` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pizzeria`;
-- MySQL dump 10.13  Distrib 8.0.28, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: pizzeria
-- ------------------------------------------------------
-- Server version	8.0.28-0ubuntu0.21.10.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `Scontrini`
--

DROP TABLE IF EXISTS `Scontrini`;
/*!50001 DROP VIEW IF EXISTS `Scontrini`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Scontrini` AS SELECT 
 1 AS `Cliente`,
 1 AS `IDPizza`,
 1 AS `NomeP`,
 1 AS `Quantita`,
 1 AS `prezzo`,
 1 AS `Aggiunta`,
 1 AS `porzione`,
 1 AS `Costo`,
 1 AS `CostoTotaleProdotto`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Utenti`
--

DROP TABLE IF EXISTS `Utenti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Utenti` (
  `Username` varchar(45) NOT NULL,
  `Pass` varchar(45) NOT NULL,
  `Ruolo` int NOT NULL,
  PRIMARY KEY (`Username`,`Pass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Utenti`
--

LOCK TABLES `Utenti` WRITE;
/*!40000 ALTER TABLE `Utenti` DISABLE KEYS */;
INSERT INTO `Utenti` VALUES ('barista','1234',1),('cameriere','1234',4),('manager','1234',2),('pizzaiolo','1234',3);
/*!40000 ALTER TABLE `Utenti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `ViewPizzaioloOrdini`
--

DROP TABLE IF EXISTS `ViewPizzaioloOrdini`;
/*!50001 DROP VIEW IF EXISTS `ViewPizzaioloOrdini`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ViewPizzaioloOrdini` AS SELECT 
 1 AS `DataOrdine`,
 1 AS `IDPizza`,
 1 AS `NomeP`,
 1 AS `Stato`,
 1 AS `Quantita`,
 1 AS `Aggiunta`,
 1 AS `porzione`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `add`
--

DROP TABLE IF EXISTS `add`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `add` (
  `Aggiunta` varchar(15) NOT NULL,
  `porzione` int NOT NULL DEFAULT '1',
  `IDpizza` int NOT NULL,
  PRIMARY KEY (`Aggiunta`,`IDpizza`),
  KEY `Aggiunta_idx` (`Aggiunta`),
  KEY `fkpizza_idx` (`IDpizza`),
  CONSTRAINT `fkAggiunta` FOREIGN KEY (`Aggiunta`) REFERENCES `ingredienti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fkpizza` FOREIGN KEY (`IDpizza`) REFERENCES `pizze` (`IDPizza`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `add`
--

LOCK TABLES `add` WRITE;
/*!40000 ALTER TABLE `add` DISABLE KEYS */;
INSERT INTO `add` VALUES ('funghi',1,44),('funghi',1,46),('funghi',1,48),('funghi',1,52),('funghi',3,54),('funghi',1,56),('funghi',1,58),('funghi',2,61),('funghi',1,65),('melanzana',1,56),('melanzana',1,63),('mozzarella',1,60),('salsiccia',1,53);
/*!40000 ALTER TABLE `add` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `verificaAggiunta` BEFORE INSERT ON `add` FOR EACH ROW BEGIN
	declare msg varchar(128);
    declare s float;
    select Costo from ingredienti where new.Aggiunta=Nome into s;
    if s=0 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ',new.Aggiunta);
        signal sqlstate '45000' set message_text = msg;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `ControlloAggiunte` BEFORE INSERT ON `add` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
    declare q int;
    declare i int default 1;
    select Quantita into q from pizze where IDPizza=new.IDpizza;
    select count(I.nome) into app
    from `pizzeria`.`ingredienti` as I 
    where new.porzione*q > I.Quantita and I.nome=new.Aggiunta and I.Costo>0;
	if app>0 then
		set msg = concat('MyTriggerError: Non ci sono abbastanza ingredienti per quest aggiunta: ',new.Aggiunta);
        signal sqlstate '45000' set message_text = msg;
    else
		update ingredienti as i
		set Quantita=Quantita-new.porzione*q 
        where i.Nome=new.Aggiunta;
    end if;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bevande`
--

DROP TABLE IF EXISTS `bevande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bevande` (
  `Clienti` int NOT NULL,
  `DataComanda` datetime NOT NULL,
  `NomeProdotto` varchar(15) NOT NULL,
  `Stato` varchar(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` int NOT NULL DEFAULT '1',
  `IDBevande` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`IDBevande`),
  KEY `FKComande_idx` (`Clienti`,`DataComanda`),
  KEY `FKProdotti_idx` (`NomeProdotto`),
  KEY `indice_Stato_bevande` (`Stato`),
  CONSTRAINT `FKComande` FOREIGN KEY (`Clienti`, `DataComanda`) REFERENCES `comande` (`Cliente`, `Data`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKProdotti` FOREIGN KEY (`NomeProdotto`) REFERENCES `prodotti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bevande`
--

LOCK TABLES `bevande` WRITE;
/*!40000 ALTER TABLE `bevande` DISABLE KEYS */;
INSERT INTO `bevande` VALUES (25,'2022-02-03 16:07:59','pepsicola','Pronto',1,4),(25,'2022-02-03 16:07:59','peroni','Pronto',1,5),(26,'2022-02-03 20:21:29','pepsicola','Pronto',1,6),(25,'2022-02-03 23:48:24','pepsicola','Pronto',1,7),(27,'2022-02-06 14:38:14','pepsicola','Pronto',1,8),(30,'2022-02-08 10:25:48','peroni','Pronto',3,9);
/*!40000 ALTER TABLE `bevande` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `ControlloBevanda` BEFORE INSERT ON `bevande` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
	Select `prodotti`.tipo from `prodotti` where new.NomeProdotto=`prodotti`.Nome into app;
    if app= 1 then
		set msg = concat('MyTriggerError ControlloBevanda: Trying to insert a negative value in trigger_test: ',app);
        signal sqlstate '45000' set message_text = msg;
    end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `bevande` BEFORE INSERT ON `bevande` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
    declare nome varchar(15);
    declare i int default 1;
    select count(I.nome) into app
    from `pizzeria`.`prodotti` as P join `pizzeria`.`ricettacolo` as R on P.Nome=R.NomeProdotto join `pizzeria`.`ingredienti` as I on R.NomeIngrediente = I.Nome 
    where R.Quantita*new.Quantita > I.Quantita and P.Nome=new.NomeProdotto;
	if app>0 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ',new.NomeProdotto);
        signal sqlstate '45000' set message_text = msg;
    else
		update ingredienti as i
		set Quantita=Quantita-new.Quantita*(select Quantita from ricettacolo as R where R.NomeIngrediente=i.Nome and Nomeprodotto=new.NomeProdotto) 
        where i.Nome in (select NomeIngrediente from ricettacolo as R where R.NomeIngrediente=i.Nome and Nomeprodotto=new.NomeProdotto);
    end if;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `bevande_AFTER_UPDATE` AFTER UPDATE ON `bevande` FOR EACH ROW BEGIN
	declare i int;
    declare j int;
    
	select count(*) into i  
    from comande as c join pizze as p on p.Cliente=c.Cliente and p.DataComanda=c.Data
	where c.Cliente=new.Clienti and c.Data=new.DataComanda and p.Stato='in preparazione';
	
    select count(*) into j  
    from comande as c join bevande as p on p.Clienti=c.Cliente and p.DataComanda=c.Data
	where c.Cliente=new.Clienti and c.Data=new.DataComanda and p.Stato='in preparazione';
    
    if i+j=0 then 
		update comande set Completata='completa' where Cliente=new.Clienti and Data=new.DataComanda; 
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `camerieri`
--

DROP TABLE IF EXISTS `camerieri`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `camerieri` (
  `Nome` varchar(15) NOT NULL,
  `Cognome` varchar(15) NOT NULL,
  PRIMARY KEY (`Nome`,`Cognome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `camerieri`
--

LOCK TABLES `camerieri` WRITE;
/*!40000 ALTER TABLE `camerieri` DISABLE KEYS */;
INSERT INTO `camerieri` VALUES ('cameriere','cameriere'),('cameriere2','cameriere2'),('giuseppe','federico'),('lorenzo','d'),('m','f'),('matteo','federico'),('steven','cameriere');
/*!40000 ALTER TABLE `camerieri` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clienti`
--

DROP TABLE IF EXISTS `clienti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clienti` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Nome` varchar(15) NOT NULL,
  `Cognome` varchar(15) NOT NULL,
  `N_persone` int NOT NULL,
  `FTavolo` int DEFAULT NULL,
  `Turno` datetime DEFAULT NULL,
  `Spesa` int DEFAULT '0',
  PRIMARY KEY (`ID`),
  KEY `fk_Tavolo_idx` (`FTavolo`,`Turno`),
  CONSTRAINT `fk_Tavolo` FOREIGN KEY (`FTavolo`, `Turno`) REFERENCES `tavoloeffettivo` (`Tavolo`, `TurnoData`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clienti`
--

LOCK TABLES `clienti` WRITE;
/*!40000 ALTER TABLE `clienti` DISABLE KEYS */;
INSERT INTO `clienti` VALUES (17,'matteo','pazzizzo',3,NULL,NULL,0),(18,'luigi','talamo',3,NULL,NULL,0),(19,'nando','ferraro',5,1,'2022-02-01 08:00:00',0),(20,'peppe','peppe',4,5,'2022-02-02 08:00:00',0),(21,'matte','federico',6,1,'2022-02-02 16:00:00',50),(22,'giggi','testo',5,3,'2022-02-03 00:00:00',0),(23,'d','f',3,1,'2022-02-03 00:00:00',0),(24,'marzai','ara',4,1,'2022-02-03 08:00:00',0),(25,'matteo','federico',3,1,'2022-02-03 16:00:00',0),(26,'lorenzo','federico',3,2,'2022-02-03 16:00:00',0),(27,'f','s',3,1,'2022-02-06 08:00:00',8),(28,'f','d',3,3,'2022-02-06 08:00:00',0),(29,'f','d',3,1,'2022-02-06 08:00:00',0),(30,'f','d',3,1,'2022-02-08 08:00:00',27);
/*!40000 ALTER TABLE `clienti` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `clienti_BEFORE_INSERT` BEFORE INSERT ON `clienti` FOR EACH ROW BEGIN
	declare i int;
    declare msg varchar(128);
	select count(CameriereNome) from tavoloeffettivo where Tavolo=new.FTavolo and TurnoData=new.Turno into i;
    if i=0 then
		set msg = concat('MyTriggerError: il tavolo é sprovvisto di cameriere assegnat prima il cameriere al tavolo: ',new.FTavolo);
        signal sqlstate '45000' set message_text = msg;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `comande`
--

DROP TABLE IF EXISTS `comande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comande` (
  `Cliente` int NOT NULL,
  `Data` datetime NOT NULL,
  `Completata` varchar(10) NOT NULL,
  PRIMARY KEY (`Cliente`,`Data`),
  KEY `indice_Stato_comande` (`Completata`),
  CONSTRAINT `Clienti` FOREIGN KEY (`Cliente`) REFERENCES `clienti` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comande`
--

LOCK TABLES `comande` WRITE;
/*!40000 ALTER TABLE `comande` DISABLE KEYS */;
INSERT INTO `comande` VALUES (21,'2022-02-02 22:57:04','chiusa'),(21,'2022-02-02 22:58:42','chiusa'),(21,'2022-02-02 22:58:52','chiusa'),(21,'2022-02-02 22:59:41','chiusa'),(23,'2022-02-03 00:05:45','chiusa'),(24,'2022-02-03 12:21:48','chiusa'),(24,'2022-02-03 12:50:12','chiusa'),(25,'2022-02-03 16:07:59','chiusa'),(25,'2022-02-03 23:48:24','chiusa'),(26,'2022-02-03 20:21:29','chiusa'),(27,'2022-02-06 14:38:14','chiusa'),(30,'2022-02-08 10:25:48','chiusa');
/*!40000 ALTER TABLE `comande` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredienti`
--

DROP TABLE IF EXISTS `ingredienti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredienti` (
  `Nome` varchar(15) NOT NULL,
  `Quantita` int NOT NULL DEFAULT '0',
  `Costo` float DEFAULT '0',
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredienti`
--

LOCK TABLES `ingredienti` WRITE;
/*!40000 ALTER TABLE `ingredienti` DISABLE KEYS */;
INSERT INTO `ingredienti` VALUES ('acciughe',900,1),('acqua',260,0),('alici',898,1),('basilico',59,0),('carne',52,0),('farina',168,0),('funghi',41,1),('melanzana',127,1),('moretti',900,0),('mozzarella',890,1),('olio',899,0),('olive',900,0),('peperoni',900,1),('pepsicola',896,0),('peroni',896,0),('salame',900,0),('salsiccia',892,2),('sugo',177,0),('uovo',900,2),('zucchine',90,1);
/*!40000 ALTER TABLE `ingredienti` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ControlloQuantita` BEFORE INSERT ON `ingredienti` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	if new.Quantita<1	then
		set msg = concat('MyTriggerError: Una Quantita non può essere begativa: ', cast(new.Quantita as char));
        signal sqlstate '45000' set message_text = msg;
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pizze`
--

DROP TABLE IF EXISTS `pizze`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pizze` (
  `Cliente` int NOT NULL,
  `DataComanda` datetime NOT NULL,
  `NomeP` varchar(15) NOT NULL,
  `Stato` varchar(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` int NOT NULL DEFAULT '1',
  `IDPizza` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`IDPizza`),
  KEY `FKProdotto_idx` (`NomeP`),
  KEY `FkComanda_idx` (`Cliente`,`DataComanda`),
  KEY `indice_Stato_pizze` (`Stato`),
  CONSTRAINT `FkComanda` FOREIGN KEY (`Cliente`, `DataComanda`) REFERENCES `comande` (`Cliente`, `Data`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKProdotto` FOREIGN KEY (`NomeP`) REFERENCES `prodotti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pizze`
--

LOCK TABLES `pizze` WRITE;
/*!40000 ALTER TABLE `pizze` DISABLE KEYS */;
INSERT INTO `pizze` VALUES (21,'2022-02-02 22:57:04','margherita','pronto',1,44),(21,'2022-02-02 22:57:04','boscaiola','pronto',1,45),(21,'2022-02-02 22:58:42','margherita','pronto',1,46),(21,'2022-02-02 22:58:42','boscaiola','pronto',1,47),(21,'2022-02-02 22:58:52','margherita','pronto',1,48),(21,'2022-02-02 22:58:52','boscaiola','pronto',1,49),(21,'2022-02-02 22:59:41','margherita','pronto',1,52),(21,'2022-02-02 22:59:41','boscaiola','pronto',1,53),(23,'2022-02-03 00:05:45','boscaiola','pronto',1,54),(24,'2022-02-03 12:21:48','margherita','pronto',2,56),(24,'2022-02-03 12:50:12','margherita','pronto',2,57),(24,'2022-02-03 12:50:12','boscaiola','pronto',2,58),(25,'2022-02-03 16:07:59','boscaiola','pronto',1,60),(26,'2022-02-03 20:21:29','margherita','pronto',1,61),(25,'2022-02-03 23:48:24','boscaiola','pronto',1,62),(27,'2022-02-06 14:38:14','marinara','pronto',1,63),(30,'2022-02-08 10:25:48','boscaiola','pronto',2,64),(30,'2022-02-08 10:25:48','marinara','pronto',1,65);
/*!40000 ALTER TABLE `pizze` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `ControlloPizza` BEFORE INSERT ON `pizze` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
	Select `prodotti`.tipo	into app from `prodotti` where new.NomeP=`prodotti`.Nome;
    if app= 0 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ', new.NomeP);
        signal sqlstate '45000' set message_text = msg;
    end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `pizze` BEFORE INSERT ON `pizze` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
    declare nome varchar(15);
    declare i int default 1;
    select count(I.nome) into app
    from `pizzeria`.`prodotti` as P join `pizzeria`.`ricettacolo` as R on P.Nome=R.NomeProdotto join `pizzeria`.`ingredienti` as I on R.NomeIngrediente = I.Nome 
    where R.Quantita*new.Quantita > I.Quantita and P.Nome=new.NomeP;
	if app>0 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ',new.NomeP);
        signal sqlstate '45000' set message_text = msg;
    else
		update ingredienti as i
		set Quantita=Quantita-new.Quantita*(select Quantita from ricettacolo as R where R.NomeIngrediente=i.Nome and R.Nomeprodotto=new.NomeP) 
        where i.Nome in (select NomeIngrediente from ricettacolo as R where R.NomeIngrediente=i.Nome and R.Nomeprodotto=new.NomeP);
    end if;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`kobero`@`localhost`*/ /*!50003 TRIGGER `pizze_AFTER_UPDATE` AFTER UPDATE ON `pizze` FOR EACH ROW BEGIN
	declare i int;
    declare j int;
    
	select count(*) into i  
    from comande as c join pizze as p on p.Cliente=c.Cliente and p.DataComanda=c.Data
	where c.Cliente=new.Cliente and c.Data=new.DataComanda and p.Stato='in preparazione';
	
    select count(*) into j  
    from comande as c join bevande as p on p.Clienti=c.Cliente and p.DataComanda=c.Data
	where c.Cliente=new.Cliente and c.Data=new.DataComanda and p.Stato='in preparazione';
    
    if i+j=0 then 
		update comande set Completata='completa' where Cliente=new.Cliente and Data=new.DataComanda; 
	end if;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `prodotti`
--

DROP TABLE IF EXISTS `prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotti` (
  `Nome` varchar(15) NOT NULL,
  `Costo` float NOT NULL,
  `Tipo` int NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotti`
--

LOCK TABLES `prodotti` WRITE;
/*!40000 ALTER TABLE `prodotti` DISABLE KEYS */;
INSERT INTO `prodotti` VALUES ('boscaiola',6,1),('calzone',6,1),('margherita',5,1),('marinara',5,1),('pepsicola',2,0),('peroni',3,0);
/*!40000 ALTER TABLE `prodotti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ricettacolo`
--

DROP TABLE IF EXISTS `ricettacolo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ricettacolo` (
  `NomeIngrediente` varchar(15) NOT NULL,
  `NomeProdotto` varchar(15) NOT NULL,
  `Quantita` int NOT NULL,
  PRIMARY KEY (`NomeIngrediente`,`NomeProdotto`),
  KEY `Prodotti_idx` (`NomeProdotto`),
  KEY `Ingredienti_idx` (`NomeIngrediente`),
  CONSTRAINT `Ingrediente` FOREIGN KEY (`NomeIngrediente`) REFERENCES `ingredienti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Prodotti` FOREIGN KEY (`NomeProdotto`) REFERENCES `prodotti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ricettacolo`
--

LOCK TABLES `ricettacolo` WRITE;
/*!40000 ALTER TABLE `ricettacolo` DISABLE KEYS */;
INSERT INTO `ricettacolo` VALUES ('acqua','boscaiola',1),('acqua','margherita',1),('alici','marinara',1),('basilico','calzone',1),('basilico','margherita',1),('farina','boscaiola',1),('farina','calzone',2),('farina','margherita',5),('farina','marinara',2),('funghi','boscaiola',4),('mozzarella','boscaiola',2),('mozzarella','calzone',1),('mozzarella','margherita',1),('olio','marinara',1),('pepsicola','pepsicola',1),('peroni','peroni',1),('salsiccia','boscaiola',2),('sugo','calzone',1),('sugo','margherita',1),('sugo','marinara',1);
/*!40000 ALTER TABLE `ricettacolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tavoli`
--

DROP TABLE IF EXISTS `tavoli`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tavoli` (
  `N_Tavolo` int NOT NULL,
  `N_posti` int NOT NULL,
  PRIMARY KEY (`N_Tavolo`),
  KEY `indice_N_Posti_tavolo` (`N_posti`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tavoli`
--

LOCK TABLES `tavoli` WRITE;
/*!40000 ALTER TABLE `tavoli` DISABLE KEYS */;
INSERT INTO `tavoli` VALUES (4,2),(7,2),(8,2),(9,2),(10,3),(3,5),(12,5),(11,6),(1,9),(2,10),(14,10),(13,12),(5,15),(6,32);
/*!40000 ALTER TABLE `tavoli` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tavoloeffettivo`
--

DROP TABLE IF EXISTS `tavoloeffettivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tavoloeffettivo` (
  `Tavolo` int NOT NULL,
  `Disponibilità` tinyint NOT NULL,
  `TurnoData` datetime NOT NULL,
  `CameriereNome` varchar(15) DEFAULT NULL,
  `CameriereCognome` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Tavolo`,`TurnoData`),
  KEY `Turno_idx` (`TurnoData`),
  KEY `Cameriere_idx` (`CameriereNome`,`CameriereCognome`),
  KEY `indice_Disponibilita_tavolo` (`Disponibilità`),
  CONSTRAINT `Cameriere` FOREIGN KEY (`CameriereNome`, `CameriereCognome`) REFERENCES `camerieri` (`Nome`, `Cognome`) ON DELETE SET NULL ON UPDATE SET NULL,
  CONSTRAINT `FKTavolo` FOREIGN KEY (`Tavolo`) REFERENCES `tavoli` (`N_Tavolo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKTurno` FOREIGN KEY (`TurnoData`) REFERENCES `turni` (`Data`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tavoloeffettivo`
--

LOCK TABLES `tavoloeffettivo` WRITE;
/*!40000 ALTER TABLE `tavoloeffettivo` DISABLE KEYS */;
INSERT INTO `tavoloeffettivo` VALUES (1,0,'2022-02-01 08:00:00',NULL,NULL),(1,0,'2022-02-02 16:00:00',NULL,NULL),(1,0,'2022-02-03 00:00:00',NULL,NULL),(1,0,'2022-02-03 08:00:00',NULL,NULL),(1,0,'2022-02-03 16:00:00',NULL,NULL),(1,0,'2022-02-06 08:00:00','cameriere','cameriere'),(1,1,'2022-02-06 16:00:00',NULL,NULL),(1,1,'2022-02-07 08:00:00',NULL,NULL),(1,1,'2022-02-08 08:00:00','cameriere','cameriere'),(2,1,'2022-02-02 16:00:00',NULL,NULL),(2,1,'2022-02-03 08:00:00',NULL,NULL),(2,0,'2022-02-03 16:00:00',NULL,NULL),(2,1,'2022-02-06 08:00:00',NULL,NULL),(3,1,'2022-02-01 08:00:00',NULL,NULL),(3,1,'2022-02-02 08:00:00',NULL,NULL),(3,0,'2022-02-03 00:00:00',NULL,NULL),(3,1,'2022-02-03 16:00:00','matteo','federico'),(3,0,'2022-02-06 08:00:00','lorenzo','d'),(4,1,'2022-02-04 16:00:00',NULL,NULL),(5,1,'2022-02-01 08:00:00',NULL,NULL),(5,0,'2022-02-02 08:00:00',NULL,NULL),(5,1,'2022-02-02 16:00:00',NULL,NULL),(6,1,'2022-02-01 08:00:00',NULL,NULL),(6,1,'2022-02-02 08:00:00',NULL,NULL);
/*!40000 ALTER TABLE `tavoloeffettivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `turni`
--

DROP TABLE IF EXISTS `turni`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turni` (
  `Data` datetime NOT NULL,
  `Ora_fine` time NOT NULL,
  PRIMARY KEY (`Data`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turni`
--

LOCK TABLES `turni` WRITE;
/*!40000 ALTER TABLE `turni` DISABLE KEYS */;
INSERT INTO `turni` VALUES ('2022-02-01 00:00:00','08:00:00'),('2022-02-01 08:00:00','16:00:00'),('2022-02-01 16:00:00','00:00:00'),('2022-02-02 00:00:00','08:00:00'),('2022-02-02 08:00:00','16:00:00'),('2022-02-02 16:00:00','00:00:00'),('2022-02-03 00:00:00','08:00:00'),('2022-02-03 08:00:00','16:00:00'),('2022-02-03 16:00:00','00:00:00'),('2022-02-04 00:00:00','08:00:00'),('2022-02-04 08:00:00','16:00:00'),('2022-02-04 16:00:00','00:00:00'),('2022-02-05 00:00:00','08:00:00'),('2022-02-05 08:00:00','16:00:00'),('2022-02-05 16:00:00','00:00:00'),('2022-02-06 00:00:00','08:00:00'),('2022-02-06 08:00:00','16:00:00'),('2022-02-06 16:00:00','00:00:00'),('2022-02-07 00:00:00','08:00:00'),('2022-02-07 08:00:00','16:00:00'),('2022-02-07 16:00:00','00:00:00'),('2022-02-08 00:00:00','08:00:00'),('2022-02-08 08:00:00','16:00:00'),('2022-02-08 16:00:00','00:00:00'),('2022-02-09 00:00:00','08:00:00'),('2022-02-09 08:00:00','16:00:00'),('2022-02-09 16:00:00','00:00:00'),('2022-02-10 00:00:00','08:00:00'),('2022-02-10 08:00:00','16:00:00'),('2022-02-10 16:00:00','00:00:00'),('2022-02-11 00:00:00','08:00:00'),('2022-02-11 08:00:00','16:00:00'),('2022-02-11 16:00:00','00:00:00'),('2022-02-12 00:00:00','08:00:00'),('2022-02-12 08:00:00','16:00:00'),('2022-02-12 16:00:00','00:00:00'),('2022-02-13 00:00:00','08:00:00'),('2022-02-13 08:00:00','16:00:00'),('2022-02-13 16:00:00','00:00:00'),('2022-02-14 00:00:00','08:00:00'),('2022-02-14 08:00:00','16:00:00'),('2022-02-14 16:00:00','00:00:00'),('2022-02-15 00:00:00','08:00:00'),('2022-02-15 08:00:00','16:00:00'),('2022-02-15 16:00:00','00:00:00'),('2022-02-16 00:00:00','08:00:00'),('2022-02-16 08:00:00','16:00:00'),('2022-02-16 16:00:00','00:00:00'),('2022-02-17 00:00:00','08:00:00'),('2022-02-17 08:00:00','16:00:00'),('2022-02-17 16:00:00','00:00:00'),('2022-02-18 00:00:00','08:00:00'),('2022-02-18 08:00:00','16:00:00'),('2022-02-18 16:00:00','00:00:00'),('2022-02-19 00:00:00','08:00:00'),('2022-02-19 08:00:00','16:00:00'),('2022-02-19 16:00:00','00:00:00'),('2022-02-20 00:00:00','08:00:00'),('2022-02-20 08:00:00','16:00:00'),('2022-02-20 16:00:00','00:00:00'),('2022-02-21 00:00:00','08:00:00'),('2022-02-21 08:00:00','16:00:00'),('2022-02-21 16:00:00','00:00:00'),('2022-02-22 00:00:00','08:00:00'),('2022-02-22 08:00:00','16:00:00'),('2022-02-22 16:00:00','00:00:00'),('2022-02-23 00:00:00','08:00:00'),('2022-02-23 08:00:00','16:00:00'),('2022-02-23 16:00:00','00:00:00'),('2022-02-24 00:00:00','08:00:00'),('2022-02-24 08:00:00','16:00:00'),('2022-02-24 16:00:00','00:00:00'),('2022-02-25 00:00:00','08:00:00'),('2022-02-25 08:00:00','16:00:00'),('2022-02-25 16:00:00','00:00:00'),('2022-02-26 00:00:00','08:00:00'),('2022-02-26 08:00:00','16:00:00'),('2022-02-26 16:00:00','00:00:00'),('2022-02-27 00:00:00','08:00:00'),('2022-02-27 08:00:00','16:00:00'),('2022-02-27 16:00:00','00:00:00'),('2022-02-28 00:00:00','08:00:00'),('2022-02-28 08:00:00','16:00:00'),('2022-02-28 16:00:00','00:00:00'),('2022-03-01 00:00:00','08:00:00'),('2022-03-01 08:00:00','16:00:00'),('2022-03-01 16:00:00','00:00:00'),('2022-03-02 00:00:00','08:00:00'),('2022-03-02 08:00:00','16:00:00'),('2022-03-02 16:00:00','00:00:00'),('2022-03-03 00:00:00','08:00:00'),('2022-03-03 08:00:00','16:00:00'),('2022-03-03 16:00:00','00:00:00'),('2022-03-04 00:00:00','08:00:00'),('2022-03-04 08:00:00','16:00:00'),('2022-03-04 16:00:00','00:00:00'),('2022-03-05 00:00:00','08:00:00'),('2022-03-05 08:00:00','16:00:00'),('2022-03-05 16:00:00','00:00:00'),('2022-03-06 00:00:00','08:00:00'),('2022-03-06 08:00:00','16:00:00'),('2022-03-06 16:00:00','00:00:00'),('2022-03-07 00:00:00','08:00:00'),('2022-03-07 08:00:00','16:00:00'),('2022-03-07 16:00:00','00:00:00'),('2022-03-08 00:00:00','08:00:00'),('2022-03-08 08:00:00','16:00:00'),('2022-03-08 16:00:00','00:00:00'),('2022-03-09 00:00:00','08:00:00'),('2022-03-09 08:00:00','16:00:00'),('2022-03-09 16:00:00','00:00:00'),('2022-03-10 00:00:00','08:00:00'),('2022-03-10 08:00:00','16:00:00'),('2022-03-10 16:00:00','00:00:00'),('2022-03-11 00:00:00','08:00:00'),('2022-03-11 08:00:00','16:00:00'),('2022-03-11 16:00:00','00:00:00'),('2022-03-12 00:00:00','08:00:00'),('2022-03-12 08:00:00','16:00:00'),('2022-03-12 16:00:00','00:00:00'),('2022-03-13 00:00:00','08:00:00'),('2022-03-13 08:00:00','16:00:00'),('2022-03-13 16:00:00','00:00:00'),('2022-03-14 00:00:00','08:00:00'),('2022-03-14 08:00:00','16:00:00'),('2022-03-14 16:00:00','00:00:00'),('2022-03-15 00:00:00','08:00:00'),('2022-03-15 08:00:00','16:00:00'),('2022-03-15 16:00:00','00:00:00'),('2022-03-16 00:00:00','08:00:00'),('2022-03-16 08:00:00','16:00:00'),('2022-03-16 16:00:00','00:00:00'),('2022-03-17 00:00:00','08:00:00'),('2022-03-17 08:00:00','16:00:00'),('2022-03-17 16:00:00','00:00:00'),('2022-03-18 00:00:00','08:00:00'),('2022-03-18 08:00:00','16:00:00'),('2022-03-18 16:00:00','00:00:00'),('2022-03-19 00:00:00','08:00:00'),('2022-03-19 08:00:00','16:00:00'),('2022-03-19 16:00:00','00:00:00'),('2022-03-20 00:00:00','08:00:00'),('2022-03-20 08:00:00','16:00:00'),('2022-03-20 16:00:00','00:00:00'),('2022-03-21 00:00:00','08:00:00'),('2022-03-21 08:00:00','16:00:00'),('2022-03-21 16:00:00','00:00:00'),('2022-03-22 00:00:00','08:00:00'),('2022-03-22 08:00:00','16:00:00'),('2022-03-22 16:00:00','00:00:00'),('2022-03-23 00:00:00','08:00:00'),('2022-03-23 08:00:00','16:00:00'),('2022-03-23 16:00:00','00:00:00'),('2022-03-24 00:00:00','08:00:00'),('2022-03-24 08:00:00','16:00:00'),('2022-03-24 16:00:00','00:00:00'),('2022-03-25 00:00:00','08:00:00'),('2022-03-25 08:00:00','16:00:00'),('2022-03-25 16:00:00','00:00:00'),('2022-03-26 00:00:00','08:00:00'),('2022-03-26 08:00:00','16:00:00'),('2022-03-26 16:00:00','00:00:00'),('2022-03-27 00:00:00','08:00:00'),('2022-03-27 08:00:00','16:00:00'),('2022-03-27 16:00:00','00:00:00'),('2022-03-28 00:00:00','08:00:00'),('2022-03-28 08:00:00','16:00:00'),('2022-03-28 16:00:00','00:00:00'),('2022-03-29 00:00:00','08:00:00'),('2022-03-29 08:00:00','16:00:00'),('2022-03-29 16:00:00','00:00:00'),('2022-03-30 00:00:00','08:00:00'),('2022-03-30 08:00:00','16:00:00'),('2022-03-30 16:00:00','00:00:00'),('2022-03-31 00:00:00','08:00:00'),('2022-03-31 08:00:00','16:00:00'),('2022-03-31 16:00:00','00:00:00'),('2022-08-01 00:00:00','08:00:00'),('2022-08-01 08:00:00','16:00:00'),('2022-08-01 16:00:00','00:00:00'),('2022-08-02 00:00:00','08:00:00'),('2022-08-02 08:00:00','16:00:00'),('2022-08-02 16:00:00','00:00:00'),('2022-08-03 00:00:00','08:00:00'),('2022-08-03 08:00:00','16:00:00'),('2022-08-03 16:00:00','00:00:00'),('2022-08-04 00:00:00','08:00:00'),('2022-08-04 08:00:00','16:00:00'),('2022-08-04 16:00:00','00:00:00'),('2022-08-05 00:00:00','08:00:00'),('2022-08-05 08:00:00','16:00:00'),('2022-08-05 16:00:00','00:00:00'),('2022-08-06 00:00:00','08:00:00'),('2022-08-06 08:00:00','16:00:00'),('2022-08-06 16:00:00','00:00:00'),('2022-08-07 00:00:00','08:00:00'),('2022-08-07 08:00:00','16:00:00'),('2022-08-07 16:00:00','00:00:00'),('2022-08-08 00:00:00','08:00:00'),('2022-08-08 08:00:00','16:00:00'),('2022-08-08 16:00:00','00:00:00'),('2022-08-09 00:00:00','08:00:00'),('2022-08-09 08:00:00','16:00:00'),('2022-08-09 16:00:00','00:00:00'),('2022-08-10 00:00:00','08:00:00'),('2022-08-10 08:00:00','16:00:00'),('2022-08-10 16:00:00','00:00:00'),('2022-08-11 00:00:00','08:00:00'),('2022-08-11 08:00:00','16:00:00'),('2022-08-11 16:00:00','00:00:00'),('2022-08-12 00:00:00','08:00:00'),('2022-08-12 08:00:00','16:00:00'),('2022-08-12 16:00:00','00:00:00'),('2022-08-13 00:00:00','08:00:00'),('2022-08-13 08:00:00','16:00:00'),('2022-08-13 16:00:00','00:00:00'),('2022-08-14 00:00:00','08:00:00'),('2022-08-14 08:00:00','16:00:00'),('2022-08-14 16:00:00','00:00:00'),('2022-08-15 00:00:00','08:00:00'),('2022-08-15 08:00:00','16:00:00'),('2022-08-15 16:00:00','00:00:00'),('2022-08-16 00:00:00','08:00:00'),('2022-08-16 08:00:00','16:00:00'),('2022-08-16 16:00:00','00:00:00'),('2022-08-17 00:00:00','08:00:00'),('2022-08-17 08:00:00','16:00:00'),('2022-08-17 16:00:00','00:00:00'),('2022-08-18 00:00:00','08:00:00'),('2022-08-18 08:00:00','16:00:00'),('2022-08-18 16:00:00','00:00:00'),('2022-08-19 00:00:00','08:00:00'),('2022-08-19 08:00:00','16:00:00'),('2022-08-19 16:00:00','00:00:00'),('2022-08-20 00:00:00','08:00:00'),('2022-08-20 08:00:00','16:00:00'),('2022-08-20 16:00:00','00:00:00'),('2022-08-21 00:00:00','08:00:00'),('2022-08-21 08:00:00','16:00:00'),('2022-08-21 16:00:00','00:00:00'),('2022-08-22 00:00:00','08:00:00'),('2022-08-22 08:00:00','16:00:00'),('2022-08-22 16:00:00','00:00:00'),('2022-08-23 00:00:00','08:00:00'),('2022-08-23 08:00:00','16:00:00'),('2022-08-23 16:00:00','00:00:00'),('2022-08-24 00:00:00','08:00:00'),('2022-08-24 08:00:00','16:00:00'),('2022-08-24 16:00:00','00:00:00'),('2022-08-25 00:00:00','08:00:00'),('2022-08-25 08:00:00','16:00:00'),('2022-08-25 16:00:00','00:00:00'),('2022-08-26 00:00:00','08:00:00'),('2022-08-26 08:00:00','16:00:00'),('2022-08-26 16:00:00','00:00:00'),('2022-08-27 00:00:00','08:00:00'),('2022-08-27 08:00:00','16:00:00'),('2022-08-27 16:00:00','00:00:00'),('2022-08-28 00:00:00','08:00:00'),('2022-08-28 08:00:00','16:00:00'),('2022-08-28 16:00:00','00:00:00'),('2022-08-29 00:00:00','08:00:00'),('2022-08-29 08:00:00','16:00:00'),('2022-08-29 16:00:00','00:00:00'),('2022-08-30 00:00:00','08:00:00'),('2022-08-30 08:00:00','16:00:00'),('2022-08-30 16:00:00','00:00:00'),('2022-08-31 00:00:00','08:00:00'),('2022-08-31 08:00:00','16:00:00'),('2022-08-31 16:00:00','00:00:00');
/*!40000 ALTER TABLE `turni` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pizzeria'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `Cancella_clienti` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`kobero`@`localhost`*/ /*!50106 EVENT `Cancella_clienti` ON SCHEDULE EVERY 2 YEAR STARTS '2022-02-06 18:01:50' ON COMPLETION NOT PRESERVE ENABLE DO delete from clienti where  datediff(current_date(),date(Turno))>730 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `Cancella_comanda` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`kobero`@`localhost`*/ /*!50106 EVENT `Cancella_comanda` ON SCHEDULE EVERY 2 MONTH STARTS '2022-02-06 18:01:50' ON COMPLETION NOT PRESERVE ENABLE DO delete from comande where  datediff(current_date(),date(Data))>60 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `Cancella_Turni` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`kobero`@`localhost`*/ /*!50106 EVENT `Cancella_Turni` ON SCHEDULE EVERY 1 YEAR STARTS '2022-02-06 18:01:50' ON COMPLETION NOT PRESERVE ENABLE DO delete from turni where  datediff(current_date(),date(Data))>365 */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'pizzeria'
--
/*!50003 DROP PROCEDURE IF EXISTS `AddCamerieri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCamerieri`(IN N Varchar(15),IN C varchar(15))
BEGIN
	INSERT INTO `pizzeria`.`camerieri`(Nome,Cognome) value (N,C);	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddCliente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCliente`(IN nome VARCHAR(15),IN cognome VARCHAR(15),IN persone INTEGER, IN tavolo INTEGER,IN d DATETIME)
BEGIN	
	set transaction isolation level read committed;
	start transaction;
		INSERT into clienti (Nome,Cognome,N_Persone,FTavolo,Turno) values (nome,cognome,persone,tavolo,d);	
		update tavoloeffettivo set  Disponibilità=0 where `tavoloeffettivo`.Tavolo=tavolo and `tavoloeffettivo`.TurnoData=d;

    commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addIngredienti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addIngredienti`(IN nome VARCHAR(15),IN quantita INT,IN c INT)
BEGIN
	insert into ingredienti(Nome,Quantita,Costo) values (nome,quantita,c);
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addProdotto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addProdotto`(in nome VarChar(15),in prezzo float,in tipo int,in L varchar(2048))
begin
	declare ListaIngredienti varchar(2048);
	declare inizio int default 1;
	declare end1 int default 1;
    declare end2 int default 1;
    declare app varchar(15);
    declare appQ int;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	ROLLBACK; -- rollback any changes made in the transaction
	RESIGNAL; -- raise again the sql exception to the caller
	END;
	set transaction ISOLATION LEVEL READ UNCOMMITTED;
    start transaction;
			set ListaIngredienti = L;
			insert into `pizzeria`.`prodotti` (Nome,Costo,Tipo) values(nome,prezzo,tipo);
            set end2=LOCATE('@',ListaIngredienti);
            while inizio<end2 do
				set end1=Locate('?',ListaIngredienti,inizio);
                set app=substring(ListaIngredienti,inizio,end1-inizio);
				set inizio=end1+1;
                set end1=Locate('#',ListaIngredienti,inizio); 
                set appQ= convert( substring(ListaIngredienti,inizio,end1-inizio), unsigned int );
                insert into `pizzeria`.`ricettacolo`(NomeIngrediente,NomeProdotto,Quantita) values(app,nome,appQ);
				set inizio=end1+1;
            end while;
		 commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddTurno` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddTurno`(IN DataInizio DATETIME)
BEGIN
	INSERT into turni(Data,Ora_fine) values (DataInizio,TIME(ADDTIME(DataInizio,"08:00:00")));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AggiungiTavolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AggiungiTavolo`(IN N_Posti INTEGER)
BEGIN

	Declare Numero INTEGER;

	set transaction isolation level SERIALIZABLE; 

	start transaction;

		Select max(N_Tavolo) from tavoli into Numero;

		IF Numero is not null then

			Insert tavoli (N_Tavolo,N_posti) values (Numero+1,N_posti);

		ELSE

		Insert tavoli (N_Tavolo,N_posti) values (1,N_posti);

		END IF;

		COMMIT;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AssegnareTavoloCameriere` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `AssegnareTavoloCameriere`(in n varchar(15),in c varchar(15),in t int, in turno DATETIME)
BEGIN
	update tavoloeffettivo set CameriereNome=n, CameriereCognome=c where Tavolo=t and TurnoData=turno;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AssegnaTurnoTavolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssegnaTurnoTavolo`(IN tavolo INTEGER, IN data DATETIME )
BEGIN

	INSERT INTO tavoloeffettivo(Tavolo,TurnoData,Disponibilità) values (tavolo,data,1);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BaristaOrdini` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `BaristaOrdini`()
BEGIN
	select IDBevande,NomeProdotto,Quantita from bevande where Stato="in preparazione" order by DataComanda;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BevandePronte` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `BevandePronte`(in id int)
BEGIN
	update bevande set  Stato="Pronto" where IDBevande=id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Cliente_Tavolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `Cliente_Tavolo`(in t int)
BEGIN
	select ID from clienti where FTavolo=t and Spesa=0 and current_timestamp() between Turno and addtime(Turno,'08:00:00');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Creare_Turno` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `Creare_Turno`(in m int,in y int)
BEGIN
	declare  var DATETIME;
    declare i int;
    declare yea int;
    if y = 0 then 
		set yea = year(current_timestamp());
	else set yea = y;
    end if;
    SELECT addtime(adddate(makedate(yea,1), interval m-1 month ),'00:00:00') into var;
    while m=month(var)   do
        call AddTurno(var);
		set var=addtime(var,'08:00:00');
    end while;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `dbListaIngredienti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `dbListaIngredienti`()
BEGIN
	select Nome,Quantita from ingredienti;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IncassiGiornalieri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IncassiGiornalieri`(IN giorno INT,OUT s INT)
BEGIN
	SELECT SUM(Spesa) FROM `clienti` where giorno=DAY(`clienti`.Turno) and month(current_date())=month(`clienti`.Turno) and year(current_date())=year(`clienti`.Turno) into s;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IncassiMensili` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `IncassiMensili`(IN m int,OUT s DOUBLE)
BEGIN
    SELECT SUM(`clienti`.Spesa) into s FROM `clienti` where m=MONTH(`clienti`.Turno) and year(current_date())=year(`clienti`.Turno);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `IncrementaIngrediente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `IncrementaIngrediente`(in n varchar(15),in incr INT)
BEGIN
	update ingredienti set Quantita=Quantita+incr where Nome=n;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ListaAggiunte` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `ListaAggiunte`()
BEGIN
	select Nome,Costo from ingredienti where Costo>0 and Quantita>0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ListCamerieri` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `ListCamerieri`()
BEGIN
	select * from camerieri;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ListTurni` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `ListTurni`()
BEGIN
	Select turni.Data,adddate(turni.Data,interval 8 hour) from turni where turni.Data between ADDDATE(current_time(), INTERVAL -8 hour) and ADDDATE(current_time(), INTERVAL 1 week);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `login` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `login`(in utente varchar(45), in passw varchar(45),out r varchar(45))
BEGIN
	select Ruolo from Utenti where Username=utente and Pass=passw into r;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `menu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `menu`()
BEGIN
	select Nome,Costo,Tipo from prodotti;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Ordine` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Ordine`(in cliente int,in ListaPizze varchar(2048),in ListaBevande varchar(2048))
BEGIN
declare Tempo DATETIME default current_timestamp();
declare inizio int default 1;
declare fine1 int default 1;
declare fine2 int default 1;
declare fine3 int default 1;
declare idP int;		
declare nome varchar(15);
declare nomeAggiunta varchar(15);
declare quantita varchar(15);
declare quantitaAggiunta varchar(15);
declare msg varchar(128);
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK; -- rollback any changes made in the transaction
		RESIGNAL; -- raise again the sql exception to the caller
	END;
set transaction isolation level repeatable read;
start transaction;
		if (select Spesa from clienti where ID=cliente) >0 then
			set msg = concat('MyTriggerError: Il cliente selezionato non può effettuare altri ordini: ',cliente);
			signal sqlstate '45000' set message_text = msg;
        end if;
		insert `pizzeria`.`comande` values (cliente,Tempo,'no');
        set fine2=locate('@',ListaBevande);
        while inizio<fine2 do
			set fine1=Locate('?',ListaBevande,inizio);
			set nome=substring(ListaBevande,inizio,fine1-inizio);
			set inizio=fine1+1;
			set fine1=Locate('#',ListaBevande,inizio); 
			set quantita= convert( substring(ListaBevande,inizio,fine1-inizio), unsigned int );
			set inizio=fine1+1;
            insert into `pizzeria`.`bevande`(Clienti,DataComanda,NomeProdotto,Stato,Quantita) values(cliente,Tempo,nome,'in preparazione',quantita);
        end while;
        set inizio=1;
        set fine2=locate('@',ListaPizze,inizio);
        while inizio<fine2 do
			set fine1=Locate('?',ListaPizze,inizio);
			set nome=substring(ListaPizze,inizio,fine1-inizio);
			set inizio=fine1+1;
            set fine1=Locate('#',ListaPizze,inizio); 
			set quantita= convert(substring(ListaPizze,inizio,fine1-inizio), unsigned int );
			set inizio=fine1+1;
            insert into `pizzeria`.`pizze` (Cliente,DataComanda,NomeP,Stato,Quantita) values(cliente,Tempo,nome,'in preparazione',quantita);
            set fine3=locate('*',ListaPizze,inizio);
            set idP=last_insert_id();
            while inizio<fine3 do
				set fine1=Locate('?',ListaPizze,inizio);
				set nomeAggiunta=substring(ListaPizze,inizio,fine1-inizio);
				set inizio=fine1+1;
				set fine1=Locate('#',ListaPizze,inizio); 
				set quantitaAggiunta= convert( substring(ListaPizze,inizio,fine1-inizio), unsigned int );
				set inizio=fine1+1; 
				insert into `pizzeria`.`add`(IDpizza,Aggiunta,porzione) values(IDp,nomeAggiunta,quantitaAggiunta);
			end while;
            set inizio=fine3+1;
        end while;
		commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ordiniDaPortare` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `ordiniDaPortare`(in n varchar(15),in cognome varchar(15))
BEGIN
	select Tavolo,Cliente,Data 
    from comande as c join clienti as p on c.Cliente=p.ID
		join tavoloeffettivo as t on t.Tavolo=p.FTavolo and t.TurnoData=p.Turno 
	where t.CameriereNome=n and 
    t.CameriereCognome=cognome and
    c.Completata="completa"
    order by Data,Cliente;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `OrdiniDaPrepararePizzaiolo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `OrdiniDaPrepararePizzaiolo`()
BEGIN
	select IDPizza,NomeP,Quantita,Aggiunta,porzione from ViewPizzaioloOrdini;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pizzaPreparata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `pizzaPreparata`(in id int)
BEGIN
	update pizze set Stato="pronto" where IDPizza=id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StampaScontrino` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StampaScontrino`(IN c INT,out CostoTotale INT)
BEGIN
	
    declare t int;
    declare d datetime;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK; -- rollback any changes made in the transaction
		RESIGNAL; -- raise again the sql exception to the caller
	END;
	set transaction isolation level serializable;
    start transaction;
		select IDPizza,NomeP,Quantita,prezzo,Aggiunta,porzione,Costo,CostoTotaleProdotto from Scontrini where Cliente=c;
		select sum(P.CostoTotaleProdotto) as costo
		from (select distinct(IDPizza),CostoTotaleProdotto from Scontrini where Cliente=c) as P into CostoTotale;
		update clienti set Spesa=CostoTotale where ID=c;
		select FTavolo from clienti where ID=c into t;
		select Turno from clienti where ID=c into d;
		update tavoloeffettivo  set Disponibilità=1 where Tavolo=t and TurnoData=d;
    commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TavoliAssegnatiCameriere` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `TavoliAssegnatiCameriere`(in n varchar(15),in c varchar(15))
BEGIN
	declare var DATETIME;
    
	select Tavolo 
    from tavoloeffettivo 
    where
		CameriereNome=n and 
		CameriereCognome=c and 
		current_timestamp() between TurnoData and addtime(TurnoData,"08:00:00");
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TavoliLiberi` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `TavoliLiberi`(IN posti INTEGER)
BEGIN
	SELECT `tavoloeffettivo`.Tavolo, `tavoloeffettivo`.TurnoData FROM `tavoli` JOIN `tavoloeffettivo` ON `tavoli`.N_Tavolo=`tavoloeffettivo`.Tavolo where `tavoli`.N_posti>=posti and timediff(current_timestamp(),`tavoloeffettivo`.TurnoData)<'08:00:00' and timediff(current_timestamp(),`tavoloeffettivo`.TurnoData) > '00:00:00' and Disponibilità=1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateComandeConsegnate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `UpdateComandeConsegnate`(in id INT,in d DATETIME)
BEGIN
	update comande set Completata="chiusa" where Cliente=id and Data=d;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateIngrdienti` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `UpdateIngrdienti`(in n varchar(15),in incr INT)
BEGIN
	update ingredienti set Quantita=Quantita+incr where Nome=n;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VerificaCameriere` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`kobero`@`localhost` PROCEDURE `VerificaCameriere`(in n varchar(15),in c varchar(15))
BEGIN
	declare i int;
    declare msg varchar(128);
	select count(Nome) from camerieri where Nome=n and Cognome=c into i;
    if i = 0 then
		set msg = "il Cameriere non esiste";
        signal sqlstate '45000' set message_text = msg;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `Scontrini`
--

/*!50001 DROP VIEW IF EXISTS `Scontrini`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`kobero`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Scontrini` AS select `p`.`Cliente` AS `Cliente`,`p`.`IDPizza` AS `IDPizza`,`p`.`NomeP` AS `NomeP`,`p`.`Quantita` AS `Quantita`,`pr`.`Costo` AS `prezzo`,`a`.`Aggiunta` AS `Aggiunta`,`a`.`porzione` AS `porzione`,`i`.`Costo` AS `Costo`,((`p`.`Quantita` * (select sum((`a1`.`porzione` * `i1`.`Costo`)) from ((`pizze` `p1` join `add` `a1` on((`a1`.`IDpizza` = `p1`.`IDPizza`))) join `ingredienti` `i1` on((`a1`.`Aggiunta` = `i1`.`Nome`))) where (`p`.`IDPizza` = `p1`.`IDPizza`))) + (`p`.`Quantita` * `pr`.`Costo`)) AS `CostoTotaleProdotto` from (((`pizze` `p` join `add` `a` on((`a`.`IDpizza` = `p`.`IDPizza`))) join `prodotti` `pr` on((`pr`.`Nome` = `p`.`NomeP`))) join `ingredienti` `i` on((`a`.`Aggiunta` = `i`.`Nome`))) union select `b`.`Clienti` AS `Clienti`,`b`.`IDBevande` AS `IDBevande`,`b`.`NomeProdotto` AS `NomeProdotto`,`b`.`Quantita` AS `Quantita`,`pr`.`Costo` AS `Costo`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,(`b`.`Quantita` * `pr`.`Costo`) AS `CostoTotatale` from (`bevande` `b` join `prodotti` `pr` on((`pr`.`Nome` = `b`.`NomeProdotto`))) union select `pizze`.`Cliente` AS `Cliente`,`pizze`.`IDPizza` AS `IDPizza`,`pizze`.`NomeP` AS `NomeP`,`pizze`.`Quantita` AS `Quantita`,`prodotti`.`Costo` AS `Costo`,NULL AS `NULL`,NULL AS `NULL`,NULL AS `NULL`,(`prodotti`.`Costo` * `pizze`.`Quantita`) AS `prodotti.Costo*pizze.Quantita` from (`pizze` join `prodotti` on((`pizze`.`NomeP` = `prodotti`.`Nome`))) where `pizze`.`IDPizza` in (select `add`.`IDpizza` from `add`) is false order by `Cliente`,`IDPizza` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ViewPizzaioloOrdini`
--

/*!50001 DROP VIEW IF EXISTS `ViewPizzaioloOrdini`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`kobero`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ViewPizzaioloOrdini` AS select `p`.`DataComanda` AS `DataOrdine`,`p`.`IDPizza` AS `IDPizza`,`p`.`NomeP` AS `NomeP`,`p`.`Stato` AS `Stato`,`p`.`Quantita` AS `Quantita`,`a`.`Aggiunta` AS `Aggiunta`,`a`.`porzione` AS `porzione` from (`pizze` `p` left join `add` `a` on((`a`.`IDpizza` = `p`.`IDPizza`))) where (`p`.`Stato` = 'in preparazione') order by `p`.`DataComanda`,`p`.`IDPizza` */;
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

-- Dump completed on 2022-02-08 10:41:31
