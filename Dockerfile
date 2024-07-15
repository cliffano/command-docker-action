ARG IMAGE=alpine:3.20
FROM ${IMAGE}
COPY entrypoint.sh /entrypoint.sh
RUN ls -al
RUN pwd
RUN ls -al /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]