FROM nvcr.io/nvidia/l4t-base:r32.7.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    rustc

RUN mkdir /build
