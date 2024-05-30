FROM reg.liarlee.site/docker.io/ubuntu:latest

COPY ./sigsegv /usr/bin/sigsegv

RUN chmod 755 /usr/bin/sigsegv

ENTRYPOINT [ "/usr/bin/sigsegv" ]
