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
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Clienti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Clienti` (
  `ID` INT NOT NULL,
  `Nome` VARCHAR(15) NOT NULL,
  `Cognome` VARCHAR(15) NOT NULL,
  `N_persone` INT NOT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Scontrini`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Scontrini` (
  `Cliente` INT NOT NULL,
  `ContoTOT` DOUBLE NOT NULL,
  `Data` DATE NOT NULL,
  PRIMARY KEY (`Cliente`),
  CONSTRAINT `Cliente`
    FOREIGN KEY (`Cliente`)
    REFERENCES `mydb`.`Clienti` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Tavoli`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Tavoli` (
  `N_Tavolo` INT NOT NULL,
  `N_posti` INT NOT NULL,
  PRIMARY KEY (`N_Tavolo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Camerieri`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Camerieri` (
  `Nome` VARCHAR(15) NOT NULL,
  `Cognome` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Nome`, `Cognome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Turni`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Turni` (
  `Data` DATE NOT NULL,
  `Ora_inizio` TIME NOT NULL,
  `Ora_fine` TIME NOT NULL,
  PRIMARY KEY (`Data`, `Ora_inizio`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lavora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Lavora` (
  `NomeCameriere` VARCHAR(15) NOT NULL,
  `CognomeCameriere` VARCHAR(15) NOT NULL,
  `DataTurno` DATE NOT NULL,
  `ORATurno` TIME NOT NULL,
  PRIMARY KEY (`NomeCameriere`, `CognomeCameriere`, `DataTurno`, `ORATurno`),
  INDEX `Turno_idx` (`DataTurno` ASC, `ORATurno` ASC) VISIBLE,
  CONSTRAINT `NomeCameriere`
    FOREIGN KEY (`NomeCameriere` , `CognomeCameriere`)
    REFERENCES `mydb`.`Camerieri` (`Nome` , `Cognome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Turno`
    FOREIGN KEY (`DataTurno` , `ORATurno`)
    REFERENCES `mydb`.`Turni` (`Data` , `Ora_inizio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`TavoloEffettivo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`TavoloEffettivo` (
  `Tavolo` INT NOT NULL,
  `Disponibilità` TINYINT NOT NULL,
  `TurnoData` DATE NOT NULL,
  `TurnoOra` TIME NOT NULL,
  `Cliente` INT NULL,
  `CameriereNome` VARCHAR(15) NOT NULL,
  `CameriereCognome` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`Tavolo`, `TurnoOra`, `TurnoData`),
  INDEX `Turno_idx` (`TurnoData` ASC, `TurnoOra` ASC) VISIBLE,
  INDEX `Cameriere_idx` (`CameriereNome` ASC, `CameriereCognome` ASC) VISIBLE,
  INDEX `Cliente_idx` (`Cliente` ASC) VISIBLE,
  CONSTRAINT `Tavolo`
    FOREIGN KEY (`Tavolo`)
    REFERENCES `mydb`.`Tavoli` (`N_Tavolo`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Turno`
    FOREIGN KEY (`TurnoData` , `TurnoOra`)
    REFERENCES `mydb`.`Turni` (`Data` , `Ora_inizio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Cameriere`
    FOREIGN KEY (`CameriereNome` , `CameriereCognome`)
    REFERENCES `mydb`.`Camerieri` (`Nome` , `Cognome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Cliente`
    FOREIGN KEY (`Cliente`)
    REFERENCES `mydb`.`Clienti` (`ID`)
    ON DELETE SET NULL
    ON UPDATE SET NULL)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Comande`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Comande` (
  `Cliente` INT NOT NULL,
  `Data` DATETIME(2) NOT NULL,
  `Completata` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`Cliente`, `Data`),
  CONSTRAINT `Clienti`
    FOREIGN KEY (`Cliente`)
    REFERENCES `mydb`.`Clienti` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ingredienti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ingredienti` (
  `Nome` VARCHAR(15) NOT NULL,
  `Quantita` INT NOT NULL DEFAULT 0,
  `isAggiunta` TINYINT NOT NULL DEFAULT 0,
  `Costo` FLOAT NULL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Prodotti`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Prodotti` (
  `Nome` VARCHAR(15) NOT NULL,
  `Costo` FLOAT NOT NULL,
  `Descrizione` VARCHAR(50) NULL,
  `Tipo` TINYINT GENERATED ALWAYS AS () VIRTUAL,
  PRIMARY KEY (`Nome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Ricettacolo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Ricettacolo` (
  `NomeIngrediente` VARCHAR(15) NOT NULL,
  `NomeProdotto` VARCHAR(15) NOT NULL,
  `Quantita` INT NOT NULL,
  PRIMARY KEY (`NomeIngrediente`, `NomeProdotto`),
  INDEX `Prodotti_idx` (`NomeProdotto` ASC) VISIBLE,
  CONSTRAINT `Ingrediente`
    FOREIGN KEY (`NomeIngrediente`)
    REFERENCES `mydb`.`Ingredienti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Prodotti`
    FOREIGN KEY (`NomeProdotto`)
    REFERENCES `mydb`.`Prodotti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Pizze`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pizze` (
  `Cliente` INT NOT NULL,
  `DataComanda` DATETIME(2) NOT NULL,
  `NomeProdotto` VARCHAR(15) NOT NULL,
  `Stato` VARCHAR(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Cliente`, `DataComanda`, `NomeProdotto`),
  INDEX `Prodotti_idx` (`NomeProdotto` ASC) VISIBLE,
  CONSTRAINT `Comanda`
    FOREIGN KEY (`Cliente` , `DataComanda`)
    REFERENCES `mydb`.`Comande` (`Cliente` , `Data`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Prodotti`
    FOREIGN KEY (`NomeProdotto`)
    REFERENCES `mydb`.`Prodotti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bevande`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bevande` (
  `Clienti` INT NOT NULL,
  `DataComanda` DATETIME(2) NOT NULL,
  `NomeProdotto` VARCHAR(15) NOT NULL,
  `Stato` VARCHAR(45) NOT NULL DEFAULT 'in preparazione',
  `Quantita` INT NULL DEFAULT 1,
  PRIMARY KEY (`Clienti`, `DataComanda`, `NomeProdotto`),
  INDEX `Prodotti_idx` (`NomeProdotto` ASC) VISIBLE,
  CONSTRAINT `Comande`
    FOREIGN KEY (`Clienti` , `DataComanda`)
    REFERENCES `mydb`.`Comande` (`Cliente` , `Data`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Prodotti`
    FOREIGN KEY (`NomeProdotto`)
    REFERENCES `mydb`.`Prodotti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Add`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Add` (
  `Clienti` INT NOT NULL,
  `Data` DATETIME(2) NOT NULL,
  `NomeP` VARCHAR(15) NOT NULL,
  `Aggiunta` VARCHAR(15) NOT NULL,
  `Quantita` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`Clienti`, `Data`, `NomeP`, `Aggiunta`),
  INDEX `Aggiunta_idx` (`Aggiunta` ASC) VISIBLE,
  CONSTRAINT `Aggiunta`
    FOREIGN KEY (`Aggiunta`)
    REFERENCES `mydb`.`Ingredienti` (`Nome`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `Pizze`
    FOREIGN KEY (`Clienti` , `Data` , `NomeP`)
    REFERENCES `mydb`.`Pizze` (`Cliente` , `DataComanda` , `NomeProdotto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;