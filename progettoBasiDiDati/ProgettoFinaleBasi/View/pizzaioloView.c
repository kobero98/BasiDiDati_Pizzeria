#include "../util/defines.h"
#include "pizzaioloView.h"
#include <stdio.h>

void stampaListaPizze(prodotto * testa){
	system("clear");
	printf("---------------Ordinazioni----------------\n");
	prodotto * p=NULL;
	for(p=testa;p!=NULL;p=p->next)
	{
		printf("%d] %s %d\n",p->prezzo,p->nome,p->tipo);
		if(p->listaIngredienti!=NULL)
		{	
			ingrediente * i=p->listaIngredienti;
			for(i=p->listaIngredienti;i!=NULL;i=i->next)
			{
				printf("\t%s %d\n",i->nome,i->quantita);
			}
		}

	}
}
int ViewPizzaFinita(){
	int i;
	system("clear");
	printf("inserire il numero della Pizza pronta per la consegna: ");
	char app[4];
	do{
		getInput(4,app,false);
		i=atoi(app);
	}while(i<=0);
	return i; 
}
int ViewPizzaiolo(){
    system("clear");
	printf("###############################################\n");
	printf("##                                           ##\n");
    printf("##                 Pizzaiolo                 ##\n");
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
