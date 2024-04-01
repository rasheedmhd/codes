
#include <stdio.h> // printf

int main(int argc, char **argv) {
    for (int i = 0; i < argc; i++) {
        char *arg = argv[i];
        // we don't know where to stop, so let's just print 15 characters.
        for (int j = 0; j < 15; j++) {
            char character = arg[j];
            // the %c specifier is for characters
            printf("%c", character);
        }
        printf("\n");
    }

    return 0;
}