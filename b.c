#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <time.h>
#include <string.h>

int main(int argc, char *argv[])
{
    int x = 2;
    printf("%d, %d, the x value is : %d \n", getpid(), time(NULL), x);

    int rc = fork();

    if (rc < 0 ) {
        fprintf(stderr, "fork failed. \n");
        exit (1);
    } else if ( rc == 0 ) {
        char *myargs[3];
        myargs[0] = strdup("cat"); // program: "wc" (word count)
        myargs[1] = strdup("/etc/hosts"); // program: "wc" (word count)
        myargs[2] = NULL; // marks end of array
        execvp(myargs[0], myargs); // runs word count
    } else {
        printf("%d, %d,done. \n", getpid(), time(NULL) );
    }

    return 0;
}
