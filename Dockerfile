ARG IMAGE=alpine:3.20
FROM ${IMAGE}
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]