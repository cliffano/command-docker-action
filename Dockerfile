ARG IMAGE=alpine:3.20
ARG BASE_DIR=.
FROM ${IMAGE}
COPY ${BASE_DIR}/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]