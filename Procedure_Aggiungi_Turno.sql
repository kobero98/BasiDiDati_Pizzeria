drop PROCEDURE IF EXISTS `AddTurno`;
delimiter !
CREATE PROCEDURE `AddTurno` (IN DataInizio DATETIME)
BEGIN
	INSERT into Turni(Data,Ora_fine) values (DataInizio,TIME(ADDTIME(DataInizio,"08:00:00")));
END!
delimiter ;
