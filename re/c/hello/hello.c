#include <stdio.h>
#include <stdlib.h>

int main()
{
    if (puts("hello world!") == EOF)
    {
        return EXIT_FAILURE;
    };
    // printf("%s\n", "hello world!");
    // investigate what printf returns
    return EXIT_SUCCESS;
}