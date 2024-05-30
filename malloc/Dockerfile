FROM reg.liarlee.site/docker.io/alpine

RUN apk add build-base

COPY mem.c .

RUN gcc -static -o mem mem.c


FROM alpine

COPY --from=0 ./mem .

ENTRYPOINT [ "/mem" ]

