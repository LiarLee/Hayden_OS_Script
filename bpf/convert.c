#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>

void main()
{
   //  char buf[20] = { 0 };
   //  inet_ntop(AF_INET, "167773121", buf, sizeof(buf));
   //  printf("%s\n",buf);

    // IPv4 demo of inet_ntop() and inet_pton()
    
    struct sockaddr_in sa;
    char str[INET_ADDRSTRLEN];
    
    // store this IP address in sa:
    inet_pton(AF_INET, "192.0.2.33", &(sa.sin_addr));
    
    // now get it back and print it
    inet_ntop(AF_INET, "167773121" , str, INET_ADDRSTRLEN);
    
    printf("%s\n", str); // prints "192.0.2.33"
}
