FROM ubuntu:15.10
MAINTAINER Emplacement Idéal Labs <labs@emplacementideal.com>

# Set tool versions
ENV CSVFIX_VERSION   1.6
ENV CVSKIT_VERSION   0.9.1
ENV GDAL_VERSION     1.11.2+dfsg-3ubuntu3
ENV GNUPLOT_VERSION  4.6.6-2
ENV HTTPIE_VERSION   0.9.2-0.1
ENV JQ_VERSION       1.5
ENV UCHARDET_VERSION 0.0.5

# Set Environment Variables & Language Environment
ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8:en.UTF-8
ENV LC_ALL en_US.UTF-8

# Install system packages as well as GDAL and gnuplot
RUN apt-get update                    \
    && apt-get install -y             \
        curl                          \
        gdal-bin=$GDAL_VERSION        \
        gnuplot                       \
        httpie=$HTTPIE_VERSION        \
        locales                       \
        p7zip                         \
        python-pip                    \
        sudo                          \
        unzip                         \
        vim                           \
        wget                          \
    && apt-get autoremove -y          \
    && apt-get clean                  \
    && rm -rf /var/lib/apt/lists/*

# Configure locales
RUN locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales

# Configure time
RUN echo "Etc/UTC" > /etc/timezone \
    && dpkg-reconfigure tzdata

# Install csvfix
RUN apt-get update                                             \
    && apt-get install -y g++ make mercurial                   \
    && hg clone https://bitbucket.org/neilb/csvfix /tmp/csvfix \
    && (cd /tmp/csvfix && hg up "version-$CSVFIX_VERSION")     \
    && make --directory=/tmp/csvfix lin                        \
    && cp /tmp/csvfix/csvfix/bin/csvfix /usr/local/bin         \
    && rm -rf /tmp/csvfix                                      \
    && apt-get remove -y g++ make mercurial                    \
    && apt-get autoremove -y                                   \
    && apt-get clean                                           \
    && rm -rf /var/lib/apt/lists/*

# Install csvkit
RUN pip install csvkit==$CVSKIT_VERSION \
    && rm -rf /tmp/pip_build_root

# Install jq and uchardet
RUN apt-get update                                                                                                                 \
    && apt-get install -y build-essential cmake                                                                                    \
    && wget --quiet --output-document=/usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-$JQ_VERSION/jq-linux64 \
    && chmod +x /usr/local/bin/jq                                                                                                  \
    && wget --quiet -O - https://github.com/BYVoid/uchardet/archive/v$UCHARDET_VERSION.tar.gz | tar -xz -C /tmp/                   \
    && (cd /tmp/uchardet-$UCHARDET_VERSION && cmake . && make && make install)                                                     \
    && rm -rf /tmp/uchardet-$UCHARDET_VERSION                                                                                      \
    && apt-get remove -y build-essential cmake                                                                                     \
    && apt-get autoremove -y                                                                                                       \
    && apt-get clean                                                                                                               \
    && rm -rf /var/lib/apt/lists/*

# Create taal user and remove password need to use sudo
RUN useradd --groups sudo --create-home --home-dir=/taal --shell /bin/bash taal                                 \
    && echo "taal:taal" | chpasswd                                                                              \
    && sed --in-place --expression="s/\%sudo\t\ALL=(ALL:ALL) ALL/\%sudo\tALL=(ALL) NOPASSWD:ALL/" /etc/sudoers

# Configure Bash
COPY ./files/.bashrc /root/.bashrc
COPY ./files/.bashrc /taal/.bashrc
RUN chown -R taal:taal /taal/

# Create placeholder folders
RUN mkdir --mode=777 /taal/data         \
    && chown -R taal:taal /taal/data    \
    && mkdir --mode=777 /taal/scripts   \
    && chown -R taal:taal /taal/scripts

# Run Bash
USER taal
WORKDIR /taal
ENTRYPOINT ["bash"]
