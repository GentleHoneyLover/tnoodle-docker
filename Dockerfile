# FROM amazoncorretto:8-alpine3.18-jre
# FROM eclipse-temurin:22-jre-alpine
FROM bellsoft/liberica-openjre-alpine:11

LABEL maintainer="gentlehoneylover"

ENV JAR_VER 1.2.2
ENV JAR_URL https://github.com/thewca/tnoodle/releases/download/v$JAR_VER/TNoodle-WCA-$JAR_VER.jar
ENV LD_LIBRARY_PATH /usr/lib
ENV APPLICATION_USER=wca
ENV PORT=${PORT:-2014}

RUN \
	echo "**** Install dependencies ****" && \
	apk add --no-cache fontconfig ttf-dejavu && \
	echo "**** Create necessary lib symlinks ****" && \
	ln -s /usr/lib/libfontconfig.so.1 $LD_LIBRARY_PATH/libfontconfig.so && \
	ln -s /lib/libuuid.so.1 $LD_LIBRARY_PATH/libuuid.so.1 && \
	ln -s /lib/libc.musl-x86_64.so.1 $LD_LIBRARY_PATH/libc.musl-x86_64.so.1 && \
	echo "**** Create user and take app folder ownership ****" && \
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
#CMD java -server -XX:+UnlockExperimentalVMOptions -XX:InitialRAMFraction=2 -XX:MinRAMFraction=2 -XX:MaxRAMFraction=2 -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+UseStringDeduplication -jar tnoodle-application.jar --online -b
CMD java -server -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+UseStringDeduplication -jar tnoodle-application.jar --online -b