FROM alpine:3.17.3

ARG DATE_CREATED
ENV WEBUI_VERSION 0.4.0
ENV WEBUI_URL https://github.com/jpillora/webproc/releases/download/v${WEBUI_VERSION}/webproc_${WEBUI_VERSION}_linux_amd64.gz

LABEL maintainer="Arash Hatami <hatamiarash7@gmail.com>"
LABEL org.opencontainers.image.created=$DATE_CREATED
LABEL org.opencontainers.image.authors="hatamiarash7"
LABEL org.opencontainers.image.vendor="hatamiarash7"
LABEL org.opencontainers.image.title="Dnsmasq"
LABEL org.opencontainers.image.description="Deploy dnsmasq using Docker"
LABEL org.opencontainers.image.source="https://github.com/hatamiarash7/Docker-dnsmasq"

RUN apk update \
	&& apk --no-cache add dnsmasq \
	&& apk add --no-cache --virtual .build-deps curl \
	&& curl -sL ${WEBUI_URL} | gzip -d - > /usr/local/bin/webproc \
	&& chmod +x /usr/local/bin/webproc \
	&& apk del .build-deps

RUN mkdir -p /etc/default/

RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq

COPY dnsmasq.conf /etc/dnsmasq.conf

ENTRYPOINT ["webproc", "-c", "/etc/dnsmasq.conf", "-l", "both", "--", "dnsmasq", "--no-daemon"]