#
# The MIT License
#
# Copyright (c) 2017 Rafael Muñoz-Salinas
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# ===================================================================================
#  fbow CMake configuration file
#
#             ** File generated automatically, do not modify **
#
#  Usage from an external project:
#    In your CMakeLists.txt, add these lines:
#
#    find_package(fbow REQUIRED )
#    target_link_libraries(MY_TARGET_NAME ${fbow_LIBS})
#
#    This file will define the following variables:
#      - fbow_LIBS          : The list of libraries to links against.
#      - fbow_LIB_DIR       : The directory where lib files are.
#      - fbow_VERSION       : The version of this fbow build. Example: "1.2.0"
#      - fbow_VERSION_MAJOR : Major version part of VERSION. Example: "1"
#      - fbow_VERSION_MINOR : Minor version part of VERSION. Example: "2"
#      - fbow_VERSION_PATCH : Patch version part of VERSION. Example: "0"
#
# ===================================================================================

include("${CMAKE_CURRENT_LIST_DIR}/fbowTargets.cmake")

set(fbow_INCLUDE_DIRS "/home/zhaoqun/Documents/open_vslam/dependencies/include")
include_directories("/home/zhaoqun/Documents/open_vslam/dependencies/include")

set(fbow_LIB_DIR "/home/zhaoqun/Documents/open_vslam/dependencies/lib")
link_directories("/home/zhaoqun/Documents/open_vslam/dependencies/lib")

set(fbow_LIBS opencv_calib3d;opencv_core;opencv_dnn;opencv_features2d;opencv_flann;opencv_highgui;opencv_imgcodecs;opencv_imgproc;opencv_ml;opencv_objdetect;opencv_photo;opencv_stitching;opencv_video;opencv_videoio;opencv_aruco;opencv_bgsegm;opencv_bioinspired;opencv_ccalib;opencv_datasets;opencv_dnn_objdetect;opencv_dnn_superres;opencv_dpm;opencv_face;opencv_freetype;opencv_fuzzy;opencv_hdf;opencv_hfs;opencv_img_hash;opencv_line_descriptor;opencv_optflow;opencv_phase_unwrapping;opencv_plot;opencv_quality;opencv_reg;opencv_rgbd;opencv_saliency;opencv_shape;opencv_stereo;opencv_structured_light;opencv_superres;opencv_surface_matching;opencv_text;opencv_tracking;opencv_videostab;opencv_viz;opencv_ximgproc;opencv_xobjdetect;opencv_xphoto fbow)

set(fbow_FOUND TRUE)
set(fbow_VERSION 0.0.1)
set(fbow_VERSION_MAJOR 0)
set(fbow_VERSION_MINOR 0)
set(fbow_VERSION_PATCH 1)
