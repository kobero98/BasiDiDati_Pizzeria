#include "../util/defines.h"
#include "loginView.h"
#include <stdio.h>
void loginView(credenziali * cred){
	
	system("clear");	
	printf("#########################################\n");
	printf("##                                     ##\n");	
	printf("##                                     ##\n");  
        printf("##        LOGIN     PIZZERIA           ##\n");  
        printf("##                                     ##\n");  
        printf("##                                     ##\n");  
        printf("#########################################\n");  
	printf("Username: ");
        getInput(128, cred->username, false);
        printf("Password: ");
        getInput(128, cred->password, true);
}
