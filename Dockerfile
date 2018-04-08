FROM lsiobase/alpine.armhf:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ironicbadger,sparklyballs"

# copy tcpping script
COPY tcpping /defaults/

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache \
	apache2 \
	apache2-ctl \
	apache2-utils \
	curl \
	smokeping \
	ssmtp \
	sudo \
	tcptraceroute \
	ttf-dejavu && \
 echo "**** give abc sudo access to traceroute & tcptraceroute ****" && \
 echo \
 "abc ALL=(ALL) NOPASSWD: /usr/bin/traceroute" >> \
	/etc/sudoers.d/traceroute && \
 echo \
 "abc ALL=(ALL) NOPASSWD: /usr/bin/tcptraceroute" >> \
	/etc/sudoers.d/tcptraceroute && \
 echo "**** fix path to cropper.js ****" && \
 sed -i 's#src="/cropper/#/src="cropper/#' /etc/smokeping/basepage.html && \
 echo "**** install tcping script ****" && \
 install -m755 -D /defaults/tcpping /usr/bin/ && \
 echo "**** remove default apache conf ****" && \
 rm -f /etc/apache2/httpd.conf

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
