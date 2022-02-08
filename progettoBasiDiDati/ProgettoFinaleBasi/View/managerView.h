#pragma once
#include "../util/defines.h"
extern int ViewTavoloCliente();
extern int* ViewCreareTurni();
extern int viewTurnoTavoli();
extern prodotto viewAddNuovoElemento();
extern void viewUpdateIngrediente(ingrediente **listaIngredienti);
extern ingrediente viewAddIngrediente(void);
extern int viewIngredienti(void);
extern turno *viewTurni(turno* T);
extern cameriere viewCameriere(cameriere* T);
extern int ViewManager(void);
extern void viewADDCliente(cliente * new);
extern Tavolo ViewtavoliLiberi(Tavolo* Testa);
extern int ViewTavolo();
extern void ViewAddCameriere(cameriere * c);
extern void ViewStatoIngredienti(ingrediente *lista);
extern void ViewScontrino(prodotto * Lista,int spesa);
extern int ViewGiorno();
extern int ViewMese();
