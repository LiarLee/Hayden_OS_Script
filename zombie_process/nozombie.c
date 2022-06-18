#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  pid_t pid;
  pid = fork();
  if (pid < 0)
  {
    perror("fork failed");
    exit(1);
  }
  if (pid == 0) {
    int i;
     for (i = 3; i > 0; i--)
     {
      printf("This is the child\n");
      sleep(1);
     }
     // exit with code 3 for test.
    exit(3);
  }
  else
  {
    int stat_val;
    wait(&stat_val);
     if (WIFEXITED(stat_val))
     {
       printf("Child exited with code %d\n", WEXITSTATUS(stat_val));
     }      
  }
  return 0;
}
