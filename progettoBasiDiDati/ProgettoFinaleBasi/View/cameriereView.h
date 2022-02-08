#pragma once
#include "../util/defines.h"

extern int ViewOrdiniDaConsegnare(ordini * list,int z);
extern int  ViewSelezionareTavolo();
extern void ViewTavoliAssegnati(int * a,int d);
extern int ViewCameriere();
extern cameriere* viewDatiCameriere();
extern char * OrdineCameriereBevande(prodotto * lista);
extern char* OrdineCamerierePizze(ingrediente * aggiunte,prodotto * lista);
