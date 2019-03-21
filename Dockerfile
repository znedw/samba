FROM alpine:edge

RUN apk add --update \
    samba-common-tools \
    samba-client \
    samba-server \
    && rm -rf /var/cache/apk/*

COPY samba.sh /usr/bin/

EXPOSE 445/tcp

ENTRYPOINT ["/bin/sh", "--", "/usr/bin/samba.sh"]
