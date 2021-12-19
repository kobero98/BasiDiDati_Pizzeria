DROP PROCEDURE IF EXISTS `AddCliente`
delimiter !
CREATE PROCEDURE `AddCliente` (IN nome VARCHAR(15),IN cognome VARCHAR(15),IN persone INTEGER, IN tavolo INTEGER,IN data DATETIME)
BEGIN
	INSERT INTO Clienti(Nome,Cognome,N_Perosne,FTavolo,Turno) values (nome,cognome,persone,tavolo,data);	
END!
delimiter ;
