#include <string.h>
#include <stdio.h>

#define PATH_MAX 100

int main(int argc, char** argv) {
    int i;
    char* prefix = argv[1];
    char* path = argv[2];

    char datadir_path_buffer[PATH_MAX];

    if (argc != 3)
        return 1;

    strncpy(datadir_path_buffer, prefix, PATH_MAX);
    datadir_path_buffer[PATH_MAX-1] = '\0';
    strncat(datadir_path_buffer, path, PATH_MAX-strlen(datadir_path_buffer)-1);


/*        snprintf(datadir_path_buffer, PATH_MAX, "%s%s", prefix, path); */

    printf("%s\n", datadir_path_buffer);

    return 0;
}
