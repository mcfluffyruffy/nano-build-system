apt-get remove libopencv*
apt-get purge libopencv*
apt-get autoremove

wget -O opencv.zip https://github.com/opencv/opencv/archive/4.7.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.7.0.zip

unzip opencv.zip
unzip opencv_contrib.zip
mv opencv-4.7.0 /opencv
mv opencv_contrib-4.7.0 /opencv_contrib
rm opencv.zip
rm opencv_contrib.zip

cd /opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
    -D WITH_OPENCL=OFF \
    -D WITH_CUDA=ON \
    -D CUDA_ARCH_BIN=5.3 \
    -D CUDA_ARCH_PTX="" \
    -D WITH_CUDNN=ON \
    -D WITH_CUBLAS=ON \
    -D ENABLE_FAST_MATH=ON \
    -D CUDA_FAST_MATH=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D ENABLE_NEON=ON \
    -D WITH_QT=OFF \
    -D WITH_OPENMP=ON \
    -D BUILD_TIFF=ON \
    -D WITH_FFMPEG=ON \
    -D WITH_GSTREAMER=ON \
    -D WITH_TBB=ON \
    -D BUILD_TBB=ON \
    -D WITH_ONNX=ON \
    -D BUILD_TESTS=OFF \
    -D WITH_EIGEN=ON \
    -D WITH_V4L=ON \
    -D WITH_LIBV4L=ON \
    -D WITH_PROTOBUF=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D BUILD_EXAMPLES=OFF ..

NUM_PROCESSORS=$(nproc)
make -j$NUM_PROCESSORS

rm -r /usr/include/opencv4/opencv2
rm -r /usr/local/include/opencv4/opencv2
make install
ldconfig

make clean
apt-get update
