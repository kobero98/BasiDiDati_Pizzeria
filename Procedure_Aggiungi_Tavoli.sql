drop PROCEDURE if exists `AggiungiTavolo`;
delimiter !
CREATE PROCEDURE `AggiungiTavolo`  (IN N_Posti INTEGER)
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
END!
delimiter ;

