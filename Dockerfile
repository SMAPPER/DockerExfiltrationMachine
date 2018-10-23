FROM ubuntu:18.04
MAINTAINER justin@hasecuritysolutions.com

# Create the log file to be able to   && tail
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update \
  && apt -y install curl wget apt-transport-https netcat ssh samba ruby-dev git make g++ apache2 php \
  && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  && apt update \
  && apt install -y powershell \
  && useradd -ms /bin/bash exfil \
  && cd /home/exfil \
  && git clone https://github.com/iagox86/dnscat2.git \
  && cd dnscat2/server \
  && gem install bundler \
  && bundle install
COPY ./entrypoint.sh /opt/
EXPOSE 22
EXPOSE 80
EXPOSE 139
EXPOSE 443
EXPOSE 445
STOPSIGNAL SIGTERM
CMD /usr/sbin/apache2ctl -D FOREGROUND
