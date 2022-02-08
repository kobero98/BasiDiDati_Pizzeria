#pragma once
#include "../util/defines.h"
extern void freeIngredienti(ingrediente * lista);
extern void freeProdotti(prodotto * testa);

extern int dbClienteTavolo(int t);
extern int* dbViewTavoli(cameriere c,int * d);
extern void dbAddCliente(cliente n);
extern void dbAssegnaTavoloTurno(cameriere c,turno t, int tavolo);
extern void dbAssegnaTavoli(int i,turno scelto);
extern void dbAddElementoMenu(prodotto p);
extern void dbUpdateIngredienti(ingrediente i);
extern void dbAddIngrediente(ingrediente i);
extern void dbListTurni(turno **ListaTurni);
extern void dbListCamerieri(cameriere ** c);
extern int dbCreaTurno(int anno,int mese);
extern ruolo dblogin(credenziali cred);
extern void dbAddCameriere(cameriere c);
extern int dbAddTavolo(int n);
extern void dbListaTavoli(Tavolo ** Testa,int n);
extern void dbIngredienti(ingrediente ** Testa);
extern void dbAggiunte(ingrediente ** Testa);
extern void dbListaMenu(prodotto ** Testa);
extern void dbAddNewOrdine(int c,char * pizze,char * bevande);
extern void dbOrdiniDaCucinare(prodotto ** Testa);
extern void dbPizzaFinita(int i);
extern void dbBevandeDaCucinare(prodotto ** Testa);
extern void dbBevandaPronta(int i);
extern void dbOrdiniDaConsegnare(ordini ** list,cameriere c);
extern void dbUpdateComanda(ordini p);
extern void dbStampaScontrino(prodotto **Lista,int *SpesaToT,int c);
extern int dbIncassoGiorno(int i);
extern int dbIncassoMese(int i);
extern int dbVerificaCameriere(cameriere c);
