DROP PROCEDURE IF EXISTS `TavoliLiberi`
delimiter !
CREATE PROCEDURE `TavoliLiberi` (IN posti INTEGER)
BEGIN
	SELECT `TavoloEffettivo`.Tavolo FROM `Tavoli` JOIN `TavoloEffettivo` ON `Tavoli`.N_Tavolo=`TavoloEffettivo`.Tavolo where `Tavoli`.N_posti=posti;
END!
delimiter ;
