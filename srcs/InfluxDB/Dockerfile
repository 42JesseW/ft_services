FROM alpine:3.10

LABEL maintainer="Codam 42 jevan-de@student.codam.nl"

RUN apk update \
	&& apk add --no-cache \
		influxdb

ENTRYPOINT influxd run

# https://docs.influxdata.com/influxdb/v1.8/administration/ports/
EXPOSE 8086 8088
