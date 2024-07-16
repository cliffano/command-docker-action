ARG IMAGE=alpine:3.20
ARG SHELL=sh
FROM ${IMAGE}
COPY entrypoint-${SHELL}.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]