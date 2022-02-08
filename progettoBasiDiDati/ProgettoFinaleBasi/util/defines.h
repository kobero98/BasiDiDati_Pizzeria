#pragma once

#include <stdbool.h>
#include <mysql.h>



struct configuration {
	char *host;
	char *db_username;
	char *db_password;
	unsigned int port;
	char *database;

	char username[128];
	char password[128];
};

typedef bool my_bool;


typedef enum {
	BARISTA=1,
	MANAGER=2,
	PIZZAIOLO=3,
	CAMERIERE=4,
	FAILED_LOGIN=5
}ruolo;
#define USERLENGTH 45
#define PASSLENGTH 45
typedef struct credential{
	char username[USERLENGTH];
	char password[PASSLENGTH];
}credenziali;
typedef struct Ordini{
	int cliente;
	int tavolo;
	MYSQL_TIME t;
	struct Ordini * next;
}ordini;
typedef struct ingrediente{
	char nome[16];
	int quantita;
	int costo;
	struct ingrediente * next;
}ingrediente;

typedef struct prodotto{
	int id;
	char nome[16];
	int prezzo;
	int tipo;
	int quantita;
	int CostoTotaleProdotto;
	ingrediente * listaIngredienti;
	struct prodotto* next;
}prodotto;

#define NOMELENGTH 15
#define COGNOMELENGTH 15

typedef struct cameriere{
	char nome[NOMELENGTH];
	char cognome[COGNOMELENGTH];
	struct cameriere * next;
}cameriere;

typedef struct Turno{
	MYSQL_TIME tempo;
	MYSQL_TIME oraFine;
	struct Turno * next;
}turno;

typedef struct Cliente{
	char nome[NOMELENGTH];
	char cognome[COGNOMELENGTH];
	int N_Persone;
	int Tavolo;
	MYSQL_TIME Turno;
}cliente;

typedef struct Tavolo{
	int N_Tavolo;
	MYSQL_TIME turno;
	struct Tavolo *next;
}Tavolo;

extern struct configuration conf;

extern int parse_config(char *path, struct configuration *conf);
extern char *getInput(unsigned int lung, char *stringa, bool hide);
extern bool yesOrNo(char *domanda, char yes, char no, bool predef, bool insensitive);
extern char multiChoice(char *domanda, char choices[], int num);
extern void print_error (MYSQL *conn, char *message);
extern void print_stmt_error (MYSQL_STMT *stmt, char *message);
extern void finish_with_error(MYSQL *conn, char *message);
extern void finish_with_stmt_error(MYSQL *conn, MYSQL_STMT *stmt, char *message, bool close_stmt);
extern bool setup_prepared_stmt(MYSQL_STMT **stmt, char *statement, MYSQL *conn);
extern void dump_result_set(MYSQL *conn, MYSQL_STMT *stmt, char *title);


