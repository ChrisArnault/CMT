
cmake_minimum_required(VERSION 2.8)

set(CMTROOT "$ENV{CMTROOT}")
if("${CMTROOT}" STREQUAL "")
  set(CMTROOT "/Arnault/CMTCMake/CMT")
endif()

set(CMTPROJECTPATH "$ENV{CMTPROJECTPATH}")
if("${CMTPROJECTPATH}" STREQUAL "")
  set(CMTPROJECTPATH "C:/Arnault/CMTCMake/CMT/test")
endif()

include(${CMTROOT}/cmake/CMTLib.cmake)

cmt_use_project(work)


