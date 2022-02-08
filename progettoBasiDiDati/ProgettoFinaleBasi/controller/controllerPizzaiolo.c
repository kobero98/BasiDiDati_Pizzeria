#include "../util/defines.h"
#include "../model/db.h"
#include "controllerPizzaiolo.h"
#include "../View/pizzaioloView.h"
#include <stdio.h>

void InPreparazione(){
    prodotto * testa=NULL;
    dbOrdiniDaCucinare(&testa);
    if(testa==NULL)
    {
        printf("Nessuna Pizza in Programma\n");
        printf("premere invio per continuare...\n");
        getchar();
        return;
    }
    stampaListaPizze(testa);
    freeProdotti(testa);
    printf("premere invio per continuare...\n");
    getchar();
    return;
}
void OrdinePronto(){
    int i=ViewPizzaFinita();
    dbPizzaFinita(i);
    printf("premere invio per continuare...\n");
    getchar();
    return ;
}
void run_pizzaiolo(){
    do{
        int option=ViewPizzaiolo();
        switch (option)
        {
            case 1:
                InPreparazione();
                break;
            case 2:
                OrdinePronto();
                break;
             case 3:
                return;
                break;
            case 4:
                exit(1);
                break;
            default:
                fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
                abort();
                break;
        }
    }while(1);
}
