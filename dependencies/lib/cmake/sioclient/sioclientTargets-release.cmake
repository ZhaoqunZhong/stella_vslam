#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "sioclient" for configuration "Release"
set_property(TARGET sioclient APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(sioclient PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libsioclient.so.1.6.0"
  IMPORTED_SONAME_RELEASE "libsioclient.so.1"
  )

list(APPEND _IMPORT_CHECK_TARGETS sioclient )
list(APPEND _IMPORT_CHECK_FILES_FOR_sioclient "${_IMPORT_PREFIX}/lib/libsioclient.so.1.6.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
