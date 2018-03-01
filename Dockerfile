FROM  ubuntu:14.04

#COPY ./sources.list /etc/apt/sources.list
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:vbernat/haproxy-1.8 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends haproxy=1.8.\* \
	                   rsyslog \
					   vim \
    && rm -rf /var/lib/apt/lists/* \
	&& ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
