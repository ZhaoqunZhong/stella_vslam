# ./build/run_video_slam -v ./dependencies/orb_vocab.fbow -m /home/zhaoqun/Videos/Webcam/2022-12-14-150205.mp4 -c ./example/aist/scaramuzza.yaml 

# ./build/run_video_slam -v ./dependencies/orb_vocab.fbow -m /media/psf/Home/Downloads/R0010194_st.MP4 -c ./example/aist/equirectangular.yaml 

# at the build directory of stella_vslam
# monocular SLAM with any EuRoC sequence
./build/run_euroc_slam \
    -v ./dependencies/orb_vocab.fbow \
    -d /media/psf/Home/Downloads/Euroc/v201easy \
    -c ./example/euroc/EuRoC_mono.yaml
# stereo SLAM with any EuRoC sequence
 # ./build/run_euroc_slam \
 #    -v ./dependencies/orb_vocab.fbow \
 #    -d /media/psf/Home/Downloads/mav0 \
 #    -c ./example/euroc/EuRoC_stereo.yaml
