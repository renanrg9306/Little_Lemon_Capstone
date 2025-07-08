USE mydb
/* ------------------------------------------------------- FUNCTION TO CALCULATE TOTAL PER ITEM------------------------------------------------------------------- */
DELIMITER //
CREATE FUNCTION CalculateTotalPerItem(IdMenuItem INT, Quantity INT)
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
	RETURN (
    SELECT MI.Price FROM menu_item AS MI
    WHERE MI.IdMenuItem= IdMenuItem) * Quantity;
END //
DELIMITER ;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */


/*-------------------------------------------------------- STORE PROCEDURE TO INSERT ORDERS -------------------------------------------------------------------- */
DELIMITER //
CREATE PROCEDURE InsertOrder(
	p_IdCustomer INT,
    p_IdMenuItem INT,
    p_Quantity INT)
    
BEGIN 
	DECLARE Total INT; 
    SET Total = (SELECT CalculateTotalPerItem(p_IdMenuItem, p_Quantity)); 

    INSERT INTO orders(IdCustomer,IdMenuItem,Quantity,Total)
    VALUES(p_IdCustomer,p_IdMenuItem,p_Quantity,Total);
END //
)
DELIMITER ;
CALL InsertOrder(1,2,3);
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/*------------------------------------------------------------- CREATE VIEW, THIS VIEW SHOWS THE ORDERS WITH QUANTITY > 2 ------------------------------------- */
CREATE VIEW OrderView AS
SELECT idOrder, Quantity, Total FROM orders WHERE Quantity >= 2;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/*--------------------------------------------------------- CREATE VIEW, THIS VIEW SHOWS THE ORDERS WHICH TOTAL IS >300 --------------------------------------- */
CREATE VIEW HigherOrderView AS
SELECT IdOrder, Quantity, Total FROM orders WHERE Total >300;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/* -------------------------------------------------------- CALLING VIEWS --------------------------------------------------------------------------------------*/
SELECT * FROM orderview;
SELECT * FROM HigherOrderView;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/* -------------------------------------------------------- QUERY TO PRINT ALL THE DETAILS RELATED TO THE ORDERS ------------------------------------------------*/
SELECT P.First_Name, P.Last_Name, O.IdOrder, O.Total, MI.Descrption FROM orders AS O
INNER JOIN customer AS C
ON O.IdCustomer = C.IdCustomer
INNER JOIN persona as P
ON C.IdPersona = P.IdPersona
INNER JOIN menu_item AS MI
ON MI.IdMenuItem = O.IdMenuItem
WHERE O.Total > 150
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/* ---------------------------------------------------------- STORE PROCEDURE THAT SHOW THE ORDER MAX QUANTITY -------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE GetMaxQuantity()
BEGIN
	SELECT MAX(Quantity) FROM orders;
END //
DELIMITER ;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/* ----------------------------------------------------------------- PREPARE STATEMENT--------------------------------------------------------------------------*/
PREPARE  GetOrderDetail FROM 'SELECT * FROM orders WHERE IdOrder = ?';
SET @IdOrder = 1;
EXECUTE GetOrderDetail USING @IdOrder;
DEALLOCATE PREPARE GetOrderDetail;
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/*--------------------------------------------------------------------- CANCEL ORDER STORE PROCEDURE -----------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE CancelOrder(
IN p_IdOrder INT
)
BEGIN
	DELETE  FROM orders WHERE IdOrder = p_IdOrder;
END//
DELIMITER ;
/*---------------------------------------------- FUNCTION TO CHECK TABLE AVAILABLE----------------------------------------------------------------------------*/
DELIMITER //
CREATE FUNCTION CheckingAvailableTable(Booking_Date DATE, Table_Number INT)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE Availability INT;
    SELECT COUNT(*) INTO Availability FROM booking WHERE Date = Booking_Date AND Table_Number = Table_Number;
    IF Availability > 0 THEN
		RETURN 0;
	ELSE 
		RETURN 1;
	END IF;
END //
DELIMITER ;
DROP FUNCTION CheckingAvailableTable;

/*-------------------------------------------------------------------------------------------------------------------------------------------------------------*/
DROP PROCEDURE AddValidBooking;
DELIMITER //
CREATE PROCEDURE AddValidBooking(
	IN p_Booking_Date DATE,
    IN p_Table_Number INT
)
BEGIN 
	DECLARE Available INT;
	SELECT CheckingAvailableTable(p_Booking_Date, p_Table_Number) INTO Available;
    
    START TRANSACTION;
	
	IF Available > 0 THEN
		ROLLBACK;
	ELSE
		INSERT INTO booking(IdStaff, IdCustomer, Date, Table_Number)
        VALUES(1,1, p_Booking_Date, p_Table_Number);
        COMMIT;
	END IF;
END //
DELIMITER ;
DROP PROCEDURE AddValidBooking;
CALL AddValidBooking('2022-10-10',1);