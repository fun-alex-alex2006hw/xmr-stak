# Latest version of ubuntu
FROM nvidia/cuda:9.0-base

# Default git repository
#ENV GIT_REPOSITORY https://github.com/fireice-uk/xmr-stak.git
ENV GIT_REPOSITORY https://github.com/fun-alex-alex2006hw/xmr-stak.git
ENV XMRSTAK_CMAKE_FLAGS -DXMR-STAK_COMPILE=generic -DCUDA_ENABLE=ON -DOpenCL_ENABLE=ON
# enable hugepages
RUN echo 128 > /proc/sys/vm/nr_hugepages &
COPY ./scripts/rc.local /etc/rc.local

# Innstall packages
RUN apt-get update \
    && set -x \
    && apt-get install -qq --no-install-recommends -y ca-certificates cmake cuda-core-9-0 git cuda-cudart-dev-9-0 \
        libhwloc-dev libmicrohttpd-dev libssl-dev ocl-icd-opencl-dev libuv1-dev libhwloc-dev \
        automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libgmp-dev make g++ \
        build-essential libboost-all-dev libunbound-dev graphviz doxygen libunwind8-dev \
        libgtest-dev libreadline-dev miniupnpc libminiupnpc-dev libzmq3-dev \
    && git clone $GIT_REPOSITORY \
    && cd /xmr-stak \
    && cmake ${XMRSTAK_CMAKE_FLAGS} . \
    && make \
    && cd - \
    && mv /xmr-stak/bin/* /usr/local/bin/ \
    && rm -rf /xmr-stak \
    && git clone $GIT_REPOSITORY \
    && apt-get purge -y -qq cmake cuda-core-9-0 git cuda-cudart-dev-9-0 libhwloc-dev libmicrohttpd-dev \
        libhwloc-dev libmicrohttpd-dev libssl-dev ocl-icd-opencl-dev libuv1-dev libhwloc-dev \
        automake autoconf pkg-config libcurl4-openssl-dev libjansson-dev libgmp-dev make g++ \
        build-essential libboost-all-dev libunbound-dev graphviz doxygen libunwind8-dev \
        libgtest-dev libreadline-dev libminiupnpc-dev libzmq3-dev \
    && apt-get clean -qq

VOLUME /mnt

WORKDIR /mnt

ENTRYPOINT ["/usr/local/bin/xmr-stak"]
