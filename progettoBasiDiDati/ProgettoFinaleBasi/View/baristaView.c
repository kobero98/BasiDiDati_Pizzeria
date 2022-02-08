#include "../util/defines.h"
#include "baristaView.h"
#include <stdio.h>

void ViewOrdini(prodotto * testa){
	system("clear");
    printf("--------------Ordini Barista------------\n");
    for (prodotto * i = testa; i!=NULL; i=i->next)
    {
        printf("%d] %s %d\n",i->prezzo,i->nome,i->tipo);
    }
    return;
}
int ViewBevandePreparata(){
	int i;
	system("clear");
	printf("inserire il numero della Bevanda pronta per la consegna: ");
	char app[4];
	do{
		getInput(4,app,false);
		i=atoi(app);
	}while(i<=0);
	return i; 
}
int ViewBarista(){
    system("clear");
	printf("###############################################\n");
	printf("##                                           ##\n");
    printf("##                  Barista                  ##\n");
    printf("##                                           ##\n");
    printf("###############################################\n");
	printf("1]Visualizza ordini da preparare\n");
	printf("2]Ordine Pronto\n");
	printf("3]Cambia Utente\n");
    printf("4]Chiudi Applicazione\n");
	int c;
	char app[3];
	do{
		getInput(3,app,false);
		c=atoi(app);
	}while(c<1 ||c>4);
    return c;
}