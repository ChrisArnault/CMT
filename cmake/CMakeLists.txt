
cmake_minimum_required(VERSION 2.8)

set(CMTROOT "$ENV{CMTROOT}")

set(CMTPROJECTPATH "$ENV{CMTPROJECTPATH}")
if("${CMTPROJECTPATH}" STREQUAL "")
  set(CMTPROJECTPATH "${CMTROOT}/test")
endif()

include(${CMTROOT}/cmake/CMTLib.cmake)

cmt_use_project(work)


