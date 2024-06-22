FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-readarr"

RUN apt-get update && \
	apt-get -y install --no-install-recommends libicu72 && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/readarr"
ENV READARR_REL="debug"
ENV START_PARAMS=""
ENV UMASK=0000
ENV DATA_PERM=770
ENV CONNECTED_CONTAINERS=""
ENV UID=99
ENV GID=100
ENV USER="lidarr"

RUN mkdir $DATA_DIR && \
	mkdir /mnt/downloads && \
    mkdir /mnt/books && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chmod -R 770 /mnt && \
	chown -R $UID:$GID /mnt

EXPOSE 8787

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]