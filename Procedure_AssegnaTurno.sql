drop PROCEDURE IF EXISTS `AssegnaTurnoCameriere`;
delimiter !
CREATE PROCEDURE `AssegnaTurnoCameriere`(IN n VARCHAR(15),IN c VARCHAR(15),data DATETIME)
BEGIN
	INSERT INTO `pizzeria`.`Lavora` values(n,c,data);
END!
delimiter ;
