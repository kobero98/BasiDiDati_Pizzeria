#include "../util/defines.h"
#include "../model/db.h"
#include "../View/cameriereView.h"
#include <string.h>
#include <stdio.h>

cameriere io;
void TavoliAssegnati(){
    int dim;
    int * i= dbViewTavoli(io,&dim);
    if(i==NULL){
        printf("Tavoli non Assegnati\n");
        printf("premere invio per continuare...\n");
        getchar();
        return;
    }
    ViewTavoliAssegnati(i,dim);
    printf("premere invio per continuare...\n");
    getchar();
}
void prendereOrdine(){
    int t=ViewSelezionareTavolo();
    int c=dbClienteTavolo(t);
    printf("codice cliente:%d\n",c);
    if(c==0){
        printf("Errore nessun Nuovo cliente seduto a questo tavolo\n");
        printf("Premere invio per continuare...");
        getchar();
        return;
    }
    ingrediente * ListaAggiunte=NULL;
    dbAggiunte(&ListaAggiunte);
    if(ListaAggiunte==NULL) return;
    prodotto * menu=NULL;
    dbListaMenu(&menu);
    if(menu==NULL) return;
    char *pizze=OrdineCamerierePizze(ListaAggiunte,menu);
    char *bevande=OrdineCameriereBevande(menu);
    dbAddNewOrdine(c,pizze,bevande);
    printf("premere invio per continuare...\n");
    getchar();
    free(bevande);
    free(pizze);
}
void OrdiniDaConsegnare(){
    ordini * list=NULL;
    dbOrdiniDaConsegnare(&list,io);
    if(list==NULL){
        printf("Non Ci sono Comande Completate\n");
        printf("premere invio per continuare...\n");
        getchar();
        return;
    }
    ViewOrdiniDaConsegnare(list,0);
    printf("premere invio per continuare...\n");
    getchar();
}
void Ordine_consegnato(){
    ordini * list=NULL;
    dbOrdiniDaConsegnare(&list,io);
    if(list==NULL){
        printf("Non Ci sono Comande Completate\n");
        printf("premere invio per continuare...\n");
        getchar();
        return;
    }
    int c=ViewOrdiniDaConsegnare(list,1);
    int i=1;
    ordini * p=list;
    while(i<c){
        i++;
        p=p->next;
    }
    dbUpdateComanda(*p);
    printf("premere invio per continuare...\n");
    getchar();
    return ;
}
void run_as_cameriere(){
    do{
    cameriere * c=viewDatiCameriere();
    strcpy(io.nome,c->nome);
    strcpy(io.cognome,c->cognome);
    free(c);
    }while(!dbVerificaCameriere(io));
    do{
        int i=ViewCameriere();
        switch (i)
        {
            case 1:
                TavoliAssegnati();
                break;
            case 2:
                prendereOrdine();
                break;
            case 3:
                OrdiniDaConsegnare();
                break;
            case 4:
                Ordine_consegnato();
                break;
            case 5:
                return;
                break;
            case 6:
                exit(1);
                break;
            default:
                fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
                abort();
                break;
        }
    }while(1);
}