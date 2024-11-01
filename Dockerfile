ARG IMAGE=alpine:3.20
FROM ${IMAGE}
CMD mkdir -p /opt/workspace/
WORKDIR /opt/workspace/
ARG PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV PATH="${PATH}"
ARG SHELL=sh
COPY entrypoint-${SHELL}.sh /opt/entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]