#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 
#include <signal.h>
#include <unistd.h>
 
#define SIGTERM_MSG "SIGTERM received.\n"
 
// Catch C-c Signal, sig_term_handler
void sig_term_handler(int signum, siginfo_t *info, void *ptr)
{
    write(STDERR_FILENO, SIGTERM_MSG, sizeof(SIGTERM_MSG));
}
 
void catch_sigterm()
{
    static struct sigaction _sigact;
 
    memset(&_sigact, 0, sizeof(_sigact));
    _sigact.sa_sigaction = sig_term_handler;
    _sigact.sa_flags = SA_SIGINFO;
 
    sigaction(SIGTERM, &_sigact, NULL);
}

// main entry
int main(int argc, char *argv[])
{
    // check input 2 args, if not 2, exit 1;
    if ( argc != 2 )
    {
        printf("ERROR ELEMENT COUNTS.");
        return 1;
    }

    // define var, and convert to int.
    int *p;
    long n = atol(argv[1]) * 1024 * 1024;

    // print memory size. 
    printf("Allocate Memory Size: %ld MB.\n", atol(argv[1]));
    
    // Allocate Memory  - call userspace malloc function.
    p = (int *)malloc(n);
    
    // printf output result.
    if (p != NULL)
        printf("SUCCESS.");
    else
        printf("FAILED.");

    // set 0 to all memory address.
    memset(p, 0, n);

    // catch_sigterm and sleep.
    catch_sigterm();
    
    // while(true); sleep(99999);
    pause();
    // free memory. 
    free(p);

    return 0;
}

