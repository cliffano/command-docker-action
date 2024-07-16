ARG IMAGE=alpine:3.20
FROM ${IMAGE}
ARG SHELL=sh
COPY entrypoint-${SHELL}.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]