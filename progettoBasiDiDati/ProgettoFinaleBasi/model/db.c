#include <stdio.h>
#include <string.h>
#include "../util/defines.h"
void freeIngredienti(ingrediente * lista){
    if(lista==NULL) return;
    ingrediente * i=lista;
    while(i->next!=NULL)
    {
        ingrediente * app=i;
        while ((app->next)->next!=NULL) app=app->next;
        free(app->next);
        app->next=NULL;
    }
    free(i);
    return;
}
void freeProdotti(prodotto * testa){
    if(testa==NULL) return;
    prodotto * p=testa;
    while(p->next!=NULL)
    {
        prodotto * app=p;
        while ((app->next)->next!=NULL) app=app->next;
        freeIngredienti(app->next->listaIngredienti);
        free(app->next);
        app->next=NULL;
    }
    freeIngredienti(p->listaIngredienti);
    free(p);
    return;
}
struct configuration conf;
MYSQL *conn;
char* parsIngredienti(ingrediente *listaIngredienti){
	
	int dim=0;
	ingrediente *i=listaIngredienti;
	char a[4];
	while(i!=NULL){
		sprintf(a,"%d",i->quantita);
		dim=dim+strlen(i->nome)+2+ strlen(a);
		i=i->next;
	}
	dim=dim+1;
	i=listaIngredienti;
	char * s=malloc(sizeof(char)*dim);
	char *l=s;
	int j=0;
	while(i!=NULL){
		strcpy(s+j,i->nome);
		j=j+strlen(i->nome);
		strcpy(s+j,"?");
		j++;
		sprintf(a,"%d",i->quantita);
		strcpy(s+j,a);
		j=j+strlen(a);
		strcpy(s+j,"#");
		j++;
		i=i->next;
	}
	strcpy(s+j,"@");
	return  l;
}
void dbAssegnaTavoloTurno(cameriere c,turno t, int tavolo)
{
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
    if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

    if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *AssegnaTurnoTavolo;
	MYSQL_BIND param[4]; // Used both for input and output

	if(!setup_prepared_stmt(&AssegnaTurnoTavolo, "call AssegnareTavoloCameriere(?,?,?,?)", conn)) {
			print_stmt_error(AssegnaTurnoTavolo, "Unable to initialize login statement\n");
			goto err2;
		}
		// Prepare parameters
		memset(param, 0, sizeof(param));

		param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
		param[0].buffer = c.nome;
		param[0].buffer_length = strlen(c.nome);

		param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
		param[1].buffer = c.cognome;
		param[1].buffer_length = strlen(c.cognome);

		param[2].buffer_type = MYSQL_TYPE_LONG; // IN
		param[2].buffer = &tavolo;
		param[2].buffer_length = sizeof(tavolo);

		param[3].buffer_type = MYSQL_TYPE_DATETIME; // IN
		param[3].buffer = (char*)&(t.tempo);

		if (mysql_stmt_bind_param(AssegnaTurnoTavolo, param) != 0) { // Note _param
			print_stmt_error(AssegnaTurnoTavolo, "Could not bind parameters for login");
			goto err;
		}

		// Run procedure
		if (mysql_stmt_execute(AssegnaTurnoTavolo) != 0) {
			print_stmt_error(AssegnaTurnoTavolo, "Could not execute login procedure\n");
			goto err;
		}
		mysql_stmt_close(AssegnaTurnoTavolo);
		mysql_close(conn);
		return ;

		err:
			mysql_stmt_close(AssegnaTurnoTavolo);
			mysql_close(conn);
		err2:
		return ;
}
void dbAssegnaTavoli(int i,turno scelto){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
    if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

    if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *AssegnaTurnoTavolo;
	MYSQL_BIND param[2]; // Used both for input and output

	if(!setup_prepared_stmt(&AssegnaTurnoTavolo, "call AssegnaTurnoTavolo(?,?)", conn)) {
			print_stmt_error(AssegnaTurnoTavolo, "Unable to initialize login statement\n");
			goto err2;
		}
		// Prepare parameters
		memset(param, 0, sizeof(param));
		param[0].buffer_type = MYSQL_TYPE_LONG; // IN
		param[0].buffer = &i;
		param[0].buffer_length = sizeof(i);

		param[1].buffer_type = MYSQL_TYPE_DATETIME; // IN
		param[1].buffer = (char*)&(scelto.tempo);

		if (mysql_stmt_bind_param(AssegnaTurnoTavolo, param) != 0) { // Note _param
			print_stmt_error(AssegnaTurnoTavolo, "Could not bind parameters for login");
			goto err;
		}

		// Run procedure
		if (mysql_stmt_execute(AssegnaTurnoTavolo) != 0) {
			print_stmt_error(AssegnaTurnoTavolo, "Could not execute login procedure");
			goto err;
		}
		mysql_stmt_close(AssegnaTurnoTavolo);
		mysql_close(conn);
		return ;

		err:
		mysql_stmt_close(AssegnaTurnoTavolo);
		mysql_close(conn);
		err2:
		return ;
};
void dbAddElementoMenu(prodotto p){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
    if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

    if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *addProdotto;
	MYSQL_BIND param[4]; // Used both for input and output

	if(!setup_prepared_stmt(&addProdotto, "call addProdotto(?,?,?,?)", conn)) {
			print_stmt_error(addProdotto, "Unable to initialize login statement\n");
			goto err2;
		}
		// Prepare parameters
		memset(param, 0, sizeof(param));
		param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
		param[0].buffer = p.nome;
		param[0].buffer_length = strlen(p.nome);

		param[1].buffer_type = MYSQL_TYPE_LONG; // IN
		param[1].buffer = &p.prezzo;
		param[1].buffer_length = sizeof(p.prezzo);
	
		param[2].buffer_type = MYSQL_TYPE_LONG; // IN
		param[2].buffer = &p.tipo;
		param[2].buffer_length = sizeof(p.tipo);
		
		char* s=parsIngredienti(p.listaIngredienti);
		param[3].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
		param[3].buffer = s;
		param[3].buffer_length = strlen(s);

		if (mysql_stmt_bind_param(addProdotto, param) != 0) { // Note _param
			print_stmt_error(addProdotto, "Could not bind parameters for login");
			goto err;
		}

		// Run procedure
		if (mysql_stmt_execute(addProdotto) != 0) {
			print_stmt_error(addProdotto, "Could not execute login procedure");
			goto err;
		}
		free(s);
		mysql_stmt_close(addProdotto);
		mysql_close(conn);
		return ;

		err:
		free(s);
		mysql_stmt_close(addProdotto);
		err2:
		mysql_close(conn);
		return ;
}
void dbUpdateIngredienti(ingrediente i){
		if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
    if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

    if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *IncrementaIngrediente;
	MYSQL_BIND param[2]; // Used both for input and output

	if(!setup_prepared_stmt(&IncrementaIngrediente, "call IncrementaIngrediente(?,?)", conn)) {
			print_stmt_error(IncrementaIngrediente, "Unable to initialize login statement\n");
			goto err2;
		}
		// Prepare parameters
		memset(param, 0, sizeof(param));
		param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
		param[0].buffer = i.nome;
		param[0].buffer_length = strlen(i.nome);

		param[1].buffer_type = MYSQL_TYPE_LONG; // IN
		param[1].buffer = &i.quantita;
		param[1].buffer_length = sizeof(i.quantita);


		if (mysql_stmt_bind_param(IncrementaIngrediente, param) != 0) { // Note _param
			print_stmt_error(IncrementaIngrediente, "Could not bind parameters for login");
			goto err;
		}

		// Run procedure
		if (mysql_stmt_execute(IncrementaIngrediente) != 0) {
			print_stmt_error(IncrementaIngrediente, "Could not execute login procedure");
			goto err;
		}
		mysql_stmt_close(IncrementaIngrediente);
		mysql_close(conn);
		return ;

		err:
		mysql_stmt_close(IncrementaIngrediente);
		err2:
		mysql_close(conn);
		return ;
}
void dbAddIngrediente(ingrediente i){

		if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
    if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

    if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *addIngredienti;
	MYSQL_BIND param[3]; // Used both for input and output

	if(!setup_prepared_stmt(&addIngredienti, "call addIngredienti(?,?,?)", conn)) {
			print_stmt_error(addIngredienti, "Unable to initialize login statement\n");
			goto err2;
		}
		// Prepare parameters
		memset(param, 0, sizeof(param));
		param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
		param[0].buffer = i.nome;
		param[0].buffer_length = strlen(i.nome);

		param[1].buffer_type = MYSQL_TYPE_LONG; // IN
		param[1].buffer = &i.quantita;
		param[1].buffer_length = sizeof(i.quantita);

		param[2].buffer_type = MYSQL_TYPE_LONG; // IN
		param[2].buffer = &i.costo;
		param[2].buffer_length = sizeof(i.costo);


		if (mysql_stmt_bind_param(addIngredienti, param) != 0) { // Note _param
			print_stmt_error(addIngredienti, "Could not bind parameters for login");
			goto err;
		}

		// Run procedure
		if (mysql_stmt_execute(addIngredienti) != 0) {
			print_stmt_error(addIngredienti, "Could not execute login procedure");
			goto err;
		}
		mysql_stmt_close(addIngredienti);
		mysql_close(conn);
		return ;

		err:
		mysql_stmt_close(addIngredienti);
		err2:
		mysql_close(conn);
		return ;
}
void dbAddCameriere(cameriere c){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *Addcamerieri;
	MYSQL_BIND param[2]; // Used both for input and output

	if(!setup_prepared_stmt(&Addcamerieri, "call AddCamerieri(?,?)", conn)) {
		print_stmt_error(Addcamerieri, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = c.nome;
	param[0].buffer_length = strlen(c.nome);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = c.cognome;
	param[1].buffer_length = strlen(c.cognome);

	if (mysql_stmt_bind_param(Addcamerieri, param) != 0) { // Note _param
		print_stmt_error(Addcamerieri, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(Addcamerieri) != 0) {
		print_stmt_error(Addcamerieri, "Could not view Tavoli Liberi");
		goto err;
	}
	
	mysql_stmt_close(Addcamerieri);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(Addcamerieri);
    err2:
	mysql_close(conn);
	return;

}
void dbListTurni(turno **ListaTurni){

	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *ListTurni;
	if(!setup_prepared_stmt(&ListTurni, "call ListTurni()", conn)) {
		print_stmt_error(ListTurni, "Unable to initialize ListCamerieri statement\n");
		goto err2;
	}


	if (mysql_stmt_bind_param(ListTurni, NULL) != 0) { // Note _param
		print_stmt_error(ListTurni, "Could not bind parameters for ListCamerieri");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(ListTurni) != 0) {
		print_stmt_error(ListTurni, "Could not view ListCamerieri");
		goto err;
	}
	
	MYSQL_BIND param[2];
	MYSQL_TIME    ts;
	MYSQL_TIME    ts2;

	memset(param, 0, sizeof(param));
	param[0].buffer_type= MYSQL_TYPE_TIMESTAMP;
	param[0].buffer= (char *)&ts;

	param[1].buffer_type= MYSQL_TYPE_TIMESTAMP;
	param[1].buffer= (char *)&ts2;
	
	if(mysql_stmt_bind_result(ListTurni,param)!=0)
	{
        printf("empty result\n");
		goto err2;
	}

	if(mysql_stmt_store_result(ListTurni)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	while (!mysql_stmt_fetch(ListTurni))
	{
		printf(" %04d-%02d-%02d %02d:%02d:%02d \n",
                     ts.year, ts.month, ts.day,
                     ts.hour, ts.minute, ts.second);

		turno * app= malloc(sizeof(turno));
		if(app==NULL){
			printf("error Malloc\n");
		}
		app->next=NULL;
		if(*ListaTurni!=NULL)
		{
			turno * app2=*ListaTurni;
			while(app2->next!=NULL)
				app2=app2->next;
			app2->next=app;
		}
		else *ListaTurni=app;
		memcpy(&(app->tempo),&ts,sizeof(MYSQL_TIME));
		memcpy(&(app->oraFine),&ts2,sizeof(MYSQL_TIME));
	}
	mysql_stmt_close(ListTurni);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(ListTurni);
    err2:
	mysql_close(conn);
	return ;
}
void dbListCamerieri(cameriere ** c){

	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }
	
	MYSQL_STMT *ListCamerieri;
	if(!setup_prepared_stmt(&ListCamerieri, "call ListCamerieri()", conn)) {
		print_stmt_error(ListCamerieri, "Unable to initialize ListCamerieri statement\n");
		goto err2;
	}


	if (mysql_stmt_bind_param(ListCamerieri, NULL) != 0) { // Note _param
		print_stmt_error(ListCamerieri, "Could not bind parameters for ListCamerieri");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(ListCamerieri) != 0) {
		print_stmt_error(ListCamerieri, "Could not view ListCamerieri");
		goto err;
	}
	MYSQL_BIND param[2];
	char nome[16];
	char cognome[16];

	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // OUT
	param[0].buffer = nome;
	param[0].buffer_length = 15;

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // OUT
	param[1].buffer = cognome;
	param[1].buffer_length = 15;	
	
	if(mysql_stmt_bind_result(ListCamerieri,param)!=0)
	{
        printf("empty result\n");
		goto err2;
	}

	if(mysql_stmt_store_result(ListCamerieri)!=0)
	{
        printf("empty result\n");
		goto err;
	}	
	
	while (!mysql_stmt_fetch(ListCamerieri))
	{
		cameriere * app= malloc(sizeof(cameriere));
		if(app==NULL){
			printf("error Malloc\n");
			goto err;
		}
		strcpy(app->nome,nome);
		strcpy(app->cognome,cognome);
		app->next=NULL;
		if(*c!=NULL)
		{
			cameriere * app2=*c;
			while(app2->next!=NULL) app2=app2->next;
			app2->next=app;
		}
		else *c=app;


		printf("cioa\n");
	}
	mysql_stmt_close(ListCamerieri);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(ListCamerieri);
    err2:
	mysql_close(conn);
	return ;
}
int dbCreaTurno(int anno,int mese){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }
	MYSQL_STMT *Creare_Turno;
	if(!setup_prepared_stmt(&Creare_Turno, "call Creare_Turno(?,?)", conn)) {
		print_stmt_error(Creare_Turno, "Unable to initialize Creare_Turno statement\n");
		goto err2;
	}
		MYSQL_BIND param[2]; // Used both for input and output
		// Prepare parameters
		memset(param, 0, sizeof(param));
		param[0].buffer_type = MYSQL_TYPE_LONG; // IN
		param[0].buffer = &mese;
		param[0].buffer_length = sizeof(mese);

		param[1].buffer_type = MYSQL_TYPE_LONG; // IN
		param[1].buffer = &anno;
		param[1].buffer_length = sizeof(anno);

	if (mysql_stmt_bind_param(Creare_Turno, param) != 0) { // Note _param
		print_stmt_error(Creare_Turno, "Could not bind parameters for Creare_Turno");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(Creare_Turno) != 0) {
		print_stmt_error(Creare_Turno, "Could not view Creare_Turno");
		goto err;
	}
	
	mysql_stmt_close(Creare_Turno);
	mysql_close(conn);
	return 0;

    err:
	mysql_stmt_close(Creare_Turno);
    err2:
	mysql_close(conn);
	return 1;
}
ruolo dblogin(credenziali cred)
{
	
	if(!parse_config("users/login.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

        if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }


	MYSQL_STMT *login_procedure;
	MYSQL_BIND param[3]; // Used both for input and output
	int ruolo;

	if(!setup_prepared_stmt(&login_procedure, "call login(?, ?, ?)", conn)) {
		print_stmt_error(login_procedure, "Unable to initialize login statement\n");
		goto err2;
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = cred.username;
	param[0].buffer_length = strlen(cred.username);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = cred.password;
	param[1].buffer_length = strlen(cred.password);

	param[2].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[2].buffer = &ruolo;
	param[2].buffer_length = sizeof(ruolo);

	if (mysql_stmt_bind_param(login_procedure, param) != 0) { // Note _param
		print_stmt_error(login_procedure, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(login_procedure) != 0) {
		print_stmt_error(login_procedure, "Could not execute login procedure");
		goto err;
	}
	// Prepare output parameters
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[0].buffer = &ruolo;
	param[0].buffer_length = sizeof(ruolo);
	
	if(mysql_stmt_bind_result(login_procedure, param)) {
		print_stmt_error(login_procedure, "Could not retrieve output parameter");
		goto err;
	}
	
	// Retrieve output parameter
	if(mysql_stmt_fetch(login_procedure)) {
		print_stmt_error(login_procedure, "Could not buffer results");
		goto err;
	}

	mysql_stmt_close(login_procedure);
	mysql_close(conn);
	return ruolo;

    err:
	mysql_stmt_close(login_procedure);
	mysql_close(conn);
    err2:
	return FAILED_LOGIN;
}
int dbAddTavolo(int n)
{

	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
    if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

    if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *addTavolo;
	MYSQL_BIND param; // Used both for input and output

	if(!setup_prepared_stmt(&addTavolo, "call AggiungiTavolo(?)", conn)) {
			print_stmt_error(addTavolo, "Unable to initialize login statement\n");
			goto err2;
		}

		// Prepare parameters
		memset(&param, 0, sizeof(param));
		param.buffer_type = MYSQL_TYPE_LONG; // OUT
		param.buffer = &n;
		param.buffer_length = sizeof(n);

		if (mysql_stmt_bind_param(addTavolo, &param) != 0) { // Note _param
			print_stmt_error(addTavolo, "Could not bind parameters for login");
			goto err;
		}

		// Run procedure
		if (mysql_stmt_execute(addTavolo) != 0) {
			print_stmt_error(addTavolo, "Could not execute login procedure");
			goto err;
		}
		mysql_stmt_close(addTavolo);
		mysql_close(conn);
		return 0;

		err:
		mysql_stmt_close(addTavolo);
		mysql_close(conn);
		err2:
		return 1;
}
void dbAddCliente(cliente n){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *dbAddC;
	MYSQL_BIND param[5]; // Used both for input and output

	if(!setup_prepared_stmt(&dbAddC, "call AddCliente(?,?,?,?,?)", conn)) {
		print_stmt_error(dbAddC, "Unable to initialize AddCliente\n");
		goto err2;
	}
	printf("%d\n",n.Tavolo);
	printf("%04d-%02d-%02d %02d:%02d:%02d \n",(n.Turno).year,(n.Turno).month,(n.Turno).day,(n.Turno).hour, (n.Turno).minute, (n.Turno).second);
	
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = n.nome;
	param[0].buffer_length = strlen(n.nome);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = n.cognome;
	param[1].buffer_length = strlen(n.cognome);

	param[2].buffer_type = MYSQL_TYPE_LONG; // IN
	param[2].buffer = &n.N_Persone;
	param[2].buffer_length = sizeof(n.N_Persone);

	param[3].buffer_type = MYSQL_TYPE_LONG; // IN
	param[3].buffer = &(n.Tavolo);
	param[3].buffer_length = sizeof(n.Tavolo);

	param[4].buffer_type = MYSQL_TYPE_DATETIME; // IN
	param[4].buffer = (char *)&n.Turno;

	if (mysql_stmt_bind_param(dbAddC, param) != 0) { // Note _param
		print_stmt_error(dbAddC, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(dbAddC) != 0) {
		print_stmt_error(dbAddC, "Could not view Tavoli Liberi");
		goto err;
	}

	mysql_stmt_close(dbAddC);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(dbAddC);
    err2:
	mysql_close(conn);
	return;
}
void dbListaTavoli(Tavolo ** Testa,int n)
{ 

	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *TavoliLiberi_procedure;
	MYSQL_BIND param; // Used both for input and output

	if(!setup_prepared_stmt(&TavoliLiberi_procedure, "call TavoliLiberi(?)", conn)) {
		print_stmt_error(TavoliLiberi_procedure, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(&param, 0, sizeof(param));
	param.buffer_type = MYSQL_TYPE_LONG; // IN
	param.buffer = &n;
	param.buffer_length = sizeof(n);

	if (mysql_stmt_bind_param(TavoliLiberi_procedure, &param) != 0) { // Note _param
		print_stmt_error(TavoliLiberi_procedure, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(TavoliLiberi_procedure) != 0) {
		print_stmt_error(TavoliLiberi_procedure, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND param1[2];	
	MYSQL_TIME    ts;
	int i;

	memset(param1, 0, sizeof(param1));
	param1[0].buffer_type= MYSQL_TYPE_LONG;
	param1[0].buffer= &i;
	param1[0].buffer_length = sizeof(i);

	
	param1[1].buffer_type= MYSQL_TYPE_TIMESTAMP;
	param1[1].buffer= (char *)&ts;
	if(mysql_stmt_bind_result(TavoliLiberi_procedure,param1)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	if(mysql_stmt_store_result(TavoliLiberi_procedure)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	
	while (!mysql_stmt_fetch(TavoliLiberi_procedure))
	{
		printf("cioa\n");
		Tavolo * app= malloc(sizeof(Tavolo));
		if(app==NULL){
			printf("error Malloc\n");
		}
		app->next=NULL;
		if(*Testa!=NULL)
		{
			Tavolo * app2=*Testa;
			while(app2->next!=NULL)
				app2=app2->next;
			app2->next=app;
		}
		else *Testa=app;
		
		app->N_Tavolo=i;
		memcpy(&(app->turno),&ts,sizeof(MYSQL_TIME));
	}

	mysql_stmt_close(TavoliLiberi_procedure);
	return;

    err:
	mysql_stmt_close(TavoliLiberi_procedure);
    err2:
	Testa=NULL;
	return;
}
int* dbViewTavoli(cameriere c,int * d){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *TavoliAssegnatiCameriere;
	MYSQL_BIND param[2]; // Used both for input and output
	
	if(!setup_prepared_stmt(&TavoliAssegnatiCameriere, "call TavoliAssegnatiCameriere(?,?)", conn)) {
		print_stmt_error(TavoliAssegnatiCameriere, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = &c.nome;
	param[0].buffer_length = strlen(c.nome);
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = &c.cognome;
	param[1].buffer_length = strlen(c.cognome);
	if (mysql_stmt_bind_param(TavoliAssegnatiCameriere, param) != 0) { // Note _param
		print_stmt_error(TavoliAssegnatiCameriere, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(TavoliAssegnatiCameriere) != 0) {
		print_stmt_error(TavoliAssegnatiCameriere, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND res;
	int i;

	memset(&res, 0, sizeof(res));
	res.buffer_type= MYSQL_TYPE_LONG;
	res.buffer= &i;
	res.buffer_length = sizeof(i);

	if(mysql_stmt_bind_result(TavoliAssegnatiCameriere,&res)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	
		if(mysql_stmt_store_result(TavoliAssegnatiCameriere)!=0)
		{
        	printf("empty result\n");
			goto err2;
		}
	int *Vet=NULL;
	int dim=mysql_stmt_num_rows(TavoliAssegnatiCameriere);
	*d=dim;
	if(dim>0)		
	{	
		Vet=malloc(sizeof(int)*dim);
		if(Vet==NULL) goto err;
		int j=0;
		while (!mysql_stmt_fetch(TavoliAssegnatiCameriere))
		{
			Vet[j]=i;
			j++;
		}
	}
	mysql_stmt_close(TavoliAssegnatiCameriere);
	mysql_close(conn);
	return Vet;

    err:
	mysql_stmt_close(TavoliAssegnatiCameriere);
    err2:
	mysql_close(conn);
	return NULL;	
}
int dbClienteTavolo(int t){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *Cliente_Tavolo;
	MYSQL_BIND param; // Used both for input and output
	
	if(!setup_prepared_stmt(&Cliente_Tavolo, "call Cliente_Tavolo(?)", conn)) {
		print_stmt_error(Cliente_Tavolo, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(&param, 0, sizeof(param));
	param.buffer_type = MYSQL_TYPE_LONG; // IN
	param.buffer = &t;
	param.buffer_length = sizeof(t);
	
	if (mysql_stmt_bind_param(Cliente_Tavolo,&param) != 0) { // Note _param
		print_stmt_error(Cliente_Tavolo, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(Cliente_Tavolo) != 0) {
		print_stmt_error(Cliente_Tavolo, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND res;
	int i;

	memset(&res, 0, sizeof(res));
	res.buffer_type= MYSQL_TYPE_LONG;
	res.buffer= &i;
	res.buffer_length = sizeof(i);

	if(mysql_stmt_bind_result(Cliente_Tavolo,&res)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	if(mysql_stmt_store_result(Cliente_Tavolo)!=0)
	{
    	printf("empty result\n");
		goto err2;		
	}
	if(mysql_stmt_fetch(Cliente_Tavolo)){
		return 0;
	}
	mysql_stmt_close(Cliente_Tavolo);
	mysql_close(conn);
	return i;

    err:
	mysql_stmt_close(Cliente_Tavolo);
    err2:
	mysql_close(conn);
	return 0;	
}
void dbIngredienti(ingrediente **Testa){


	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *dbListaIngredienti;
	 // Used both for input and output

	if(!setup_prepared_stmt(&dbListaIngredienti, "call dbListaIngredienti()", conn)) {
		print_stmt_error(dbListaIngredienti, "Unable to initialize login statement\n");
		goto err2;
	}

	if (mysql_stmt_bind_param(dbListaIngredienti,NULL) != 0) { // Note _param
		print_stmt_error(dbListaIngredienti, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(dbListaIngredienti) != 0) {
		print_stmt_error(dbListaIngredienti, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND param1[2];
	char nome[16];
	int i;

	memset(param1, 0, sizeof(param1));

	param1[0].buffer_type = MYSQL_TYPE_VAR_STRING; // OUT
	param1[0].buffer = nome;
	param1[0].buffer_length = 15;

	param1[1].buffer_type= MYSQL_TYPE_LONG;
	param1[1].buffer= &i;
	param1[1].buffer_length = sizeof(i);

	
	
	if(mysql_stmt_bind_result(dbListaIngredienti,param1)!=0)
	{
        printf("empty result\n");
		goto err2;
	}

	if(mysql_stmt_store_result(dbListaIngredienti)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	
	while (!mysql_stmt_fetch(dbListaIngredienti))
	{
		ingrediente * app= malloc(sizeof(ingrediente));
		if(app==NULL){
			printf("error Malloc\n");
		}
		app->next=NULL;
		if(*Testa!=NULL)
		{
			ingrediente * app2=*Testa;
			while(app2->next!=NULL)
				app2=app2->next;
			app2->next=app;
		}
		else *Testa=app;
		
		app->quantita=i;
		strcpy(app->nome,nome);
	}

	mysql_stmt_close(dbListaIngredienti);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(dbListaIngredienti);
    err2:
	Testa=NULL;
	mysql_close(conn);
	return;
}
void dbAggiunte(ingrediente **Testa)
{


	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *ListaAggiunte;
	 // Used both for input and output

	if(!setup_prepared_stmt(&ListaAggiunte, "call ListaAggiunte()", conn)) {
		print_stmt_error(ListaAggiunte, "Unable to initialize login statement\n");
		goto err2;
	}

	if (mysql_stmt_bind_param(ListaAggiunte,NULL) != 0) { // Note _param
		print_stmt_error(ListaAggiunte, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(ListaAggiunte) != 0) {
		print_stmt_error(ListaAggiunte, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND param1[2];
	char nome[16];
	int i;

	memset(param1, 0, sizeof(param1));

	param1[0].buffer_type = MYSQL_TYPE_VAR_STRING; // OUT
	param1[0].buffer = nome;
	param1[0].buffer_length = 15;

	param1[1].buffer_type= MYSQL_TYPE_LONG;
	param1[1].buffer= &i;
	param1[1].buffer_length = sizeof(i);

	
	
	if(mysql_stmt_bind_result(ListaAggiunte,param1)!=0)
	{
        printf("empty result\n");
		goto err2;
	}

	if(mysql_stmt_store_result(ListaAggiunte)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	
	while (!mysql_stmt_fetch(ListaAggiunte))
	{
		ingrediente * app= malloc(sizeof(ingrediente));
		if(app==NULL){
			printf("error Malloc\n");
		}
		app->next=NULL;
		if(*Testa!=NULL)
		{
			ingrediente * app2=*Testa;
			while(app2->next!=NULL)
				app2=app2->next;
			app2->next=app;
		}
		else *Testa=app;
		
		app->costo=i;
		strcpy(app->nome,nome);
	}

	mysql_stmt_close(ListaAggiunte);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(ListaAggiunte);
    err2:
	Testa=NULL;
	mysql_close(conn);
	return;
}
void dbListaMenu(prodotto ** Testa){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *ListaAggiunte;
	 // Used both for input and output

	if(!setup_prepared_stmt(&ListaAggiunte, "call menu()", conn)) {
		print_stmt_error(ListaAggiunte, "Unable to initialize login statement\n");
		goto err2;
	}

	if (mysql_stmt_bind_param(ListaAggiunte,NULL) != 0) { // Note _param
		print_stmt_error(ListaAggiunte, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(ListaAggiunte) != 0) {
		print_stmt_error(ListaAggiunte, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND param1[3];
	char nome[16];
	int i;
	int tipo;

	memset(param1, 0, sizeof(param1));

	param1[0].buffer_type = MYSQL_TYPE_VAR_STRING; // OUT
	param1[0].buffer = nome;
	param1[0].buffer_length = 15;

	param1[1].buffer_type= MYSQL_TYPE_LONG;
	param1[1].buffer= &i;
	param1[1].buffer_length = sizeof(i);

	param1[2].buffer_type= MYSQL_TYPE_LONG;
	param1[2].buffer= &tipo;
	param1[2].buffer_length = sizeof(tipo);
	
	if(mysql_stmt_bind_result(ListaAggiunte,param1)!=0)
	{
        printf("empty result\n");
		goto err2;
	}

	if(mysql_stmt_store_result(ListaAggiunte)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	
	while (!mysql_stmt_fetch(ListaAggiunte))
	{
		prodotto * app= malloc(sizeof(prodotto));
		if(app==NULL){
			printf("error Malloc\n");
		}
		app->next=NULL;
		if(*Testa!=NULL)
		{
			prodotto * app2=*Testa;
			while(app2->next!=NULL)
				app2=app2->next;
			app2->next=app;
		}
		else *Testa=app;
		app->tipo=tipo;
		app->prezzo=i;
		strcpy(app->nome,nome);
	}

	mysql_stmt_close(ListaAggiunte);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(ListaAggiunte);
    err2:
	Testa=NULL;
	mysql_close(conn);
	return;
}
void dbAddNewOrdine(int c,char * pizze,char * bevande){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *Ordine;
	 // Used both for input and output

	if(!setup_prepared_stmt(&Ordine, "call Ordine(?,?,?)", conn)) {
		print_stmt_error(Ordine, "Unable to initialize login statement\n");
		goto err2;
	}
	MYSQL_BIND param[3]; 
	// Prepare parameters
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &c;
	param[0].buffer_length = sizeof(c);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = pizze;
	param[1].buffer_length = strlen(pizze);

	param[2].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[2].buffer = bevande;
	param[2].buffer_length = strlen(bevande);

	if (mysql_stmt_bind_param(Ordine,param) != 0) { // Note _param
		print_stmt_error(Ordine, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(Ordine) != 0) {
		print_stmt_error(Ordine, "Could not view Tavoli Liberi");
		goto err;
	}

	mysql_stmt_close(Ordine);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(Ordine);
    err2:
	mysql_close(conn);
	return;
}
void dbOrdiniDaCucinare(prodotto ** Testa){

	if(!parse_config("users/Pizzaiolo.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *OrdiniDaPrepararePizzaiolo;

	if(!setup_prepared_stmt(&OrdiniDaPrepararePizzaiolo, "call OrdiniDaPrepararePizzaiolo()", conn)) {
		print_stmt_error(OrdiniDaPrepararePizzaiolo, "Unable to initialize OrdiniDaPrepararePizzaiolo\n");
		goto err2;
	}


	if (mysql_stmt_bind_param(OrdiniDaPrepararePizzaiolo, NULL) != 0) { // Note _param
		print_stmt_error(OrdiniDaPrepararePizzaiolo, "Could not bind parameters for login");
		goto err;
	}
	// Run procedure
	if (mysql_stmt_execute(OrdiniDaPrepararePizzaiolo) != 0) {
		print_stmt_error(OrdiniDaPrepararePizzaiolo, "Could not view Tavoli Liberi");
		goto err;
	}
	MYSQL_BIND param[5]; // Used both for input and output
	int id;
	char nome[16];
	char aggiunta[16];
	int quantita;
	int porzione;

	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &id;
	param[0].buffer_length = sizeof(id);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = nome;
	param[1].buffer_length = 16;

	param[2].buffer_type = MYSQL_TYPE_LONG; // IN
	param[2].buffer = &quantita;
	param[2].buffer_length = sizeof(quantita);

	bool controlloAggiunta;
	param[3].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[3].buffer = aggiunta;
	param[3].buffer_length = 16;
	param[3].is_null=&controlloAggiunta;
	
	param[4].buffer_type = MYSQL_TYPE_LONG; // IN
	param[4].buffer = &porzione;
	param[4].buffer_length = sizeof(porzione);
	
	if(mysql_stmt_bind_result(OrdiniDaPrepararePizzaiolo,param)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	if(mysql_stmt_store_result(OrdiniDaPrepararePizzaiolo)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	int j;
	prodotto * app=*Testa;
	while (!mysql_stmt_fetch(OrdiniDaPrepararePizzaiolo))
	{	
		if(app==NULL){
			app=malloc(sizeof(prodotto));
			app->next=NULL;
			strcpy(app->nome,nome);
			app->tipo=quantita;
			app->prezzo=id;
			j=id;
			app->listaIngredienti=NULL;
			if(!controlloAggiunta){
				app->listaIngredienti=malloc(sizeof(ingrediente));
				app->listaIngredienti->next=NULL;
				strcpy(app->listaIngredienti->nome,aggiunta);
				app->listaIngredienti->quantita=porzione;
			}
			*Testa=app;
			app=*Testa;
		}
		else{
			if(j==id){
				ingrediente *app2=app->listaIngredienti;
				while (app2->next!=NULL) app2=app2->next;
				app2->next=malloc(sizeof(ingrediente));
				app2=app2->next;
				app2->next=NULL;
				strcpy(app2->nome,aggiunta);
				app2->quantita=porzione;
			}
			else{
				app->next=malloc(sizeof(prodotto));
				app=app->next;
				app->next=NULL;
				strcpy(app->nome,nome);
				app->tipo=quantita;
				app->prezzo=id;
				j=id;
				app->listaIngredienti=NULL;
				if(!controlloAggiunta){
					app->listaIngredienti=malloc(sizeof(ingrediente));
					app->listaIngredienti->next=NULL;
					strcpy(app->listaIngredienti->nome,aggiunta);
					app->listaIngredienti->quantita=porzione;
				}
			}
		}
	}

	mysql_stmt_close(OrdiniDaPrepararePizzaiolo);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(OrdiniDaPrepararePizzaiolo);
    err2:
	mysql_close(conn);
	return;
}
void dbPizzaFinita(int i){

	if(!parse_config("users/Pizzaiolo.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *pizzaPreparata;

	if(!setup_prepared_stmt(&pizzaPreparata, "call pizzaPreparata(?)", conn)) {
		print_stmt_error(pizzaPreparata, "Unable to initialize pizzaPreparata\n");
		goto err2;
	}

	MYSQL_BIND param; // Used both for input and output
	memset(&param, 0, sizeof(param));
	param.buffer_type = MYSQL_TYPE_LONG; // IN
	param.buffer = &i;
	param.buffer_length = sizeof(i);


	if (mysql_stmt_bind_param(pizzaPreparata, &param) != 0) { // Note _param
		print_stmt_error(pizzaPreparata, "Could not bind parameters for login");
		goto err;
	}
	// Run procedure
	if (mysql_stmt_execute(pizzaPreparata) != 0) {
		print_stmt_error(pizzaPreparata, "Could not view Tavoli Liberi");
		goto err;
	}


	mysql_stmt_close(pizzaPreparata);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(pizzaPreparata);
    err2:
	mysql_close(conn);
	return;
}
void dbBevandeDaCucinare(prodotto ** Testa){

	if(!parse_config("users/Barista.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *BaristaOrdini;

	if(!setup_prepared_stmt(&BaristaOrdini, "call BaristaOrdini()", conn)) {
		print_stmt_error(BaristaOrdini, "Unable to initialize BaristaOrdini\n");
		goto err2;
	}


	if (mysql_stmt_bind_param(BaristaOrdini, NULL) != 0) { // Note _param
		print_stmt_error(BaristaOrdini, "Could not bind parameters for login");
		goto err;
	}
	// Run procedure
	if (mysql_stmt_execute(BaristaOrdini) != 0) {
		print_stmt_error(BaristaOrdini, "Could not view Tavoli Liberi");
		goto err;
	}
	MYSQL_BIND param[3]; // Used both for input and output
	int id;
	char nome[16];
	int quantita;

	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &id;
	param[0].buffer_length = sizeof(id);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = nome;
	param[1].buffer_length = 16;

	param[2].buffer_type = MYSQL_TYPE_LONG; // IN
	param[2].buffer = &quantita;
	param[2].buffer_length = sizeof(quantita);

	if(mysql_stmt_bind_result(BaristaOrdini,param)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	if(mysql_stmt_store_result(BaristaOrdini)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	prodotto * app=*Testa;
	while (!mysql_stmt_fetch(BaristaOrdini))
	{	
		if(app==NULL){
			app=malloc(sizeof(prodotto));
			app->next=NULL;
			strcpy(app->nome,nome);
			app->tipo=quantita;
			app->prezzo=id;
			app->listaIngredienti=NULL;
			*Testa=app;
			app=*Testa;
		}
		else{
				app->next=malloc(sizeof(prodotto));
				app=app->next;
				app->next=NULL;
				app->listaIngredienti=NULL;
				strcpy(app->nome,nome);
				app->tipo=quantita;
				app->prezzo=id;
			}
	}
	mysql_stmt_close(BaristaOrdini);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(BaristaOrdini);
    err2:
	mysql_close(conn);
	return;
}
void dbBevandaPronta(int i){

	if(!parse_config("users/Barista.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *BevandePronte;

	if(!setup_prepared_stmt(&BevandePronte, "call BevandePronte(?)", conn)) {
		print_stmt_error(BevandePronte, "Unable to initialize pizzaPreparata\n");
		goto err2;
	}

	MYSQL_BIND param; // Used both for input and output
	memset(&param, 0, sizeof(param));
	param.buffer_type = MYSQL_TYPE_LONG; // IN
	param.buffer = &i;
	param.buffer_length = sizeof(i);


	if (mysql_stmt_bind_param(BevandePronte, &param) != 0) { // Note _param
		print_stmt_error(BevandePronte, "Could not bind parameters for login");
		goto err;
	}
	// Run procedure
	if (mysql_stmt_execute(BevandePronte) != 0) {
		print_stmt_error(BevandePronte, "Could not view Tavoli Liberi");
		goto err;
	}


	mysql_stmt_close(BevandePronte);
	mysql_close(conn);
	return;

    err:
	mysql_stmt_close(BevandePronte);
    err2:
	mysql_close(conn);
	return;
}
void dbOrdiniDaConsegnare(ordini ** list,cameriere c){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *ordiniDaPortare;
	MYSQL_BIND param[2]; // Used both for input and output
	
	if(!setup_prepared_stmt(&ordiniDaPortare, "call ordiniDaPortare(?,?)", conn)) {
		print_stmt_error(ordiniDaPortare, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = &c.nome;
	param[0].buffer_length = strlen(c.nome);
	
	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = &c.cognome;
	param[1].buffer_length = strlen(c.cognome);
	if (mysql_stmt_bind_param(ordiniDaPortare, param) != 0) { // Note _param
		print_stmt_error(ordiniDaPortare, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(ordiniDaPortare) != 0) {
		print_stmt_error(ordiniDaPortare, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND res[3];
	int cl;
	MYSQL_TIME tid;
	int tavolo;

	memset(res, 0, sizeof(res));
	res[0].buffer_type= MYSQL_TYPE_LONG;
	res[0].buffer= &tavolo;
	res[0].buffer_length = sizeof(tavolo);
	
	res[1].buffer_type= MYSQL_TYPE_LONG;
	res[1].buffer= &cl;
	res[1].buffer_length = sizeof(cl);
	
	res[2].buffer_type= MYSQL_TYPE_TIMESTAMP;
	res[2].buffer= (char*)&tid;
	

	
	if(mysql_stmt_bind_result(ordiniDaPortare,res)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	
	if(mysql_stmt_store_result(ordiniDaPortare)!=0)
	{
        	printf("empty result\n");
			goto err2;
	}
	while (!mysql_stmt_fetch(ordiniDaPortare))
	{
			ordini* app=malloc(sizeof(ordini));
			app->next=NULL;
			app->cliente=cl;
			app->tavolo=tavolo;
			memcpy(&(app->t),&tid,sizeof(MYSQL_TIME));
			if(*list==NULL)
			{
				*list=app;
			}
			else{
				ordini* app2=*list;
				while(app2->next!=NULL) app2=app2->next;
				app2->next=app;
			}
		
	}

	mysql_stmt_close(ordiniDaPortare);
	mysql_close(conn);
	return ;

    err:
	mysql_stmt_close(ordiniDaPortare);
    err2:
	mysql_close(conn);
	return;
}
void dbUpdateComanda(ordini p){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
    }
	conn = mysql_init (NULL);
    if (conn == NULL) {
            fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
            exit(EXIT_FAILURE);
    } 
	if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }
	MYSQL_STMT *UpdateComandeConsegnate;
	MYSQL_BIND param[2]; // Used both for input and output
	if(!setup_prepared_stmt(&UpdateComandeConsegnate, "call UpdateComandeConsegnate(?,?)", conn)) {
		print_stmt_error(UpdateComandeConsegnate, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &p.cliente;
	param[0].buffer_length = sizeof(p.cliente);
	
	param[1].buffer_type = MYSQL_TYPE_DATETIME; // IN
	param[1].buffer = (char*)&p.t;
	
	if (mysql_stmt_bind_param(UpdateComandeConsegnate, param) != 0) { // Note _param
		print_stmt_error(UpdateComandeConsegnate, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(UpdateComandeConsegnate) != 0) {
		print_stmt_error(UpdateComandeConsegnate, "Could not view Tavoli Liberi");
		goto err;
	}

	mysql_stmt_close(UpdateComandeConsegnate);
	mysql_close(conn);
	return ;

    err:
	mysql_stmt_close(UpdateComandeConsegnate);
    err2:
	mysql_close(conn);
	return;
}
void dbStampaScontrino(prodotto **Lista,int *SpesaToT,int c){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *StampaScontrino;
	MYSQL_BIND param[2]; // Used both for input and output
	
	if(!setup_prepared_stmt(&StampaScontrino, "call StampaScontrino(?,?)", conn)) {
		print_stmt_error(StampaScontrino, "Unable to initialize login statement\n");
		goto err2;
	}
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &c;
	param[0].buffer_length = sizeof(c);
	
	param[1].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[1].buffer =SpesaToT;
	param[1].buffer_length = sizeof(*SpesaToT);

	if (mysql_stmt_bind_param(StampaScontrino, param) != 0) { // Note _param
		print_stmt_error(StampaScontrino, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(StampaScontrino) != 0) {
		print_stmt_error(StampaScontrino, "Could not view Tavoli Liberi");
		goto err;
	}
	MYSQL_BIND res[9];
	
	int ID;
	char NomeProdotto[16];
	int quantita;
	int prezzo;
	char aggiunta[16];
	int porzione;
	int costo;
	int CostoTotaleProdotto;

	memset(res, 0, sizeof(res));
	res[0].buffer_type= MYSQL_TYPE_LONG;
	res[0].buffer= &ID;
	res[0].buffer_length = sizeof(ID);
	
	res[1].buffer_type= MYSQL_TYPE_VAR_STRING;
	res[1].buffer= NomeProdotto;
	res[1].buffer_length = 15;
	
	res[2].buffer_type= MYSQL_TYPE_LONG;
	res[2].buffer= &quantita;
	res[2].buffer_length = sizeof(quantita);
	
	res[3].buffer_type= MYSQL_TYPE_LONG;
	res[3].buffer= &prezzo;
	res[3].buffer_length = sizeof(prezzo);

	bool controlloAggiunta;	
	res[4].buffer_type= MYSQL_TYPE_VAR_STRING;
	res[4].buffer= aggiunta;
	res[4].buffer_length = 15;
	res[4].is_null=&controlloAggiunta;

	res[5].buffer_type= MYSQL_TYPE_LONG;
	res[5].buffer= &porzione;
	res[5].buffer_length = sizeof(porzione);

	res[6].buffer_type= MYSQL_TYPE_LONG;
	res[6].buffer= &costo;
	res[6].buffer_length = sizeof(costo);

	res[7].buffer_type= MYSQL_TYPE_LONG;
	res[7].buffer= &CostoTotaleProdotto;
	res[7].buffer_length = sizeof(CostoTotaleProdotto);

	if(mysql_stmt_bind_result(StampaScontrino,res)!=0)
	{
        printf("empty result\n");
		goto err2;
	}
	if(mysql_stmt_store_result(StampaScontrino)!=0)
	{        	
		printf("empty result\n");
		goto err2;
	}
	int j;
	prodotto * app=*Lista;
	while (!mysql_stmt_fetch(StampaScontrino))
	{	
		if(app==NULL){
			app=malloc(sizeof(prodotto));
			app->next=NULL;
			strcpy(app->nome,NomeProdotto);
			app->quantita=quantita;
			app->prezzo=prezzo;
			app->CostoTotaleProdotto=CostoTotaleProdotto;
			j=ID;
			app->listaIngredienti=NULL;
			if(!controlloAggiunta){
				app->listaIngredienti=malloc(sizeof(ingrediente));
				app->listaIngredienti->next=NULL;
				strcpy(app->listaIngredienti->nome,aggiunta);
				app->listaIngredienti->quantita=porzione;
				app->listaIngredienti->costo=costo;
			}
			*Lista=app;
			app=*Lista;
		}
		else{
			if(j==ID){
				ingrediente *app2=app->listaIngredienti;
				while (app2->next!=NULL) app2=app2->next;
				app2->next=malloc(sizeof(ingrediente));
				app2=app2->next;
				app2->next=NULL;
				strcpy(app2->nome,aggiunta);
				app2->quantita=porzione;
				app2->costo=costo;
			}
			else{
				app->next=malloc(sizeof(prodotto));
				app=app->next;
				app->next=NULL;
				strcpy(app->nome,NomeProdotto);
				app->quantita=quantita;
				app->prezzo=prezzo;
				app->CostoTotaleProdotto=CostoTotaleProdotto;
				app->id=ID;
				j=ID;
				app->listaIngredienti=NULL;
				if(!controlloAggiunta){
					app->listaIngredienti=malloc(sizeof(ingrediente));
					app->listaIngredienti->next=NULL;
					app->listaIngredienti->costo=costo;
					strcpy(app->listaIngredienti->nome,aggiunta);
					app->listaIngredienti->quantita=porzione;
				}
			}
		}
	}
	if(mysql_stmt_next_result(StampaScontrino)>0){
		printf("Error\n");
		goto err;
	}
	MYSQL_BIND res1;
	memset(&res1, 0, sizeof(res1));
	res1.buffer_type= MYSQL_TYPE_LONG;
	res1.buffer= SpesaToT;
	res1.buffer_length = sizeof(*SpesaToT);

	if(mysql_stmt_bind_result(StampaScontrino,&res1)!=0)
	{
        printf("empty result1\n");
		goto err2;
	}
	if(mysql_stmt_store_result(StampaScontrino)!=0)
	{        	
		printf("empty result2\n");
		goto err2;
	}
	
	if(mysql_stmt_fetch(StampaScontrino)){
		*SpesaToT=0;
		goto err;
	}
	mysql_stmt_close(StampaScontrino);
	mysql_close(conn);
	return ;
    err:
	mysql_stmt_close(StampaScontrino);
    err2:
	mysql_close(conn);
	return ;	
}
int dbIncassoGiorno(int i){
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *IncassiGiornalieri;
	MYSQL_BIND param[2]; // Used both for input and output
	
	if(!setup_prepared_stmt(&IncassiGiornalieri, "call IncassiGiornalieri(?,?)", conn)) {
		print_stmt_error(IncassiGiornalieri, "Unable to initialize login statement\n");
		goto err2;
	}
	int j=0;
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &i;
	param[0].buffer_length = sizeof(i);
	
	param[1].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[1].buffer =&j;
	param[1].buffer_length = sizeof(j);

	if (mysql_stmt_bind_param(IncassiGiornalieri, param) != 0) { // Note _param
		print_stmt_error(IncassiGiornalieri, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(IncassiGiornalieri) != 0) {
		print_stmt_error(IncassiGiornalieri, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND res1;
	memset(&res1, 0, sizeof(res1));
	res1.buffer_type= MYSQL_TYPE_LONG;
	res1.buffer= &j;
	res1.buffer_length = sizeof(j);

	if(mysql_stmt_bind_result(IncassiGiornalieri,&res1)!=0)
	{
        printf("empty result1\n");
		goto err2;
	}
	if(mysql_stmt_store_result(IncassiGiornalieri)!=0)
	{        	
		printf("empty result2\n");
		goto err2;
	}
	
	if(mysql_stmt_fetch(IncassiGiornalieri)){

		goto err;
	}
	mysql_stmt_close(IncassiGiornalieri);
	mysql_close(conn);
	return j;
    err:
	mysql_stmt_close(IncassiGiornalieri);
    err2:
	mysql_close(conn);
	return 0;	
}
int dbIncassoMese(int i){	
	if(!parse_config("users/Manager.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        } 
	  if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }

	MYSQL_STMT *IncassiMensili;
	MYSQL_BIND param[2]; // Used both for input and output
	
	if(!setup_prepared_stmt(&IncassiMensili, "call IncassiMensili(?,?)", conn)) {
		print_stmt_error(IncassiMensili, "Unable to initialize login statement\n");
		goto err2;
	}
	int j=0;
	memset(param, 0, sizeof(param));
	param[0].buffer_type = MYSQL_TYPE_LONG; // IN
	param[0].buffer = &i;
	param[0].buffer_length = sizeof(i);
	
	param[1].buffer_type = MYSQL_TYPE_LONG; // OUT
	param[1].buffer =&j;
	param[1].buffer_length = sizeof(j);

	if (mysql_stmt_bind_param(IncassiMensili, param) != 0) { // Note _param
		print_stmt_error(IncassiMensili, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(IncassiMensili) != 0) {
		print_stmt_error(IncassiMensili, "Could not view Tavoli Liberi");
		goto err;
	}

	MYSQL_BIND res1;
	memset(&res1, 0, sizeof(res1));
	res1.buffer_type= MYSQL_TYPE_LONG;
	res1.buffer= &j;
	res1.buffer_length = sizeof(j);

	if(mysql_stmt_bind_result(IncassiMensili,&res1)!=0)
	{
        printf("empty result1\n");
		goto err2;
	}
	if(mysql_stmt_store_result(IncassiMensili)!=0)
	{        	
		printf("empty result2\n");
		goto err2;
	}
	
	if(mysql_stmt_fetch(IncassiMensili)){
		printf("empty result2\n");
		goto err;
	}
	mysql_stmt_close(IncassiMensili);
	mysql_close(conn);
	return j;
    err:
	mysql_stmt_close(IncassiMensili);
    err2:
	mysql_close(conn);
	return 0;	
}
int dbVerificaCameriere(cameriere c){
	if(!parse_config("users/Cameriere.json", &conf)) {
                fprintf(stderr, "Unable to load login configuration\n");
                exit(EXIT_FAILURE);
        }
	conn = mysql_init (NULL);
        if (conn == NULL) {
                fprintf (stderr, "mysql_init() failed (probably out of memory)\n");
                exit(EXIT_FAILURE);
        }

        if (mysql_real_connect(conn, conf.host, conf.db_username, conf.db_password, conf.database, conf.port, NULL, CLIENT_MULTI_STATEMENTS | CLIENT_MULTI_RESULTS) == NULL) {
                fprintf (stderr, "mysql_real_connect() failed\n");
                mysql_close (conn);
                exit(EXIT_FAILURE);
        }


	MYSQL_STMT *VerificaCameriere;
	MYSQL_BIND param[2]; // Used both for input and output
	
	if(!setup_prepared_stmt(&VerificaCameriere, "call VerificaCameriere(?, ?)", conn)) {
		print_stmt_error(VerificaCameriere, "Unable to initialize login statement\n");
		goto err2;
	}

	// Prepare parameters
	memset(param, 0, sizeof(param));
	
	param[0].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[0].buffer = c.nome;
	param[0].buffer_length = strlen(c.nome);

	param[1].buffer_type = MYSQL_TYPE_VAR_STRING; // IN
	param[1].buffer = c.cognome;
	param[1].buffer_length = strlen(c.cognome);


	if (mysql_stmt_bind_param(VerificaCameriere, param) != 0) { // Note _param
		print_stmt_error(VerificaCameriere, "Could not bind parameters for login");
		goto err;
	}

	// Run procedure
	if (mysql_stmt_execute(VerificaCameriere) != 0) {
		print_stmt_error(VerificaCameriere, "Could not execute login");
		goto err;
	}

	mysql_stmt_close(VerificaCameriere);
	mysql_close(conn);
	return 1;

    err:
	mysql_stmt_close(VerificaCameriere);
	mysql_close(conn);
    err2:
	return 0;
}
