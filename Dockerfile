FROM ubuntu:15.10
MAINTAINER Emplacement Idéal Labs <labs@emplacementideal.com>

# Set tool versions
ENV CSVFIX_VERSION    1.6
ENV CVSKIT_VERSION    0.9.1
ENV DRAKE_COMMIT_HASH ef36be08d0499c851546c60b020d5bb198263eb2
ENV DRAKE_VERSION     1.0.1
ENV GDAL_VERSION      1.11.2+dfsg-3ubuntu3
ENV GNUPLOT_VERSION   4.6.6-2
ENV HTTPIE_VERSION    0.9.2-0.1
ENV JQ_VERSION        1.5
ENV UCHARDET_VERSION  0.0.5

# Set TAAL variables
ENV HOME /taal

# Set environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8:en.UTF-8
ENV LC_ALL en_US.UTF-8

# Install system packages as well as GDAL and gnuplot
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install --yes                      \
        build-essential                           \
        cmake                                     \
        curl                                      \
        gdal-bin=$GDAL_VERSION                    \
        feedgnuplot                               \
        gnuplot                                   \
        httpie=$HTTPIE_VERSION                    \
        less                                      \
        libmysqlclient-dev                        \
        libpq-dev                                 \
        locales                                   \
        mercurial                                 \
        ntp                                       \
        openjdk-8-jdk                             \
        p7zip                                     \
        pv                                        \
        python-dev                                \
        python-pip                                \
        sudo                                      \
        unzip                                     \
        vim                                       \
        wget                                      \
    && apt-get autoremove -y                      \
    && apt-get clean                              \
    && rm -rf /var/lib/apt/lists/*

# Configure locales
RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

# Configure time
RUN echo "Etc/UTC" > /etc/timezone \
    && dpkg-reconfigure tzdata

# Configure sudo
RUN sed --in-place --expression="s/\%sudo\t\ALL=(ALL:ALL) ALL/\%sudo\tALL=(ALL) NOPASSWD:ALL/" /etc/sudoers

# Create taal user
RUN useradd --groups sudo --create-home --home-dir=$HOME --shell /bin/bash taal  \
    && echo "taal:taal" | chpasswd                                               \
    && touch $HOME/.sudo_as_admin_successful

# Configure Bash
COPY ./files/.bashrc /root/.bashrc
COPY ./files/.bashrc $HOME/.bashrc
RUN chown -R taal:taal $HOME

# Create placeholder folders
RUN mkdir --mode=777 $HOME/data         \
    && chown -R taal:taal $HOME/data    \
    && mkdir --mode=777 $HOME/scripts   \
    && chown -R taal:taal $HOME/scripts

# Install csvfix
RUN hg clone https://bitbucket.org/neilb/csvfix /tmp/csvfix \
    && (cd /tmp/csvfix && hg up "version-$CSVFIX_VERSION")  \
    && make --directory=/tmp/csvfix lin                     \
    && cp /tmp/csvfix/csvfix/bin/csvfix /usr/local/bin      \
    && rm -rf /tmp/csvfix

# Install csvkit
RUN pip install csvkit==$CVSKIT_VERSION \
    && pip install MySQL-python         \
    && pip install psycopg2             \
    && rm -rf /tmp/pip_build_root

# Install jq and uchardet
RUN wget --quiet --output-document=/usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-linux64 \
    && chmod +x /usr/local/bin/jq                                                                                               \
    && wget --quiet --output-document=- https://github.com/BYVoid/uchardet/archive/v$UCHARDET_VERSION.tar.gz | tar -xz -C /tmp/                \
    && (cd /tmp/uchardet-$UCHARDET_VERSION && cmake . && make && make install)                                                  \
    && rm -rf /tmp/uchardet-$UCHARDET_VERSION

# Install Drake
RUN mkdir -p $HOME/.drakerc/jar                                                                                                                                              \
    && wget --quiet --output-document=$HOME/.drakerc/jar/drake-${DRAKE_VERSION}-standalone.jar https://github.com/Factual/drake/releases/download/${DRAKE_VERSION}/drake.jar \
    && wget --quiet --output-document=/bin/drake https://raw.githubusercontent.com/Factual/drake/${DRAKE_COMMIT_HASH}/bin/drake                                              \
    && chmod 755 /bin/drake

# Run Bash
USER taal
WORKDIR /taal
ENTRYPOINT ["bash"]
