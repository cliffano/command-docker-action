ARG DOCKER_IMAGE=alpine:3.12
FROM ${DOCKER_IMAGE}
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]