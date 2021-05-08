FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG TELEGRAF_VERSION=1.17.0
ENV PATH=/usr/share/telegraf/usr/bin:${PATH}
ENV TELEGRAF_CONFIG_PATH=/usr/share/telegraf/etc/telegraf/telegraf.conf

# download and install telegraf
# - https://github.com/influxdata/telegraf/releases
RUN apk update \
	&& apk add --no-cache \
		libc6-compat \
		wget \
		vim \
	&& wget https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}~rc1_static_linux_amd64.tar.gz \
	&& tar xf telegraf-${TELEGRAF_VERSION}~rc1_static_linux_amd64.tar.gz \
	&& mv telegraf-${TELEGRAF_VERSION} /usr/share/telegraf \
	&& rm telegraf-${TELEGRAF_VERSION}~rc1_static_linux_amd64.tar.gz

ENTRYPOINT telegraf --config /etc/telegraf/telegraf.conf

# https://hub.docker.com/_/telegraf
EXPOSE 8094 8092
