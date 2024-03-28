FROM nvcr.io/nvidia/l4t-base:r32.7.1

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'

RUN apt-get install -y \
    ca-certificates curl build-essential pkg-config libssl-dev zip unzip vim cmake v4l-utils openssh-client python3-pip 
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 17
RUN ln -s /usr/bin/llvm-config-17 /usr/bin/llvm-config

# 
# install OpenCV (with CUDA)
#
ARG OPENCV_URL=https://nvidia.box.com/shared/static/5v89u6g5rb62fpz4lh0rz531ajo2t5ef.gz
ARG OPENCV_DEB=OpenCV-4.5.0-aarch64.tar.gz

RUN apt-get purge -y '*opencv*' || echo "previous OpenCV installation not found" && \
    mkdir opencv && \
    cd opencv && \
    wget --quiet --show-progress --progress=bar:force:noscroll --no-check-certificate ${OPENCV_URL} -O ${OPENCV_DEB} && \
    tar -xzvf ${OPENCV_DEB} && \
    dpkg -i --force-depends *.deb && \
    apt-get update && \
    apt-get install -y -f --no-install-recommends && \
    dpkg -i *.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    cd ../ && \
    rm -rf opencv && \
    cp -r /usr/include/opencv4 /usr/local/include/opencv4 && \
    cp -r /usr/lib/python3.6/dist-packages/cv2 /usr/local/lib/python3.6/dist-packages/cv2

ADD ./install_tensorflow-2.4.1.sh /tmp
RUN bash /tmp/install_tensorflow-2.4.1.sh

RUN export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN mkdir /code
WORKDIR /code
