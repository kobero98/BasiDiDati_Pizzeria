#include "../util/defines.h"
#include "../View/loginView.h"
#include "controllerLogin.h"
#include "../model/db.h"

ruolo login()
{	
	ruolo r;
	credenziali cred;
	loginView(&cred);
	r=dblogin(cred);
	return r;
}
