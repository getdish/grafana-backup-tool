FROM alpine:latest

LABEL maintainer="ysde108@gmail.com"

ENV RESTORE false
ENV ARCHIVE_FILE ""

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk --no-cache add python3 py3-pip py3-cffi py3-cryptography ca-certificates bash

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing s3cmd

WORKDIR /opt/grafana-backup-tool
ADD . /opt/grafana-backup-tool

RUN pip3 --no-cache-dir install .

RUN chown -R 1337:1337 /opt/grafana-backup-tool
USER 1337
CMD sh -c 'if [ "$RESTORE" = true ]; then if [ ! -z "$AWS_S3_BUCKET_NAME" ]; then grafana-backup restore $ARCHIVE_FILE; else grafana-backup restore _OUTPUT_/$ARCHIVE_FILE; fi else grafana-backup save; fi'
