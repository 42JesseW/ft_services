FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

ARG GRAFANA_VERSION=7.3.4
ENV PATH=/usr/share/grafana/bin:${PATH}
ENV GF_PATHS_PROVISIONING=/etc/grafana/provisioning
# TODO Use ENV to overwrite defaults in .ini file

# install needed packages
# - "grafana-server: not found" issue fixed with libc6-compat
RUN apk update \
	&& apk add --no-cache \
		libc6-compat \
		vim

# download and install grafana
RUN wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
	&& tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
	&& rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
	&& mv grafana-${GRAFANA_VERSION} /usr/share/grafana

# create grafana system group and user
RUN addgroup -S grafana \
	&& adduser -S grafana -G grafana

# TODO change ownership of log/plugin/provisioning directories to grafana user
ENTRYPOINT grafana-server \
			--homepath=/usr/share/grafana \
			--config=/usr/share/grafana/conf/defaults.ini \
			--packaging=docker

EXPOSE 3000
