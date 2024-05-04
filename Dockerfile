FROM nvcr.io/nvidia/l4t-base:r32.7.1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common

RUN apt-get install -y \
    ca-certificates curl build-essential pkg-config libssl-dev zip unzip vim cmake v4l-utils openssh-client python3-pip wget

# https://qengineering.eu/install-pytorch-on-jetson-nano.html
RUN apt-get update && apt-get install -y \
      libopenmpi-dev libomp-dev ccache \
      libopenblas-dev libblas-dev libeigen3-dev \
      libjpeg-dev \
      gnupg2

RUN apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN echo 'deb https://repo.download.nvidia.com/jetson/common r32.7 main\n\
deb https://repo.download.nvidia.com/jetson/t210 r32.7 main' > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
RUN apt-get update && apt-get install -y nvidia-cuda nvidia-cudnn8

RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 17
RUN ln -s /usr/bin/llvm-config-17 /usr/bin/llvm-config

RUN pip3 install -U jetson-stats


#ADD cuda/include /usr/include/ 
#ADD cuda/aarch64-linux-gnu/include /usr/include/aarch64-linux-gnu/ 
#ADD cuda/aarch64-linux-gnu/lib /usr/lib/aarch64-linux-gnu/
#RUN rm -r /usr/local/cuda-10.2/*
#ADD cuda/local/cuda-10.2 /usr/local/cuda-10.2

ADD install_opencv-4.9.0.sh /tmp
RUN bash /tmp/install_opencv-4.9.0.sh

ADD install_realsense.sh /tmp
RUN bash /tmp/install_realsense.sh

RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN mkdir /code
WORKDIR /code
