#include <stdio.h>
#include "managerView.h"
#include "../util/defines.h"

int ViewTavoloCliente(){
    int i;
    char a[4];
    system("clear");
    printf("Inserire Tavolo: ");
    do{
        getInput(4,a,false);
        i=atoi(a);
    }while(i<1);
    return  i;
}
int * ViewCreareTurni(){
	int *a=malloc(sizeof(int)*2);
	system("clear");
	if(yesOrNo("Si desidera creare i turni di un mese per l'anno corrente?",'y','n',true,false)){
		a[0]=0;
	}else{
		printf("Inserire Anno");
		do{
			char app[5];
			getInput(5,app,false);
			a[0]=atoi(app);
		}while(a[0]<2000 ||a[0]>2099);
	}
	printf("Inserire mese di cui si vogliono creare i turni: ");
		do{
			char app[5];
			getInput(5,app,false);
			a[1]=atoi(app);
		}while(a[1]<1 ||a[1]>12);
	return a;
}
turno *viewTurni(turno* T){
	int conto=0;
	turno * p;
	if(T==NULL){
		printf("Error\n");
		return NULL;
	}
	system("clear");
	printf("scegli il turno\n");
	for (p = T; p!=NULL; p=p->next)
	{
		conto++;
	//	ts.year, ts.month, ts.day,(p->oraFine).hour, (p->oraFine).minute, (p->oraFine).second
		printf("%d]%04d-%02d-%02d %02d:%02d:%02d ----%02d:%02d:%02d \n",conto,(p->tempo).year,(p->tempo).month,(p->tempo).day,(p->tempo).hour, (p->tempo).minute, (p->tempo).second,(p->oraFine).hour, (p->oraFine).minute, (p->oraFine).second);
	
	}
	char app[3];
	int c;
	do{
		getInput(3,app,false);
		c=atoi(app);
	}while(c<1 ||c>conto);
	p=T;
	for (conto = 1; conto<c; conto=conto+1)
	{p=p->next;}
	return p;
}
cameriere viewCameriere(cameriere * T){
	int conto=0;
	cameriere * p=NULL;
	if(T==NULL){
		printf("Error\n");
		return *p;
	}
	system("clear");
	printf("scegli il cameriere\n");
	for (p = T; p!=NULL; p=p->next)
	{
		conto++;
		printf("%d] %s %s\n",conto,p->nome,p->cognome);
	}
	char app[3];
	int c;
	do{
		getInput(3,app,false);
		c=atoi(app);
	}while(c<1 ||c>conto);
	p=T;
	for (conto = 1; conto<c; conto=conto+1)
	{
		p=p->next;	
	}
	return *p;
}
int ViewManager(void){
	system("clear");
	printf("###############################################\n");
	printf("##                                           ##\n");
    printf("##                   MANAGER                 ##\n");
    printf("##                                           ##\n");
    printf("###############################################\n");
	printf("1]Registrare nuovo cliente\n");
	printf("2]Stampare scontrontrino di un cliente\n");
	printf("3]Stampare l'incasso di un giorno\n");
	printf("4]Stampare l'incasso mensile\n");
	printf("5]Aggiungere lista degli Ingredienti\n");
	printf("6]Assumere nuovo Cameriere\n");
	printf("7]Aggiungere nuovo elemento del menu\n"); 
	printf("8]Vedere Stato Ingredienti in dispensa\n");
	printf("9]Aggiungere Nuovo Tavolo\n");
	printf("10]Assegna cameriere Tavoli\n");
	printf("11]Creare Turni per il mese corrente\n");
	printf("12]Assegnare Turno Al tavolo\n");
	printf("13]Cambiare Utente\n");
	printf("14]Chiudere programma\n");
	int c;
	char app[3];
	do{
		getInput(3,app,false);
		c=atoi(app);
	}while(c<1 ||c>14);

	return c;
}
int ViewTavolo(){
	int c;
	system("clear");
	printf("dimensione del nuovo tavolo: ");
	do{
		char app[3];
		getInput(2,app,false);
		c=atoi(app);
	}while(c<1);
	return c;
}
int viewTurnoTavoli(){
	system("clear");
	char app[4];
	int i=0;
	printf("quale Tavolo si vuole usare? ");
	do{	
		getInput(4,app,false);
		i=atoi(app);
	}while (i<=0);
	return i;

}
void ViewAddCameriere(cameriere *c)
{
	system("clear");
	printf("Nome: ");
    getInput(16, c->nome, false);
    printf("Cognome: ");
    getInput(16, c->cognome, false);
	return;
}
int viewIngredienti(){
	system("clear");
	printf("Cosa desideri fare?\n");
	printf("1]Inserirre nuovo Elemento\n");
	printf("2]Aumentare la quantita di elementi già presenti\n");
	int c;
	char app[3];
	do{
		getInput(3,app,false);
		c=atoi(app);
	}while(c<1 ||c>2);

	return c;
}
ingrediente viewAddIngrediente(){
	system("clear");
	ingrediente i;
	char app[4];
	printf("Inserire Nome nuovo Ingrediente: ");
	getInput(16,i.nome,false);
	printf("Inserire Quantita nuovo Ingrediente: ");
	do{
		getInput(4,app,false);
		i.quantita=atoi(app);
	}while (i.quantita<0);
	if(!yesOrNo("é una possibile Aggiunta delle pizze?",'y','n',true,false)){
		i.costo=0;
	}else{
		printf("Inserire Costo nuovo Ingrediente: ");
		do{
			getInput(4,app,false);
			i.costo=atoi(app);
		}while (i.costo<0);
	}
	return i;
}
void viewUpdateIngrediente(ingrediente **listaIngredienti)
{
	do
	{
		system("clear");
		ingrediente *app=malloc(sizeof(ingrediente));
		app->next=NULL;
		if(*listaIngredienti==NULL)	*listaIngredienti=app;
		else{
			ingrediente *app2=*listaIngredienti;
			while(app2->next!=NULL) app2=app2->next;
			app2->next=app;
		}
		printf("Inserire Nome Ingrediente: ");
		getInput(16,app->nome,false);
		printf("Inserire Quantita da aggiungere Ingrediente: ");
			do{
				char n[4];
				getInput(4,n,false);
				app->quantita=atoi(n);
			}while (app->quantita<0);	
			
	}while(yesOrNo("si desidera Aggiungere altri ingredienti da aggiornare?",'y','n',true,false));
	return ;
}
prodotto viewAddNuovoElemento(){

	prodotto prod;
	system("clear");
	printf("Nome nuovo prodotto: ");
    getInput(16, prod.nome, false);
    printf("prezzo: ");
	char app[4];
	do{
		getInput(4, app, false);
		prod.prezzo=atoi(app);
	}while(prod.prezzo<=0);
	prod.tipo=!yesOrNo("é una bevanda?",'y','n',true,false);
	prod.listaIngredienti=NULL;
	printf("Elenco degli ingredienti:\n");
	do
	{
		ingrediente *app=malloc(sizeof(ingrediente));
		app->next=NULL;
		if(prod.listaIngredienti ==NULL) prod.listaIngredienti=app;
		else{
			ingrediente * app2=prod.listaIngredienti;
			while(app2->next!=NULL) app2=app2->next;
			app2->next=app;
		}
		printf("Inserire Nome Ingrediente: ");
		getInput(16,app->nome,false);
		printf("Inserire la quantita che si utilizza: ");
		do{
			char n[4];
			getInput(4,n,false);
			app->quantita=atoi(n);
		}while (app->quantita<0);	
			
	}while(yesOrNo("si utilizzano altri ingredienti?",'y','n',true,false));
	return prod;
}
void viewADDCliente(cliente * new){
	char app[2];
	system("clear");
	printf("Nome: ");
    getInput(16, new->nome, false);
    printf("Cognome: ");
    getInput(16, new->cognome, false);
	printf("Numero di commensali: ");
	getInput(3,app,false);
	new->N_Persone=atoi(app);
}
Tavolo ViewtavoliLiberi(Tavolo* Testa){
	system("clear");
	Tavolo t;
	Tavolo * p;
	printf("Lista dei tavoli Liberi:\n");	
	for(p=Testa;p!=NULL;p=p->next){
		printf("Numero:%d \n",p->N_Tavolo);
	}
	int app;
	int c=0;
	printf("sceglierne uno: \n");
	do{
		char k[4];
		getInput(4,k,false);
		app=atoi(k);
		t.N_Tavolo=app;
		for(p=Testa;p!=NULL;p=p->next){
                	if(p->N_Tavolo==t.N_Tavolo){
				c=1;
				t.turno=p->turno;
			}
        	}
		if(c!=1)printf("valore non valido RE-INSERIRE");
	}while(c!=1);
		
	return t;
}
void ViewStatoIngredienti(ingrediente *lista){

	ingrediente *p;
	system("clear");
	printf("----------------Stato degli Ingredienti----------------\n");
	for (p= lista; p!=NULL; p=p->next)
	{		
		printf("Ingrediente: %s\tquantita rimanente: %d\n",p->nome,p->quantita);
	}
	
}
void ViewScontrino(prodotto * Lista,int spesa){
	prodotto * i;
	int j=1;
	system("clear");
	printf("------------------------Scontrino----------------------\n");
	for(i = Lista; i != NULL; i=i->next)
	{
		printf("%d]prodotto: %s     %d  X %d€\tcosto totale prodotto=%d€\n",j,i->nome,i->quantita,i->prezzo,i->CostoTotaleProdotto);
		ingrediente *t;
		for ( t = i->listaIngredienti; t!=NULL; t=t->next)
		{
			printf("\t\tAggiunta: %s  %d X %d€\n",t->nome,t->quantita,t->costo);
		}
		printf("---------------------------------------------------\n");
		j++;
	}
	printf("\t\t\t\t\tCosto totale: %d\n",spesa);
	getchar();
	return;
}
int ViewGiorno(){
	system("clear");
	int c=0;
	char app[4];
	printf("di quale giorno del mese corrente si vuole visualizzare l'incasso totale? ");
	do{
		getInput(4,app,false);
		c=atoi(app);
	}while(c<1 || c>31);
	return c;
}
int ViewMese(){
	system("clear");
	int c=0;
	char app[4];
	printf("di quale mese dell' anno corrente si vuole visualizzare l'incasso totale? ");
	do{
		getInput(4,app,false);
		c=atoi(app);
	}while(c<1 || c>12);
	return c;
}
