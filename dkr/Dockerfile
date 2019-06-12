FROM ubuntu:16.04 as ppy-builder
MAINTAINER PeerPlays Witnesses

ARG BRANCH_NAME=beatrice
ARG COMMIT=60afddefd594e860a712aa8ccfe86f1f9db25901

RUN \
        apt-get update && \
        apt-get install -y \
          build-essential \
          autotools-dev \
          automake \
          autoconf \
          libtool \
          make \
          cmake \
          git \
          libreadline-dev \
          libssl-dev \
          libboost-all-dev \
          libcurl4-openssl-dev \
          python-dev \
          doxygen \
          ntp \
          wget \
        && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
    git clone https://github.com/peerplays-network/peerplays.git /source  && \
    cd /source && git checkout ${BRANCH_NAME} && \
    git submodule update --init --recursive

WORKDIR /source

RUN rm genesis.json

ADD genesis.json .

RUN \
    BOOST_ROOT=$HOME/opt/boost_1_60_0 && \
    wget -c 'http://sourceforge.net/projects/boost/files/boost/1.60.0/boost_1_60_0.tar.gz/download' -O boost_1_60_0.tar.gz &&\
    tar -zxvf boost_1_60_0.tar.gz && \
    cd boost_1_60_0/ && \
    ./bootstrap.sh "--prefix=$BOOST_ROOT" && \
    ./b2 install -j$(nproc) && \
    cd .. && \
    mkdir build && cd build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        .. \ 
     && \
     make -j4 && \
     make install && \
     git rev-parse --short HEAD > /etc/peerplays && \
     cd / && \
     rm -rf /tmp/* /source

FROM ubuntu:16.04

WORKDIR /var/lib/peerplays
ENV HOME /var/lib/peerplays

RUN mkdir /usr/share/peerplays
ADD config.ini.example /usr/share/peerplays/config.ini.example

COPY --from=ppy-builder /usr/local/bin/witness_node /usr/local/bin/witness_node
COPY --from=ppy-builder /usr/local/bin/cli_wallet /usr/local/bin/cli_wallet
COPY --from=ppy-builder /version /usr/share/peerplays/version

# default exec/config files
ADD peerplaysentry.sh /usr/local/bin/peerplaysentry.sh
RUN chmod a+x /usr/local/bin/peerplaysentry.sh

# Volume
VOLUME "/var/lib/peerplays"

# rpc service:
EXPOSE 8090
# p2p service:
EXPOSE 2001

# default execute entry
CMD /usr/local/bin/peerplaysentry.sh
