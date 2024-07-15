ARG IMAGE=alpine:3.20
FROM ${IMAGE}
ENTRYPOINT ["/entrypoint.sh"]