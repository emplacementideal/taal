FROM alpine:3.3
MAINTAINER PentimentoLabs <contact@pentimentolabs.com>
ENV TAAL_VERSION=0.5.0-dev

# Define charset
ENV LANG=en_US.utf8

# Define timezone
ENV TIMEZONE=Europe/Paris
RUN apk add --no-cache tzdata                                                  \
    && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime                       \
    && echo ${TIMEZONE} >  /etc/timezone                                       \
    && apk del --purge tzdata

# Install general packages
RUN apk add --no-cache bash ca-certificates curl graphviz vim

# Install Python environment
ENV PYTHON_VERSION=2.7.11-r3
RUN apk add --no-cache py-pip python=${PYTHON_VERSION}                         \
    && pip install --upgrade pip setuptools

# Install Java environment
ENV OPENJDK_VERSION=8.72.15-r2
RUN apk add --no-cache openjdk8=${OPENJDK_VERSION}

# Install Node.js environment
ENV NODEJS_VERSION=4.3.0-r0
RUN apk add --no-cache nodejs=${NODEJS_VERSION}

# Install GDAL
ENV GDAL_VERSION=2.0.2
RUN apk add --no-cache --virtual build-dependencies g++ gcc libc-dev make                                     \
    && curl -L http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz | tar xzf - -C /tmp \
    && (cd /tmp/gdal-${GDAL_VERSION} && ./configure && make && make install)                                  \
    && rm -rf /tmp/gdal-${GDAL_VERSION}                                                                       \
    && apk del --purge build-dependencies

# Install jq
ENV JQ_VERSION=1.5-r0
RUN apk add --no-cache jq=${JQ_VERSION}

# Install CSVKit
ENV CVSKIT_VERSION=0.9.1
RUN apk add --no-cache --virtual build-dependencies gcc musl-dev postgresql-dev python-dev \
    && pip install --no-cache-dir --upgrade csvkit==${CVSKIT_VERSION} psycopg2             \
    && apk del --purge build-dependencies

# Install HTTPie
ENV HTTPIE_VERSION=0.9.3
RUN pip install --no-cache-dir --upgrade httpie==${HTTPIE_VERSION}

# Install Drake
ENV DRAKE_VERSION=1.0.1 \
    DRAKE_COMMIT_HASH=ef36be08d0499c851546c60b020d5bb198263eb2
RUN mkdir -p ${HOME}/.drakerc/jar                                                                                                                          \
    && curl -L -o ${HOME}/.drakerc/jar/drake-${DRAKE_VERSION}-standalone.jar https://github.com/Factual/drake/releases/download/${DRAKE_VERSION}/drake.jar \
    && curl -L -o /bin/drake https://raw.githubusercontent.com/Factual/drake/${DRAKE_COMMIT_HASH}/bin/drake                                                \
    && chmod 755 /bin/drake

# Install pv
ENV PV_VERSION=1.6.0
RUN apk add --no-cache --virtual build-dependencies gcc libc-dev make                              \
    && curl -L http://www.ivarch.com/programs/sources/pv-${PV_VERSION}.tar.bz2 | tar xjf - -C /tmp \
    && (cd /tmp/pv-${PV_VERSION} && ./configure && make && make install)                           \
    && rm -rf /tmp/pv-${PV_VERSION}                                                                \
    && apk del --purge build-dependencies

# Install PostgreSQL client
RUN apk add --no-cache postgresql-client

# Configure workspace
RUN mkdir /root/workbench
COPY ./files/.bashrc /root/.bashrc

# Run Bash
WORKDIR /root/workbench
ENTRYPOINT ["bash"]
