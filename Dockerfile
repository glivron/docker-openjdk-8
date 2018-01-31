FROM openjdk:8-jdk-slim
ENV DEBIAN_FRONTEND noninteractive

ENV APR_VERSION 1.6.3
ENV TCNATIVE_VERSION 1.2.16

RUN apt-get -qq update                    \
 && apt-get -qq upgrade -y                \
 && apt-get -qq install -y apt-utils curl \

# ---------------------------------------------------------------------- openssl
 && echo "deb http://ftp.debian.org/debian sid main"      > /etc/apt/sources.list.d/sid.list \
 && echo "deb-src http://ftp.debian.org/debian sid main" >> /etc/apt/sources.list.d/sid.list \
 && apt-get -qq update                        \
 && apt-get -qq install -y openssl libssl-dev \
 && rm /etc/apt/sources.list.d/sid.list       \
 && apt-get -qq update                        \

# --------------------------------------------------------------------- tcnative
 && apt-get -qq install -y build-essential libpcre++-dev zlib1g-dev \
 && cd /tmp \

 && curl -L https://www.apache.org/dist/apr/apr-$APR_VERSION.tar.gz | gunzip -c | tar x \
 && cd apr-$APR_VERSION \
 && ./configure \
 && make install \

 && curl -L https://www.apache.org/dist/tomcat/tomcat-connectors/native/$TCNATIVE_VERSION/source/tomcat-native-$TCNATIVE_VERSION-src.tar.gz | gunzip -c | tar x \
 && cd tomcat-native-$TCNATIVE_VERSION-src/native \
 && ./configure --with-java-home=$JAVA_HOME --with-apr=/usr/local/apr --prefix=/usr \
 && make install \

 && apt-get -qq autoremove -y build-essential \
 && apt-get -qq clean \
 && rm -fR /tmp/*
