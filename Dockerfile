FROM $DOCKER_IMAGE
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]