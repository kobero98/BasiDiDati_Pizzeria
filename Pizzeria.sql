-- MySQL Script generated by MySQL Workbench
-- Thu Dec 16 23:49:21 2021
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;


-- -----------------------------------------------------
-- Table `mydb`.`Tavoli`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Tavoli` (
  `N_Tavolo` INT NOT NULL,
  `N_posti` INT NOT NULL,
  PRIMARY KEY (`N_Tavolo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Camerieri`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Camerieri` (
  `Nome` VARCHAR(15) NOT NULL,
  `Cognome` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Nome`, `Cognome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Turni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Turni` (
  `Data` DATETIME NOT NULL,
  `Ora_fine` TIME NOT NULL,
  PRIMARY KEY (`Data`))
 ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lavora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Lavora` (
  `NomeCameriere` VARCHAR(15) NOT NULL,
  `CognomeCameriere` VARCHAR(15) NOT NULL,
  `DataTurno` DATETIME NOT NULL,
  PRIMARY KEY (`NomeCameriere`, `CognomeCameriere`, `DataTurno`),
  INDEX `Turno_idx` (`DataTurno` ASC) VISIBLE,
  CONSTRAINT `NomeCameriere`
    FOREIGN KEY (`NomeCameriere` , `CognomeCameriere`)
    REFERENCES `pizzeria`.`Camerieri` (`Nome` , `Cognome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Turno`
    FOREIGN KEY (`DataTurno`)
    REFERENCES `pizzeria`.`Turni` (`Data`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TavoloEffettivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`TavoloEffettivo` (
  `Tavolo` INT NOT NULL,
  `Disponibilità` TINYINT NOT NULL,
  `TurnoData` DATETIME NOT NULL,
  `CameriereNome` VARCHAR(15),
  `CameriereCognome` VARCHAR(15),
  PRIMARY KEY (`Tavolo`, `TurnoData`),
  INDEX `Turno_idx` (`TurnoData` ASC) VISIBLE,
  INDEX `Cameriere_idx` (`CameriereNome` ASC, `CameriereCognome` ASC) VISIBLE,
  CONSTRAINT `FKTavolo`
    FOREIGN KEY (`Tavolo`)
    REFERENCES `pizzeria`.`Tavoli` (`N_Tavolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FKTurno`
    FOREIGN KEY (`TurnoData`)
    REFERENCES `pizzeria`.`Turni` (`Data`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Cameriere`
    FOREIGN KEY (`CameriereNome` , `CameriereCognome`)
    REFERENCES `pizzeria`.`Camerieri` (`Nome` , `Cognome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Clienti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Clienti` (
  `ID` INT AUTO_INCREMENT NOT NULL,
  `Nome` VARCHAR(15) NOT NULL,
  `Cognome` VARCHAR(15) NOT NULL,
  `N_persone` INT NOT NULL,
  `FTavolo` INT,
  `Turno` DATETIME,
  CONSTRAINT `FKTavoli`
    FOREIGN KEY (`FTavolo`,`Turno`)
    REFERENCES `pizzeria`.`TavoliEffettivi` (`Tavolo`,`TurnoData`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Scontrini`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Scontrini` (
  `Cliente` INT NOT NULL,
  `ContoTOT` DOUBLE NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`Cliente`),
  CONSTRAINT `Cliente`
    FOREIGN KEY (`Cliente`)
    REFERENCES `pizzeria`.`Clienti` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb`.`Comande`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Comande` (
  `Cliente` INT NOT NULL,
  `Data` DATETIME(2) NOT NULL,
  `Completata` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Cliente`, `Data`),
  CONSTRAINT `Clienti`
    FOREIGN KEY (`Cliente`)
    REFERENCES `pizzeria`.`Clienti` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ingredienti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Ingredienti` (
  `Nome` VARCHAR(15) NOT NULL,
  `Quantita` INT NOT NULL DEFAULT 0,
  `isAggiunta` TINYINT NOT NULL DEFAULT 0,
  `Costo` FLOAT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Prodotti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Prodotti` (
  `Nome` VARCHAR(15) PRIMARY KEY NOT NULL,
  `Costo` FLOAT NOT NULL,
  `Descrizione` VARCHAR(50) NULL,
  `Tipo` INTEGER NOT NULL
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ricettacolo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Ricettacolo` (
  `NomeIngrediente` VARCHAR(15) NOT NULL,
  `NomeProdotto` VARCHAR(15) NOT NULL,
  `Quantita` INT NOT NULL,
  PRIMARY KEY (`NomeIngrediente`, `NomeProdotto`),
  INDEX `Prodotti_idx` (`NomeProdotto` ASC) VISIBLE,
  CONSTRAINT `Ingrediente`
    FOREIGN KEY (`NomeIngrediente`)
    REFERENCES `pizzeria`.`Ingredienti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Prodotti`
    FOREIGN KEY (`NomeProdotto`)
    REFERENCES `pizzeria`.`Prodotti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pizze`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Pizze` (
  `Cliente` INT NOT NULL,
  `DataComanda` DATETIME(2) NOT NULL,
  `NomeProdotto` VARCHAR(15) NOT NULL,
  `Stato` VARCHAR(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Cliente`, `DataComanda`, `NomeProdotto`),
  INDEX `Prodotti_idx` (`NomeProdotto` ASC) VISIBLE,
  CONSTRAINT `FKComanda`
    FOREIGN KEY (`Cliente` , `DataComanda`)
    REFERENCES `pizzeria`.`Comande` (`Cliente` , `Data`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FkProdotti`
    FOREIGN KEY (`NomeProdotto`)
    REFERENCES `pizzeria`.`Prodotti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bevande`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Bevande` (
  `Clienti` INT NOT NULL,
  `DataComanda` DATETIME(2) NOT NULL,
  `NomeProdotto` VARCHAR(15) NOT NULL,
  `Stato` VARCHAR(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` INT NULL DEFAULT 1,
  PRIMARY KEY (`Clienti`, `DataComanda`, `NomeProdotto`),
  INDEX `Prodotti_idx` (`NomeProdotto` ASC) VISIBLE,
  CONSTRAINT `FKComande1`
    FOREIGN KEY (`Clienti` , `DataComanda`)
    REFERENCES `pizzeria`.`Comande` (`Cliente` , `Data`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `FKProdotti1`
    FOREIGN KEY (`NomeProdotto`)
    REFERENCES `pizzeria`.`Prodotti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Add`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`Add` (
  `Clienti` INT NOT NULL,
  `Data` DATETIME(2) NOT NULL,
  `NomeP` VARCHAR(15) NOT NULL,
  `Aggiunta` VARCHAR(15) NOT NULL,
  `Quantita` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Clienti`, `Data`, `NomeP`, `Aggiunta`),
  INDEX `Aggiunta_idx` (`Aggiunta` ASC) VISIBLE,
  CONSTRAINT `fkAggiunta`
    FOREIGN KEY (`Aggiunta`)
    REFERENCES `pizzeria`.`Ingredienti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Pizze`
    FOREIGN KEY (`Clienti` , `Data` , `NomeP`)
    REFERENCES `pizzeria`.`Pizze` (`Cliente` , `DataComanda` , `NomeProdotto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
