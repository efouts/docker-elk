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

ADD	supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME	/data
VOLUME	/logstash/conf.d
VOLUME	/var/log/supervisor

EXPOSE  5601
EXPOSE 	9200
EXPOSE 	9300 

CMD     ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
