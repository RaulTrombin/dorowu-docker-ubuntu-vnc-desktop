FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's#http://archive.ubuntu.com/#http://tw.archive.ubuntu.com/#' /etc/apt/sources.list

# built-in packages
RUN apt-get update

RUN apt-get install -y  \
        supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc xvfb \
        gtk2-engines-murrine ttf-ubuntu-font-family \
        libreoffice firefox \
        fonts-wqy-microhei \
        language-pack-zh-hant language-pack-gnome-zh-hant firefox-locale-zh-hant libreoffice-l10n-zh-tw \
        nginx \
        python-pip python-dev build-essential \
        mesa-utils libgl1-mesa-dri \
        gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta \
        dbus-x11 x11-utils \
		vlc flvstreamer ffmpeg \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*


# tini for subreap
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-armhf /bin/tini
RUN chmod +x /bin/tini

ADD image /
RUN pip install setuptools wheel && pip install -r /usr/lib/web/requirements.txt

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]

#sudo docker run --name ubvnc -p 6080:80 -p 5900:5900 raulelektron/docker-ubuntu-vnc-desktop:0.0.0