#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "fbow::fbow" for configuration "Release"
set_property(TARGET fbow::fbow APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(fbow::fbow PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libfbow.so.0.0.1"
  IMPORTED_SONAME_RELEASE "libfbow.so.0.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS fbow::fbow )
list(APPEND _IMPORT_CHECK_FILES_FOR_fbow::fbow "${_IMPORT_PREFIX}/lib/libfbow.so.0.0.1" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
