ARG IMAGE=alpine:3.20
FROM ${IMAGE}
CMD mkdir -p /opt/workspace/
WORKDIR /opt/workspace/
ARG SHELL=sh
COPY entrypoint-${SHELL}.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]