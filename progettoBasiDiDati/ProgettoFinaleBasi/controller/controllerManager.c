#include "../util/defines.h"
#include "../View/managerView.h"
#include "../model/db.h"
#include <stdio.h>

void freeCameriere(cameriere * Testa)
{
	int c=0;
	cameriere * p=Testa;
	while (p!=NULL){
		p=p->next;
		c++;
		}

	for (int i = 0; i < c; i++){
		p=Testa;
		for (int j =0; j < c-i-1; j++)
		{
			p=p->next;	
		}
		free(p->next);
		p->next=NULL;
	}
}
void freeTurno(turno * Testa)
{
	int c=0;
	turno * p=Testa;
	while (p!=NULL){
		p=p->next;
		c++;
		}

	for (int i = 0; i < c; i++){
		p=Testa;
		for (int j =0; j < c-i-1; j++)
		{
			p=p->next;	
		}
		free(p->next);
		p->next=NULL;
	}
}
void Creare_Turni(){
	int * a=ViewCreareTurni();
	if(dbCreaTurno(a[0],a[1])!=0){
		printf("error\n");
		printf("premere invio per continuare\n");
	}
	free(a);
}
void InserireCliente(){
	cliente new;
	Tavolo* testaLista=NULL;
	viewADDCliente(&new);	
	dbListaTavoli(&testaLista,new.N_Persone);
	if(testaLista!=NULL){
		Tavolo tavoloScelto=ViewtavoliLiberi(testaLista);
		new.Tavolo=tavoloScelto.N_Tavolo;
		new.Turno=tavoloScelto.turno;
		dbAddCliente(new);
	}
	else {
		printf("Non Ci sono Tavoli Liberi\n");
		printf("Premere invio per continuare...");
		getchar();
		return;
	}	
	printf("premere invio per continuare...\n");
	getchar();
}
void AggiungereTavolo(){
	int n=ViewTavolo();
	if(dbAddTavolo(n)!=0)
		printf("error\n");
	printf("premere invio per continuare\n");
	getchar();
	return;
	
}
void AssegnareCameriereTavolo(){
	
	cameriere * listaCameriere=NULL;
	dbListCamerieri(&listaCameriere);
	turno * listaTurno=NULL;
	dbListTurni(&listaTurno);
	cameriere cameriere=viewCameriere(listaCameriere);
	turno * scelto=viewTurni(listaTurno);
	int t;
	printf("Quale Tavolo? ");
	char app[4];
	do{
		getInput(4,app,false);
		t=atoi(app);
	}while(t<=0);
	dbAssegnaTavoloTurno(cameriere,*scelto,t);
	printf("premere invio per continuare\n");
	getchar();
	freeCameriere(listaCameriere);
	freeTurno(listaTurno);

}
void AggiungiCameriere(){
	cameriere c;
	ViewAddCameriere(&c);
	dbAddCameriere(c);
	printf("premere invio per continuare\n");
	getchar();
}
void TurnoTavolo(){
	int tavolo=viewTurnoTavoli();
	turno * lista=NULL;
	dbListTurni(&lista);
	turno* scelto=viewTurni(lista);
	dbAssegnaTavoli(tavolo,*scelto);
	printf("premere invio per continuare\n");
	getchar();
	freeTurno(lista);
};
void InserireNuovoElementoMenu(){
	prodotto p=viewAddNuovoElemento();
	dbAddElementoMenu(p);
	printf("premere invio per continuare...\n");
	getchar();
};
void AggiungereIngredienti(){
	if(viewIngredienti()==1){
		ingrediente i=viewAddIngrediente();
		dbAddIngrediente(i);
	}
	else{
		ingrediente *listaIngredienti=NULL;
		viewUpdateIngrediente(&listaIngredienti);
		if(listaIngredienti==NULL)
		{
			printf("Error\n");
			printf("premere invio per continuare\n");
			getchar();
			return;
		}
		while(listaIngredienti!=NULL)
		{
			ingrediente * p=listaIngredienti;
			dbUpdateIngredienti(*listaIngredienti);
			listaIngredienti=listaIngredienti->next;
			free(p);
		}
	}
	printf("premere invio per continuare...");
	getchar();
}
void statoAggiunte(){
	ingrediente * lista=NULL;
	dbIngredienti(&lista);
	if(lista!=NULL) ViewStatoIngredienti(lista);
	printf("premere invio per continuare\n");
	getchar();
}
void StampaScontrino(){
	int t = ViewTavoloCliente();
    int c =dbClienteTavolo(t);
	prodotto * Lista=NULL;
	int SpesaToT;
	dbStampaScontrino(&Lista,&SpesaToT,c);
	if(Lista==NULL) 
	{
		printf("non ci sono ordini da parte di questo Cliente\n");
		getchar();
		return;
	}
	ViewScontrino(Lista,SpesaToT);
}
void IncassiGiorno(){
	int i=ViewGiorno();
	int s=dbIncassoGiorno(i);
	printf("l'incasso del giorno selezionato é di: %d\n",s);
	printf("premere invio per continuare\n");
	getchar();
}
void IncassiMese(){
	int i=ViewMese();
	int s=dbIncassoMese(i);
	
	printf("l'incasso del mese selezionato é di: %d\n",s);
	printf("premere invio per continuare\n");
	getchar();
}
void run_Manager(){
	do{
		int r=ViewManager();
		switch(r){
			case 1:
				InserireCliente();
				break;
			case 2:
				StampaScontrino();
				break;
			case 3:
				IncassiGiorno();
				break;
			case 4:
				IncassiMese();
				break;
			case 5:
				AggiungereIngredienti();
				break;
			case 6:
				AggiungiCameriere();
				break;
			case 7:
				InserireNuovoElementoMenu();
				break;
			case 8:
				statoAggiunte();
				break;
			case 9:
				AggiungereTavolo();
				break;
			case 10:
				AssegnareCameriereTavolo();
				break;
			case 11:
				Creare_Turni();
				break;
			case 12:
				TurnoTavolo();
				break;
			case 13:
				return;
				break;
			case 14:
				exit(1);
				break;
			default:
                fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
                abort();
				break;
		}	
	}while(1);
};

