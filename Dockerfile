FROM openjdk:8-jre-alpine

LABEL maintainer="gentlehoneylover"

ENV LD_LIBRARY_PATH /usr/lib
ENV APPLICATION_USER=ktor
ENV JAR_URL https://www.worldcubeassociation.org/regulations/scrambles/tnoodle/TNoodle-WCA-1.1.2.jar 

RUN \
	echo "**** Install dependencies ****" && \
	apk add --no-cache fontconfig ttf-dejavu && \
	echo "**** Create necessary symlinks ****" && \
	ln -s /usr/lib/libfontconfig.so.1 /usr/lib/libfontconfig.so && \
	ln -s /lib/libuuid.so.1 /usr/lib/libuuid.so.1 && \
	ln -s /lib/libc.musl-x86_64.so.1 /usr/lib/libc.musl-x86_64.so.1 && \
	echo "**** Create user and take folder ownership ****" && \
	adduser -D -g '' $APPLICATION_USER && \
	mkdir /app && \
	chown -R $APPLICATION_USER /app && \
	echo "**** Fetch the app .jar file ****" && \
	wget -O /app/tnoodle-application.jar "$JAR_URL" && \
	echo "**** Cleanup ****" && \
	rm -rf \
		$HOME/.cache \
		/tmp/*

USER $APPLICATION_USER
WORKDIR /app
CMD java -server -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:InitialRAMFraction=2 -XX:MinRAMFraction=2 -XX:MaxRAMFraction=2 -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+UseStringDeduplication -jar tnoodle-application.jar --online