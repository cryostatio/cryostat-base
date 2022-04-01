ARG BASE_IMAGE=registry.access.redhat.com/ubi8/openjdk-11-runtime
# 1.11-2.1648459559
ARG IMAGE_TAG=@sha256:64acf3403b5c2c85f7a28f326c63f1312b568db059c66d90b34e3c59fde3a74b
FROM ${BASE_IMAGE}${IMAGE_TAG}

USER root

RUN microdnf --disableplugin=subscription-manager -y install findutils && \
    microdnf --disableplugin=subscription-manager -y clean all

USER 185

ENV CONF_DIR=/opt/cryostat.d

RUN mkdir -p $CONF_DIR

ENV SSL_TRUSTSTORE=$CONF_DIR/truststore.p12 \
    SSL_TRUSTSTORE_PASS_FILE=$CONF_DIR/truststore.pass

COPY include $CONF_DIR

RUN $CONF_DIR/truststore-setup.sh

USER root
RUN chmod -R g=u $CONF_DIR

USER 185
