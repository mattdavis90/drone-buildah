FROM quay.io/buildah/stable:latest
COPY build.sh /build.sh
CMD ["/build.sh"]
