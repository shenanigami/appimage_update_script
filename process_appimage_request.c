#include<unistd.h>
#include<string.h>
#include<stdio.h>
#include "jansson/jansson.h"

typedef enum {
	
	SUCCESS,
	ERROR_LOADING_JSON,
	FILE_NOT_FOUND

} error_t;

// TODO add entry
int add_appimage_entry(char * appimage_name);
int load_json_obj(void);
// TODO get json hash table
// TODO remove entry

static json_t* appimage_table; 
const char* appimage_table_pathname = "./appimage_table_file.txt";

int main(int argc, char* argv[]) {

	// TODO error handling later
	printf("Hello world!\n");
	
	// the adding new program case
	if (argc == 3) {
		if (strcmp(argv[1], "add") == 0) {
			char * program_name = argv[2];
			// TODO create json object and append to file
			// TODO need to check if already exists

		}

	}

	return 0;

}

int add_appimage_entry(char * appimage_name) {


	// TODO: Make this better
	if (load_json_obj() != 0) {
		printf("Hello World!\n");

	}

	return 0;

}

int load_json_obj(void) {

	FILE *fp;
	// check if file exists
	if (access(appimage_table_pathname, F_OK) == 0) {
		fp = fopen(appimage_table_pathname, "r");
		json_error_t err;
		appimage_table = json_loadf(fp, JSON_REJECT_DUPLICATES, &err); 

		// TODO: check if success
		if (!appimage_table) {
			printf("Error: %s\n", err.text);
			return -1;
		}
		
	} else {
		return FILE_NOT_FOUND;
	}
	return 0;
}
