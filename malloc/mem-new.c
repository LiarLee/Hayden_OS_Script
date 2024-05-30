#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <signal.h>
#include <unistd.h>

#define SIGTERM_MSG "SIGTERM received.\n"

void sig_term_handler(int signum, siginfo_t *info, void *ptr)
{
    // Use a safe function in signal handler
    static const char msg[] = SIGTERM_MSG;
    write(STDERR_FILENO, msg, sizeof(msg) - 1);
}

void catch_sigterm()
{
    struct sigaction _sigact = {0};

    _sigact.sa_sigaction = sig_term_handler;
    _sigact.sa_flags = SA_SIGINFO;

    sigaction(SIGTERM, &_sigact, NULL);
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <memory size in MB>\n", argv[0]);
        return 1;
    }

    long size_mb = atol(argv[1]);
    if (size_mb <= 0)
    {
        fprintf(stderr, "Invalid memory size: %ld\n", size_mb);
        return 1;
    }

    printf("Allocate Memory Size: %ld MB.\n", size_mb);

    size_t n = size_mb * 1024 * 1024;
    int *p = (int *)malloc(n);
    if (p == NULL)
    {
        perror("Memory allocation failed");
        return 1;
    }

    printf("SUCCESS.\n");

    // Correctly initialize allocated memory to 'a'
    memset(p, 'a', n);

    catch_sigterm();
    pause();

    free(p);

    return 0;
}

