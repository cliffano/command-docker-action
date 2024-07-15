ARG IMAGE=alpine:3.20
FROM ${IMAGE}
COPY entrypoint.sh /entrypoint.sh
RUN ls -al
ENTRYPOINT ["/entrypoint.sh"]