#!/bin/bash

# Making opencv and caffe installation easier.
# Assumptions 
#  1. the directory we start from is /home/dehua/caffe
#  2. we are running this as root

## some issues with opencv. had to re-build and re-install opencv.
## could be due to libopencv-core2.3 still being around.
##

function step1_install_opencv_dep_pkgs() {
# opencv dependencies
  apt-get -y install libjpeg62-dev
  apt-get -y install libtiff4-dev libjasper-dev
  apt-get -y install libgtk2.0-dev
  apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
  apt-get -y install libdc1394-22-dev
  apt-get -y install libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
  apt-get -y install python-dev
  apt-get -y install libtbb-dev
  apt-get -y install libqt4-dev
}

function step2_upgrade_pip() {

  pip install --upgrade pip
  python -m pip install --upgrade --force-reinstall pip
}


function step3_upgrade_numpy() {

  pip install --upgrade numpy
  apt-get -y purge python-numpy
}


function step4_install_python_dep_pkgs() {
 
  pip install --upgrade Cython
  pip install scipy
  pip install --upgrade scikit-image
  pip install scikit-learn==0.16.1
  pip install xgboost
  pip install ipython
  pip install h5py
  pip install leveldb
  pip install networkx
  pip install nose
  pip install pandas
  pip install python-dateutil
  pip install protobuf
  pip install python-gflags
  pip install pyyaml
  pip install Pillow
}



function step5_install_opencv() {
  # confirm libopencv-core2.3 is uninstalled!!!
  apt-get -y purge libopencv-core2.3
  cp /home/dehua/caffe/dependencies/cmake_install.tar /usr/local
  cd /usr/local && tar xvf cmake_install.tar
  rm /usr/local/cmake_install.tar
  export PATH=/usr/local/cmake/bin:${PATH}
  cd /home/dehua/caffe/opencv/opencv-2.4.13/build && make install
  echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
  ldconfig
}

function step6_install_caffe_dep() {
  ##Caffe ubuntu 12.04 dependencies
  apt-get -y install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
  apt-get -y install --no-install-recommends libboost-all-dev
  apt-get -y install libatlas-base-dev
}

function step7_install_caffe_local_dep() {

  export PATH=/usr/local/cmake/bin:${PATH}
  ## glog
  cd /home/dehua/caffe/dependencies/glog-0.3.3 && make install

  ## gflags
  cd /home/dehua/caffe/dependencies/gflags-master/build
  export CXXFLAGS="-fPIC" && cmake .. && make VERBOSE=1
  make && make install

  ## lmdb
  cd /home/dehua/caffe/dependencies/lmdb/libraries/liblmdb && make install
}

function step8_install_caffe() {
  ## Copy the ~/caffe/caffe-master2/distribute.qa1.tgz to /opt and untar and rename the dir to /opt/caffe-1.0.0-rc3
  ## create link /opt/caffe -> /opt/caffe-1.0.0-rc3

  cp /home/dehua/caffe/caffe-master2/distribute.qa1.tgz /opt
  cd /opt && tar xvf distribute.qa1.tgz && mv distribute.qa1 caffe-1.0.0-rc3 && ln -s /opt/caffe-1.0.0-rc3 /opt/caffe
  echo "/opt/caffe/lib" > /etc/ld.so.conf.d/caffe.conf && ldconfig
  cp -a /opt/caffe/python/caffe/  /usr/local/lib/python2.7/dist-packages/
}

function step9_install_dlib() {
  ## dlib install!!!!
  export PATH=/usr/local/cmake/bin:$PATH
  cd /home/dehua/caffe/dependencies/dlib-18.18 &&  python setup.py install
}


step1_install_opencv_dep_pkgs
step2_upgrade_pip
step3_upgrade_numpy
step4_install_python_dep_pkgs
step5_install_opencv
step6_install_caffe_dep
step7_install_caffe_local_dep
step8_install_caffe
step9_install_dlib





