FROM debian:latest

WORKDIR /workdir

RUN apt-get update && \
	apt-get install -y git python3 curl cmake unzip autoconf automake libtool perl patch pkg-config ccache g++ build-essential ninja-build

# Build emscripten
RUN git clone https://github.com/EasyRPG/buildscripts && \
    cd buildscripts && \
    cd emscripten && \
    ./0_build_everything.sh && \
    cd emsdk-portable

# Build liblcf
RUN  /bin/bash -c 'source buildscripts/emscripten/emsdk-portable/emsdk_env.sh && \
 	git clone https://github.com/EasyRPG/liblcf && cd liblcf && \
 	export EM_PKG_CONFIG_PATH=/workdir/buildscripts/emscripten/lib/pkgconfig && autoreconf -fi && \
 	emconfigure ./configure --prefix=/workdir/buildscripts/emscripten --disable-shared && \
 	make install'
