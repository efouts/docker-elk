FROM	ubuntu:14.04

ENV     DEBIAN_FRONTEND noninteractive
ENV	JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN	apt-get update && \
	apt-get install -y openjdk-7-jre-headless supervisor wget

ENV	ES_PKG_NAME elasticsearch-1.5.2

RUN	wget -q https://download.elastic.co/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
	tar -xzf $ES_PKG_NAME.tar.gz && \
	rm -f $ES_PKG_NAME.tar.gz && \
	mv $ES_PKG_NAME /elasticsearch

ADD	elasticsearch.yml /elasticsearch/config/elasticsearch.yml

ENV	KIBANA_PKG_NAME kibana-4.0.2-linux-x64

RUN	wget -q https://download.elastic.co/kibana/kibana/$KIBANA_PKG_NAME.tar.gz && \
	tar -xzf $KIBANA_PKG_NAME.tar.gz && \
	rm -rf $KIBANA_PKG_NAME.tar.gz && \
	mv $KIBANA_PKG_NAME /kibana

ENV	LOGSTASH_PKG_NAME logstash-1.5.0

RUN	wget -q https://download.elastic.co/logstash/logstash/$LOGSTASH_PKG_NAME.tar.gz && \
	tar -xzf $LOGSTASH_PKG_NAME.tar.gz && \
	rm -f $LOGSTASH_PKG_NAME.tar.gz && \
	mv $LOGSTASH_PKG_NAME /logstash

RUN     wget -q http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
	gunzip GeoLiteCity.dat.gz && \
        mv GeoLiteCity.dat /logstash/GeoLiteCity.dat

ENV	OAUTH2_PROXY_PKG_NAME oauth2_proxy-2.0.linux-amd64.go1.4.2

RUN	wget -q https://github.com/bitly/oauth2_proxy/releases/download/v2.0/$OAUTH2_PROXY_PKG_NAME.tar.gz && \
	tar -xzf $OAUTH2_PROXY_PKG_NAME.tar.gz && \
	rm -f $OAUTH2_PROXY_PKG_NAME.tar.gz && \
	mv $OAUTH2_PROXY_PKG_NAME /oauth2_proxy

ADD	oauth2_proxy.cfg /oauth2_proxy/oauth2_proxy.cfg

ADD	supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME	/data
VOLUME	/logstash/conf.d
VOLUME	/var/log/supervisor

EXPOSE  8000
EXPOSE 	9200
EXPOSE 	9300 

CMD     ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
