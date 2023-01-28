find_library(SIOCLIENT_LIBRARY sioclient sioclient_tls
    PATHS "/home/zhaoqun/Documents/open_vslam/dependencies/lib"
)
find_path(SIOCLIENT_INCLUDE_DIR sioclient/sio_client.h sioclient/sio_message.h sioclient/sio_socket.h
    PATHS "/home/zhaoqun/Documents/open_vslam/dependencies/include"
)
set(SIOCLIENT_LIBRARIES ${SIOCLIENT_LIBRARY})
set(SIOCLIENT_INCLUDE_DIRS ${SIOCLIENT_INCLUDE_DIR})
