#include <stdio.h>
#include "util/defines.h"
#include "controller/controllerLogin.h"
#include "controller/controllerManager.h"
#include "controller/controllerCameriere.h"     
#include "controller/controllerPizzaiolo.h"
#include "controller/controllerBarista.h"

int main(void)
{
        do{
                ruolo c = login();
                switch(c) {
                        case CAMERIERE:
                                run_as_cameriere();
                                break;

                        case MANAGER:
                                run_Manager();
                                break;

                        case BARISTA:
                                run_barista();
                                break;
                        case PIZZAIOLO:
                                run_pizzaiolo();
                                break;
                        
                        case FAILED_LOGIN:
                                fprintf(stderr, "Invalid credentials\n");
                                exit(EXIT_FAILURE);
                                break;
                        default:
                                fprintf(stderr, "Invalid condition at %s:%d\n", __FILE__, __LINE__);
                                abort();
                        }
        }while(1);
}
