FROM haproxy:1.8.4

RUN apt-get update \
    &&apt-get install -y --no-install-recommends \
		rsyslog \
	&& rm -rf /var/lib/apt/lists/* \
	&& ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
