cmake_minimum_required(VERSION 1.3)
project(client C)

set(CMAKE_C_STANDARD 11)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
find_package(MySQL REQUIRED)

add_executable(client
        main.c
	controller/controllerPizzaiolo.c 
	controller/controllerManager.c	
	controller/controllerLogin.c
	controller/controllerBarista.c 
	controller/controllerCameriere.c 
	model/db.c
	util/inout.c 
	util/parse.c 	
	util/utils.c 
	View/baristaView.c 
	View/cameriereView.c
	View/loginView.c
	View/managerView.c 
	View/pizzaioloView.c 
)

include_directories(${MYSQL_INCLUDE_DIR})
target_link_libraries(client ${MYSQL_LIBRARIES})
if(MSVC)
	add_compile_options(PRIVATE /W4 /WX)
else()
	add_compile_options(PRIVATE -Wall -Wpedantic -Wpedantic -Werror)
endif()
