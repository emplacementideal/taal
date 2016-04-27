FROM alpine:3.3
MAINTAINER PentimentoLabs <contact@pentimentolabs.com>
ENV TAAL_VERSION=0.5.0

# Define charset
ENV LANG=en_US.utf8

# Define timezone
ENV TIMEZONE=Europe/Paris
RUN apk add --no-cache tzdata                                                  \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime                       \
    && echo ${TIMEZONE} >  /etc/timezone                                       \
    && apk del --purge tzdata

# Install general packages
RUN apk add --no-cache bash ca-certificates curl graphviz jq make nodejs postgresql-client vim

# Install GDAL
ENV GDAL_VERSION=2.0.2
RUN apk add --no-cache --virtual build-dependencies g++ gcc libc-dev                                          \
    && curl -L http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz | tar xzf - -C /tmp \
    && (cd /tmp/gdal-${GDAL_VERSION} && ./configure && make && make install)                                  \
    && rm -rf /tmp/gdal-${GDAL_VERSION}                                                                       \
    && apk del --purge build-dependencies

# Install pv
ENV PV_VERSION=1.6.0
RUN apk add --no-cache --virtual build-dependencies gcc libc-dev                                   \
    && curl -L http://www.ivarch.com/programs/sources/pv-${PV_VERSION}.tar.bz2 | tar xjf - -C /tmp \
    && (cd /tmp/pv-${PV_VERSION} && ./configure && make && make install)                           \
    && rm -rf /tmp/pv-${PV_VERSION}                                                                \
    && apk del --purge build-dependencies

# Install csvfix
ENV CSVFIX_VERSION=1.6
RUN apk add --no-cache --virtual build-dependencies g++ mercurial              \
    && hg clone https://bitbucket.org/neilb/csvfix /tmp/csvfix                 \
    && (cd /tmp/csvfix && hg up "version-${CSVFIX_VERSION}")                   \
    && make --directory=/tmp/csvfix lin                                        \
    && cp /tmp/csvfix/csvfix/bin/csvfix /usr/local/bin                         \
    && rm -rf /tmp/csvfix                                                      \
    && apk del --purge build-dependencies

# Install uchardet
ENV UCHARDET_VERSION=0.0.5
RUN apk add --no-cache --virtual build-dependencies cmake g++                                             \
    && curl -L https://github.com/BYVoid/uchardet/archive/v${UCHARDET_VERSION}.tar.gz | tar xzf - -C /tmp \
    && (cd /tmp/uchardet-${UCHARDET_VERSION} && cmake . && make && make install)                          \
    && rm -rf /tmp/uchardet-${UCHARDET_VERSION}                                                           \
    && apk del --purge build-dependencies

# Install Python environment
RUN apk add --no-cache py-pip python                                           \
    && pip install --upgrade pip setuptools

# Install PIP packages
RUN pip install --no-cache-dir --upgrade awscli httpie

# Install CSVKit
RUN apk add --no-cache --virtual build-dependencies gcc musl-dev postgresql-dev python-dev \
    && pip install --no-cache-dir --upgrade csvkit psycopg2                                \
    && apk del --purge build-dependencies

# Configure workspace
RUN mkdir /root/workbench
COPY ./files/.bashrc /root/.bashrc

# Run Bash
WORKDIR /root/workbench
ENTRYPOINT ["bash"]
