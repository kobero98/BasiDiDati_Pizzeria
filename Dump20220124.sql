CREATE DATABASE  IF NOT EXISTS `pizzeria` /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `pizzeria`;
-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: pizzeria
-- ------------------------------------------------------
-- Server version	8.0.22

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
-- Table structure for table `add`
--

DROP TABLE IF EXISTS `add`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `add` (
  `Clienti` int NOT NULL,
  `Data` datetime(2) NOT NULL,
  `NomeP` varchar(15) NOT NULL,
  `Aggiunta` varchar(15) NOT NULL,
  `Quantita` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`Clienti`,`Data`,`NomeP`,`Aggiunta`),
  KEY `Aggiunta_idx` (`Aggiunta`),
  CONSTRAINT `fkAggiunta` FOREIGN KEY (`Aggiunta`) REFERENCES `ingredienti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Pizze` FOREIGN KEY (`Clienti`, `Data`, `NomeP`) REFERENCES `pizze` (`Cliente`, `DataComanda`, `NomeProdotto`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `add`
--

LOCK TABLES `add` WRITE;
/*!40000 ALTER TABLE `add` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ControlloDegliIngredienti` BEFORE INSERT ON `add` FOR EACH ROW BEGIN
	declare S TINYINT;
	declare msg VARCHAR(128);
	SELECT Tipo into S from `Ingredienti` WHERE Nome=new.aggiunta;
	if S=0 then 
		set msg ='MyTriggerError: L Ingrediente non é una possibile aggiunta';
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ControlloAggiunte` BEFORE INSERT ON `add` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
    declare q int;
    declare i int default 1;
    select Quantita into q from pizze where NomeProdotto=new.NomeP and DataComanda=new.Data and Cliente=new.Clienti;
    
    select count(I.nome) into app
    from `pizzeria`.`ingredienti` as I 
    where new.Quantita*q > I.Quantita and I.nome=new.Aggiunta and isAggiunta=1;
	if app>0 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ',new.Aggiunta);
        signal sqlstate '45000' set message_text = msg;
    else
		update ingredienti as i
		set Quantita=Quantita-new.Quantita*q 
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
  `DataComanda` datetime(2) NOT NULL,
  `NomeProdotto` varchar(15) NOT NULL,
  `Stato` varchar(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` int DEFAULT '1',
  PRIMARY KEY (`Clienti`,`DataComanda`,`NomeProdotto`),
  KEY `Prodotti_idx` (`NomeProdotto`),
  CONSTRAINT `FKComande1` FOREIGN KEY (`Clienti`, `DataComanda`) REFERENCES `comande` (`Cliente`, `Data`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKProdotti1` FOREIGN KEY (`NomeProdotto`) REFERENCES `prodotti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bevande`
--

LOCK TABLES `bevande` WRITE;
/*!40000 ALTER TABLE `bevande` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ControlloBevanda` BEFORE INSERT ON `bevande` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
	Select `Prodotto`.tipo	into app from `Prodotto` where new.NomeProdotto=`Prodotto`.Nome;
    if app= 1 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ',new.NomeProdotto);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bevande` BEFORE INSERT ON `bevande` FOR EACH ROW BEGIN
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `camerieri`
--

LOCK TABLES `camerieri` WRITE;
/*!40000 ALTER TABLE `camerieri` DISABLE KEYS */;
INSERT INTO `camerieri` VALUES ('giuseppe','federico');
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
  PRIMARY KEY (`ID`),
  KEY `FKTavoli` (`FTavolo`,`Turno`),
  CONSTRAINT `FKTavoli` FOREIGN KEY (`FTavolo`, `Turno`) REFERENCES `tavolieffettivi` (`Tavolo`, `TurnoData`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clienti`
--

LOCK TABLES `clienti` WRITE;
/*!40000 ALTER TABLE `clienti` DISABLE KEYS */;
/*!40000 ALTER TABLE `clienti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comande`
--

DROP TABLE IF EXISTS `comande`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comande` (
  `Cliente` int NOT NULL,
  `Data` datetime(2) NOT NULL,
  `Completata` varchar(10) NOT NULL,
  PRIMARY KEY (`Cliente`,`Data`),
  CONSTRAINT `Clienti` FOREIGN KEY (`Cliente`) REFERENCES `clienti` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comande`
--

LOCK TABLES `comande` WRITE;
/*!40000 ALTER TABLE `comande` DISABLE KEYS */;
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
  `isAggiunta` tinyint NOT NULL DEFAULT '0',
  `Costo` float DEFAULT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredienti`
--

LOCK TABLES `ingredienti` WRITE;
/*!40000 ALTER TABLE `ingredienti` DISABLE KEYS */;
INSERT INTO `ingredienti` VALUES ('acqua',296,0,NULL),('basilico',16,1,0),('farina',280,0,NULL),('moretti',30,0,NULL),('mozzarella',146,1,1),('olio',50,0,NULL),('peperoni',70,1,1),('peroni',30,0,NULL),('sugo',196,0,NULL);
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
-- Table structure for table `lavora`
--

DROP TABLE IF EXISTS `lavora`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lavora` (
  `NomeCameriere` varchar(15) NOT NULL,
  `CognomeCameriere` varchar(15) NOT NULL,
  `DataTurno` datetime NOT NULL,
  PRIMARY KEY (`NomeCameriere`,`CognomeCameriere`,`DataTurno`),
  KEY `Turno_idx` (`DataTurno`),
  CONSTRAINT `NomeCameriere` FOREIGN KEY (`NomeCameriere`, `CognomeCameriere`) REFERENCES `camerieri` (`Nome`, `Cognome`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Turno` FOREIGN KEY (`DataTurno`) REFERENCES `turni` (`Data`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lavora`
--

LOCK TABLES `lavora` WRITE;
/*!40000 ALTER TABLE `lavora` DISABLE KEYS */;
/*!40000 ALTER TABLE `lavora` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pizze`
--

DROP TABLE IF EXISTS `pizze`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pizze` (
  `Cliente` int NOT NULL,
  `DataComanda` datetime(2) NOT NULL,
  `NomeProdotto` varchar(15) NOT NULL,
  `Stato` varchar(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`Cliente`,`DataComanda`,`NomeProdotto`),
  KEY `Prodotti_idx` (`NomeProdotto`),
  CONSTRAINT `FKComanda` FOREIGN KEY (`Cliente`, `DataComanda`) REFERENCES `comande` (`Cliente`, `Data`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FkProdotti` FOREIGN KEY (`NomeProdotto`) REFERENCES `prodotti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pizze`
--

LOCK TABLES `pizze` WRITE;
/*!40000 ALTER TABLE `pizze` DISABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ControlloPizza` BEFORE INSERT ON `pizze` FOR EACH ROW BEGIN
	declare msg VARCHAR(128);
	declare app tinyint;
	Select `Prodotto`.tipo	into app from `Prodotto` where new.NomeProdotto=`Prodotto`.Nome;
    if app= 0 then
		set msg = concat('MyTriggerError: Trying to insert a negative value in trigger_test: ', new.NomeProdotto);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `pizze` BEFORE INSERT ON `pizze` FOR EACH ROW BEGIN
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

--
-- Table structure for table `prodotti`
--

DROP TABLE IF EXISTS `prodotti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodotti` (
  `Nome` varchar(15) NOT NULL,
  `Costo` float NOT NULL,
  `Descrizione` varchar(50) DEFAULT NULL,
  `Tipo` int NOT NULL,
  PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prodotti`
--

LOCK TABLES `prodotti` WRITE;
/*!40000 ALTER TABLE `prodotti` DISABLE KEYS */;
INSERT INTO `prodotti` VALUES ('margherita',5,NULL,1);
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
  CONSTRAINT `Ingrediente` FOREIGN KEY (`NomeIngrediente`) REFERENCES `ingredienti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Prodotti` FOREIGN KEY (`NomeProdotto`) REFERENCES `prodotti` (`Nome`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ricettacolo`
--

LOCK TABLES `ricettacolo` WRITE;
/*!40000 ALTER TABLE `ricettacolo` DISABLE KEYS */;
INSERT INTO `ricettacolo` VALUES ('acqua','margherita',1),('basilico','margherita',1),('farina','margherita',5),('mozzarella','margherita',1),('sugo','margherita',1);
/*!40000 ALTER TABLE `ricettacolo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scontrini`
--

DROP TABLE IF EXISTS `scontrini`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scontrini` (
  `Cliente` int NOT NULL,
  `ContoTOT` double NOT NULL,
  `Data` date NOT NULL,
  PRIMARY KEY (`Cliente`),
  CONSTRAINT `Cliente` FOREIGN KEY (`Cliente`) REFERENCES `clienti` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scontrini`
--

LOCK TABLES `scontrini` WRITE;
/*!40000 ALTER TABLE `scontrini` DISABLE KEYS */;
/*!40000 ALTER TABLE `scontrini` ENABLE KEYS */;
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
  PRIMARY KEY (`N_Tavolo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tavoli`
--

LOCK TABLES `tavoli` WRITE;
/*!40000 ALTER TABLE `tavoli` DISABLE KEYS */;
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
  CONSTRAINT `Cameriere` FOREIGN KEY (`CameriereNome`, `CameriereCognome`) REFERENCES `camerieri` (`Nome`, `Cognome`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKTavolo` FOREIGN KEY (`Tavolo`) REFERENCES `tavoli` (`N_Tavolo`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FKTurno` FOREIGN KEY (`TurnoData`) REFERENCES `turni` (`Data`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tavoloeffettivo`
--

LOCK TABLES `tavoloeffettivo` WRITE;
/*!40000 ALTER TABLE `tavoloeffettivo` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `turni`
--

LOCK TABLES `turni` WRITE;
/*!40000 ALTER TABLE `turni` DISABLE KEYS */;
/*!40000 ALTER TABLE `turni` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'pizzeria'
--

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
	INSERT INTO `pizzeria`.`Camerieri`(Nome,Cognome) value (N,C);	
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddCliente`(IN nome VARCHAR(15),IN cognome VARCHAR(15),IN persone INTEGER, IN tavolo INTEGER,IN data DATETIME)
BEGIN
	INSERT INTO Clienti(Nome,Cognome,N_Perosne,FTavolo,Turno) values (nome,cognome,persone,tavolo,data);	
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `addIngredienti`(IN nome VARCHAR(15),IN quantita INT,IN Costo INT)
BEGIN
	if Costo=0 then 
		insert into Ingredienti(Nome,Quantita,isAggiunta) values (nome,quantita,0);
	else 
		insert into Ingredienti(Nome,Quantita,isAggiunta,Costo) values (nome,quantita,1,Costo);
	End If;
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
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
			insert into `pizzeria`.`Prodotti` (Nome,Costo,Tipo) values(nome,prezzo,tipo);
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
	INSERT into Turni(Data,Ora_fine) values (DataInizio,TIME(ADDTIME(DataInizio,"08:00:00")));
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
		Select max(N_Tavolo) from Tavoli into Numero;
		IF Numero is not null then
			Insert Tavoli (N_Tavolo,N_posti) values (Numero+1,N_posti);
		ELSE
		Insert Tavoli (N_Tavolo,N_posti) values (1,N_posti);
		END IF;
		COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AssegnaTurnoCameriere` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssegnaTurnoCameriere`(IN n VARCHAR(15),IN c VARCHAR(15),data DATETIME)
BEGIN
	INSERT INTO `pizzeria`.`Lavora` values(n,c,data);
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
	INSERT INTO TavoloEffettivo(Tavolo,TurnoData,Disponibilità) values (tavolo,data,1);
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `IncassiGiornalieri`(IN giorno DATE,OUT spesa DOUBLE)
BEGIN
	SELECT SUM(contoTOT) FROM `Scontrini` where DAY(giorno)=DAY(`Scontrini`.Data) ;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `IncassiMensili`(IN Mese int,OUT spesa DOUBLE)
BEGIN
    SELECT SUM(`Clienti`.SpesaToT) into spesa FROM `Clienti` where MESE=MONTH(`Clienti`.Turno);
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
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Ordine`(in cliente int,in ListaPizze varchar(2048),in ListaBevande varchar(2048))
BEGIN
declare Tempo DATETIME default current_timestamp();
declare inizio int default 1;
declare fine1 int default 1;
declare fine2 int default 1;		
declare nome varchar(15);
declare nomeAggiunta varchar(15);
declare quantita varchar(15);
declare quantitaAggiunta varchar(15);
DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		ROLLBACK; -- rollback any changes made in the transaction
		RESIGNAL; -- raise again the sql exception to the caller
	END;
set transaction isolation level repeatable read;
start transaction;
		insert `pizzeria`.`comande` values (cliente,Tempo,'no');
        set fine2=locate(ListaBevande,'@');
        while inizio<fine2 do
			set fine1=Locate('?',ListaBevande,inizio);
			set nome=substring(ListaBevande,inizio,fin1-inizio);
			set inizio=fine1+1;
			set fine1=Locate('#',ListaBevande,inizio); 
			set quantita= convert( substring(ListaBevande,inizio,fine1-inizio), unsigned int );
			set inizio=fine1+1;
            insert `pizzeria`.`bevande` values(cliente,Tempo,nome,'in preparazione',quantita);
        end while;
        
        set fine2=locate(ListaPizze,'@');
        while inizio<fine2 do
			set fine1=Locate('?',ListaPizze,inizio);
			set nome=substring(ListaPizze,inizio,fin1-inizio);
			set inizio=fine1+1;
            set fine1=Locate('#',ListaPizze,inizio); 
			set quantita= convert( substring(ListaPizze,inizio,fine1-inizio), unsigned int );
			set inizio=fine1+1;
            insert `pizzeria`.`pizze` values(cliente,Tempo,nome,'in preparazione',quantita);
            set fine1=Locate('?',ListaPizze,inizio);
			set nomeAggiunta=substring(ListaPizze,inizio,fin1-inizio);
			set inizio=fine1+1;
            set fine1=Locate('#',ListaPizze,inizio); 
			set quantitaAggiunta= convert( substring(ListaPizze,inizio,fine1-inizio), unsigned int );
            set inizio=fine1+1; 
            insert `pizzeria`.`add` values(cliente,Tempo,nome,nomeAggiunta,quantitaAggiunta);
        end while;
		commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `PizzeriaOrdini` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `PizzeriaOrdini`(in tipo int)
BEGIN
 if tipo=0 then
		SELECT * from `pizzeria`.`bevande` as B 
        join `pizzeria`.`prodotti` as P on B.NomeProdotto=P.Nome 
        where B.stato='in preparazione';
    else 
		select * 
        from `pizzeria`.`pizze` as p join `pizzeria`.`prodotti` as pr on p.NomeProdotto=pr.Nome 
			join `pizzeria`.`add` as a on p.Cliente=a.Clienti	and p.DataComanda=a.Data and p.NomeProdotto=a.NomeP 
		where p.Stato='in preparazione';
    end if;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `StampaScontrino`(IN cliente INT,out Totale DOUBLE)
BEGIN
	declare spesaBevande DOUBLE default 0;
    declare spesaPizze double default 0;
    Select sum(Prodotto.Costo) from Clienti join Bevande on Clienti.ID=Bevande.Cliente join Prodotto on Bevande.NomeProdotto=Prodotto.Nome into spesaBevande;
	Select sum(Prodotto.Costo) from Clienti join Pizze on Clienti.ID=Bevande.Cliente join Prodotto on Bevande.NomeProdotto=Prodotto.Nome into spesaBevande;
	set Totale=spesaBevande+spesaPizze;
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
	SELECT `TavoloEffettivo`.Tavolo, `TavoloEffettivo`.TurnoData FROM `Tavoli` JOIN `TavoloEffettivo` ON `Tavoli`.N_Tavolo=`TavoloEffettivo`.Tavolo where `Tavoli`.N_posti=posti;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-01-24 23:51:28
