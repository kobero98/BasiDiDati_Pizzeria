#include "../util/defines.h"
#include "cameriereView.h"
#include <stdio.h>
#include <string.h>
int ViewSelezionareTavolo(){
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
void ViewTavoliAssegnati(int * a,int d){
    int i=1;
    system("clear");
    printf("Tavoli Assegnati\n");
    while(i<=d)
    {
        printf("%d]Tavolo numero:%d\n",i,a[i-1]);
        i++;
    }
    getchar();
}
cameriere * viewDatiCameriere(){
    cameriere * c=malloc(sizeof(cameriere));
    printf("Nome Cameriere: ");
    getInput(16,c->nome,false);
    printf("Cognome Cameriere:");
    getInput(16,c->cognome,false);
    return c;
}
char * viewAggiunta(ingrediente  * aggiunte){
    int dim=0;
    char *s=malloc(256);
    memset(s,0,256);
    ingrediente *p;
    if(!yesOrNo("Si Vuole Inserire Aggiunte alla pizza?",'y','n',true,false)){
        strcpy(s,"*");
        return s;   
    } 
    do{
        int i=1;
        for(p=aggiunte;p!=NULL;p=p->next)
        {
            printf("%d]%s %d\n",i,p->nome,p->costo);
            i++;
        }
        int number;
        char n[4];
        printf("Digitare  numero Aggiunta: ");
        do{
            getInput(4,n,false);
            number=atoi(n);
        }while(number<1 && number>i);
        p=aggiunte;
        i=1;
        while(i<number){
            p=p->next;
            i=i+1;
        }
        strncpy(s+dim,p->nome,strlen(p->nome));
        dim=dim+strlen(p->nome);
        strncpy(s+dim,"?",2);
        dim=dim+1;
        printf("Quantita dell'agginta? ");
        do{
            getInput(4,n,false);
        }while(atoi(n)<=0);
        strncpy(s+dim,n,strlen(n));
        dim=dim+strlen(n);
        strncpy(s+dim,"#",2);
        dim=dim+1;
    }while(yesOrNo("Vuoi Inserire Altre Aggiunte per questo prodoto?",'y','n',true,false) && dim<256);
    strncpy(s+dim,"*",2);
    return s;
}
char* OrdineCamerierePizze(ingrediente * aggiunte,prodotto * lista){
    char * s=malloc(2048); 
    memset(s,0,2048);        
    int dim=0;
  do{
        int i=1;
        prodotto *p;
        char *s2;
        for(p=lista;p!=NULL;p=p->next)
        {
            if(p->tipo==1){
                printf("%d]%s prezzo: %d\n",i,p->nome,p->prezzo);
                i++;
            }
        }
        int number;
        char n[4];
        printf("Digitare  numero prodotto: ");
        do{
            getInput(4,n,false);
            number=atoi(n);
        }while(number<1 && number>i);
        p=lista;
        i=0;
        while(i<number){
            if(p->tipo==1){
            i=i+1;
            if(i!=number) p=p->next;
           }
           else p=p->next;
        }
        strncpy(s+dim,p->nome,strlen(p->nome));
        dim=dim+strlen(p->nome);
        strncpy(s+dim,"?",2);
        dim=dim+1;
        s2=viewAggiunta(aggiunte);
        printf("quante pizze cosi? ");
        do{
            getInput(4,n,false);
        }while(atoi(n)<=0);
        strncpy(s+dim,n,strlen(n)+1);
        dim=dim+strlen(n);
        strncpy(s+dim,"#",2);
        dim=dim+1;
        strncpy(s+dim,s2,strlen(s2));
        dim=dim+strlen(s2);
        free(s2);
    }while(yesOrNo("Vuoi Inserire Altri Prodotti?",'y','n',true,false) && dim<2048);
    strncpy(s+dim,"@",2);
    
    return s;
}
char * OrdineCameriereBevande(prodotto * lista){
    char * s=malloc(2048); 
    memset(s,0,2048);        
    int dim=0;
    system("clear");
    do{
        int i=1;
        prodotto *p;
        for(p=lista;p!=NULL;p=p->next)
        {
            if(p->tipo==0){
                printf("%d]%s   prezzo: %d\n",i,p->nome,p->prezzo);
                i++;
                }
        }
        int number;
        char n[4];
        printf("Digitare  numero prodotto: ");
        do{
            getInput(4,n,false);
            number=atoi(n);
        }while(number<1 && number>i);
        p=lista;
        i=0;
        while(i<number){
            
           if(p->tipo==0){
            i=i+1;
            if(i!=number) p=p->next;
           }
           else p=p->next;
        }
        printf("%s\n",p->nome);
        strncpy(s+dim,p->nome,strlen(p->nome));
        dim=dim+strlen(p->nome);
        strncpy(s+dim,"?",2);
        dim=dim+1;
        printf("quantita? ");
        do{
            getInput(4,n,false);
        }while(atoi(n)<=0);
        strncpy(s+dim,n,strlen(n)+1);
        dim=dim+strlen(n);
        strncpy(s+dim,"#",2);
        dim=dim+1;
    }while(yesOrNo("Vuoi Inserire Altri Prodotti?",'y','n',true,false) && dim<2048);
    strncpy(s+dim,"@",2);
    return s;
}
int ViewOrdiniDaConsegnare(ordini * list,int z)
{
    int j=1;
    system("clear");
    printf("-----Lista Ordini Da COnsegnare-----\n");
    for (ordini* i = list; i!=NULL; i=i->next)
    {
        printf("%d]Tavolo %d ordine delle ore %2d:%2d\n",j,i->tavolo,(i->t).hour,(i->t).minute);
        j++;
    }
    int c=0;
    if(z!=0){
        char app[4];
        printf("Inserire numero comanda consegnata: ");
        do{
            getInput(4,app,false);
            c=atoi(app);
        }while(c<=0 || c>j);
    }

    return c;
}
int ViewCameriere(){
    system("clear");	
    printf("###############################################\n");
	printf("##                                           ##\n");
    printf("##                 Cameriere                 ##\n");
    printf("##                                           ##\n");
    printf("###############################################\n");
	printf("1]Visualizza Tavoli Assegnati nel turno corrente\n");
	printf("2]Prendi ordine Tavolo\n");
    printf("3]Visualizza ordini pronti\n");
    printf("4]Consegnare Ordine\n");
	printf("5]Cambiare Utente\n");
    printf("6]Chiudere Programma\n");
	int c;
	char app[3];
	do{
		getInput(3,app,false);
		c=atoi(app);
	}while(c<1 ||c>6);
	return c;
}