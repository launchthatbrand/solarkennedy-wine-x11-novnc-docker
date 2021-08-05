FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ARG USER_NAME=winer
ARG HOME=/home/$USER_NAME
ARG USER_ID=1000
ARG GROUP_ID=1010
# To access the values from children containers.
ENV USER_NAME=${USER_NAME} 
ENV HOME=${HOME}


RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install python2 python-is-python2 xvfb x11vnc xdotool wget tar supervisor net-tools fluxbox gnupg2 xrdp
    
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV WINEPREFIX /root/prefix32
ENV WINEARCH win32
ENV DISPLAY :0
ENV SCREEN_WHD=1600x900x24

WORKDIR /root/
#RUN wget -O - https://github.com/novnc/noVNC/archive/v1.1.0.tar.gz | tar -xzv -C /root/ && mv /root/noVNC-1.1.0 /root/novnc && ln -s /root/novnc/vnc_lite.html /root/novnc/index.html && \
#    wget -O - https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar -xzv -C /root/ && mv /root/websockify-0.9.0 /root/novnc/utils/websockify
    
ADD .fluxbox $HOME/.fluxbox
ADD build /build
ADD build/xrdp.ini /etc/xrdp/xrdp.ini

RUN set -ex; \
    groupadd --gid 1010 $USER_NAME;\
    useradd -u $USER_ID -d $HOME -g $USER_NAME -ms /bin/bash $USER_NAME


EXPOSE 8080
EXPOSE 3389

COPY entrypoint.sh /usr/bin/entrypoint
ENTRYPOINT ["/usr/bin/entrypoint"]
