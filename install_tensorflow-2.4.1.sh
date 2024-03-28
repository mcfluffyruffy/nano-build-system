# get a fresh start
apt-get update
apt-get upgrade
# remove old versions (if found)
rm -r /usr/local/lib/libtensorflow*
rm -r /usr/local/include/tensorflow
# the dependencies
apt-get install wget curl libhdf5-dev libc-ares-dev libeigen3-dev
apt-get install libatlas-base-dev zip unzip
# install gdown to download from Google drive (if not already done)
pip3 install gdown
# download the tarball
gdown https://drive.google.com/uc?id=1zJ_EF2aFkr8JU8JgTLfKMxC6KxE3DRD4
# unpack the ball
tar -C /usr/local -xzf libtensorflow-2.4.1-JetsonNano.tar.gz
