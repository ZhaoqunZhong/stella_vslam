'
sudo apt update -y
sudo apt upgrade -y --no-install-recommends
# basic dependencies
sudo apt install -y build-essential pkg-config cmake git wget curl unzip
# g2o dependencies
sudo apt install -y libatlas-base-dev libsuitesparse-dev
# OpenCV dependencies
sudo apt install -y libgtk-3-dev
sudo apt install -y ffmpeg
sudo apt install -y libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev
# eigen dependencies
sudo apt install -y gfortran

# backward-cpp dependencies (optional)
sudo apt install -y binutils-dev
# other dependencies
sudo apt install -y libyaml-cpp-dev libgflags-dev sqlite3 libsqlite3-dev

# (if you plan on using PangolinViewer)
# Pangolin dependencies
sudo apt install -y libglew-dev

# (if you plan on using SocketViewer)
# Protobuf dependencies
sudo apt install -y autogen autoconf libtool
# Node.js
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt install -y 

# openMP
# sudo apt install -y libomp-dev
'

# Download and install Eigen from source.
cd ./3rd
# wget -q https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.bz2
# tar xf eigen-3.3.7.tar.bz2
# rm -rf eigen-3.3.7.tar.bz2
cd eigen-3.3.7
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    ..
make -j4
make install

# Download, build and install OpenCV from source.

cd ../.. # back to 3rd
# wget -q https://github.com/opencv/opencv/archive/3.4.0.zip
# unzip -q 3.4.0.zip
# rm -rf 3.4.0.zip
cd opencv-3.4.0
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    -DENABLE_CXX11=ON \
    -DBUILD_DOCS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_OPENEXR=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_TESTS=OFF \
    -DWITH_EIGEN=ON \
    -DWITH_FFMPEG=ON \
    -DWITH_OPENMP=ON \
    -DBUILD_opencv_cudacodec=OFF \
    -DWITH_CUDA=OFF \
    ..
make -j4
make install



# Download, build and install the custom FBoW from source.

cd ../..
cd FBoW
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    -DCMAKE_PREFIX_PATH=../../../dependencies \
    ..
make -j4
make install


# Download, build and install g2o.

cd ../..
#cd 3rd
# git clone https://github.com/RainerKuemmerle/g2o.git
cd g2o
# git checkout 9b41a4ea5ade8e1250b9c1b279f3a9c098811b5a
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    -DCMAKE_CXX_FLAGS=-std=c++11 \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_UNITTESTS=OFF \
    -DG2O_USE_CHOLMOD=OFF \
    -DG2O_USE_CSPARSE=ON \
    -DG2O_USE_OPENGL=OFF \
    -DG2O_USE_OPENMP=OFF \
    ..
make -j4
make install


#(if you plan on using PangolinViewer)
#Download, build and install Pangolin from source.
cd ../..
cd 3rd
# git clone https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin
# git checkout ad8b5f83222291c51b4800d5a5873b0e90a0cf81
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    ..
make -j4
make install


cd ../..
cd backward-cpp
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    -DCMAKE_CXX_FLAGS=-std=c++11 \
    ..
make -j4
make install

cd ../..
# git clone https://github.com/shinsumicco/socket.io-client-cpp
cd socket.io-client-cpp
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    -DCMAKE_CXX_FLAGS=-std=c++11 \
    ..
make -j4
make install


cd ../..
cd protobuf-3.21.12
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX=../../../dependencies \
    -DCMAKE_CXX_STANDARD=14 \
    ..
make -j4
make install


#build stella_vslam

cd ../../..
if ! [ -d "build" ]; then
    mkdir build
fi
cd build
cmake \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DUSE_PANGOLIN_VIEWER=ON \
    -DINSTALL_PANGOLIN_VIEWER=OFF \
    -DUSE_SOCKET_PUBLISHER=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_EXAMPLES=ON \
    -DUSE_OPENMP=ON \
    -DCMAKE_CXX_STANDARD=14 \
    ..

make -j4
