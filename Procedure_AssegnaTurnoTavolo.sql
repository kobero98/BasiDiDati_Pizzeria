DROP PROCEDURE IF EXISTS `AssegnaTurnoTavolo`;
delimiter !
CREATE PROCEDURE `AssegnaTurnoTavolo`(IN tavolo INTEGER, IN data DATETIME )
BEGIN
	INSERT INTO TavoloEffettivo(Tavolo,TurnoData,Disponibilità) values (tavolo,data,1);
END!
delimiter;
