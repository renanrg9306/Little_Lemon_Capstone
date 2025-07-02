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
-- Table `mydb`.`Persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Persona` (
  `IdPersona` INT NOT NULL AUTO_INCREMENT,
  `First_Name` VARCHAR(45) NOT NULL,
  `Last_Name` VARCHAR(45) NOT NULL,
  `Phone_Number` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`IdPersona`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Staff` (
  `IdStaff` INT NOT NULL AUTO_INCREMENT,
  `IdPersona` INT NOT NULL,
  `Salary` DOUBLE(6,2) NOT NULL,
  PRIMARY KEY (`IdStaff`),
  CONSTRAINT `fk_Staff_Persona1`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `mydb`.`Persona` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Customer` (
  `IdCustomer` INT NOT NULL AUTO_INCREMENT,
  `IdPersona` INT NOT NULL,
  PRIMARY KEY (`IdCustomer`),
  CONSTRAINT `fk_Customer_Persona1`
    FOREIGN KEY (`IdPersona`)
    REFERENCES `mydb`.`Persona` (`IdPersona`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Booking` (
  `IdBooking` INT NOT NULL AUTO_INCREMENT,
  `IdStaff` INT NOT NULL,
  `IdCustomer` INT NOT NULL,
  `Date` DATE NOT NULL,
  `Table_Number` INT NOT NULL,
  PRIMARY KEY (`IdBooking`),
  CONSTRAINT `fk_Booking_Staff1`
    FOREIGN KEY (`IdStaff`)
    REFERENCES `mydb`.`Staff` (`IdStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Booking_Customer1`
    FOREIGN KEY (`IdCustomer`)
    REFERENCES `mydb`.`Customer` (`IdCustomer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Category` (
  `IdCategory` INT NOT NULL AUTO_INCREMENT,
  `Category` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`IdCategory`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Menu_Item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Menu_Item` (
  `IdMenuItem` INT NOT NULL AUTO_INCREMENT,
  `IdCategory` INT NOT NULL,
  `Descrption` VARCHAR(100) NOT NULL,
  `Price` DOUBLE(6,2) NOT NULL,
  PRIMARY KEY (`IdMenuItem`),
  CONSTRAINT `fk_Menu_Category1`
    FOREIGN KEY (`IdCategory`)
    REFERENCES `mydb`.`Category` (`IdCategory`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Orders` (
  `IdOrder` INT NOT NULL AUTO_INCREMENT,
  `IdCustomer` INT NOT NULL,
  `IdMenuItem` INT NOT NULL,
  `Quantity` INT NOT NULL,
  `Total` DOUBLE(6,2) NOT NULL,
  PRIMARY KEY (`IdOrder`),
  CONSTRAINT `fk_Customer_has_Menu_Item_Customer1`
    FOREIGN KEY (`IdCustomer`)
    REFERENCES `mydb`.`Customer` (`IdCustomer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Customer_has_Menu_Item_Menu_Item1`
    FOREIGN KEY (`IdMenuItem`)
    REFERENCES `mydb`.`Menu_Item` (`IdMenuItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Address` (
  `IdAddress` INT NOT NULL AUTO_INCREMENT,
  `Address` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`IdAddress`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Delivery` (
  `IdDelivery` INT NOT NULL AUTO_INCREMENT,
  `IdOrder` INT NOT NULL,
  `IdAddress` INT NOT NULL,
  `Delivery_Date` VARCHAR(200) NOT NULL,
  `Status` ENUM('Pending', 'Out of Delivery', 'Delivered') NOT NULL,
  PRIMARY KEY (`IdDelivery`),
  CONSTRAINT `fk_Orders_has_Address_Orders1`
    FOREIGN KEY (`IdOrder`)
    REFERENCES `mydb`.`Orders` (`IdOrder`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_has_Address_Address1`
    FOREIGN KEY (`IdAddress`)
    REFERENCES `mydb`.`Address` (`IdAddress`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
