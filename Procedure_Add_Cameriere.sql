delimiter !
CREATE PROCEDURE AddCamerieri (IN N Varchar(15),IN C varchar(15))
BEGIN
	INSERT INTO `pizzeria`.`Camerieri`(Nome,Cognome) value (N,C);	
END!
delimiter ;
