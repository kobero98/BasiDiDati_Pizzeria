#include "../util/defines.h"
#include "../model/db.h"
#include "../View/baristaView.h"
#include "controllerBarista.h"
#include <stdio.h>

void bevandeDaPreparare(){

    prodotto * Testa=NULL;
    dbBevandeDaCucinare(&Testa);
    if(Testa==NULL){
        printf("Nessuna Bevanda da Preparare\n");
        printf("premere invio per continuare...\n");
        getchar();
        return;
    }
    ViewOrdini(Testa);
    freeProdotti(Testa);
    printf("premere invio per continuare...\n");
    getchar();
    return;
}
void OrdineProntoBevande(){
    int i=ViewBevandePreparata();
    dbBevandaPronta(i);
    printf("premere invio per continuare...\n");
    getchar();
    return;
}
void run_barista(){
    do{
        int i=ViewBarista();
        switch (i)
        {
            case 1:
                bevandeDaPreparare();
                break;
            case 2:
                OrdineProntoBevande();
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