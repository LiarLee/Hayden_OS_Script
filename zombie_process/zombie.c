#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int i = 100;
  pid_t pid=fork();
  if(pid < 0)
  {
    perror("fork failed.");
    exit(1);
  }
  if(pid > 0)
  {
    printf("This is the parent process. My PID is %d.\n", getpid());
    for(; i > 0; i--)
    {
      sleep(1);
    }
  }
  else if(pid == 0)
  {
    printf("This is the child process. My PID is: %d. My PPID is: %d.\n", getpid(), getppid());
  }
  return 0;
}
