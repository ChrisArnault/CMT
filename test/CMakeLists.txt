
cmake_minimum_required(VERSION 2.8)

set(CMTROOT "$ENV{CMTROOT}")

set(CMTPROJECTPATH "$ENV{CMTPROJECTPATH}")
if("${CMTPROJECTPATH}" STREQUAL "")
  set(CMTPROJECTPATH "${CMTROOT}/test")
endif()

include(${CMTROOT}/cmake/CMTLib.cmake)

unset(status)
cmt_init(status)

if("${status}" STREQUAL "stop")
 return()
endif()

cmt_off()

cmt_use_project(work)

cmt_project(work "")

cmt_use_project(A)
cmt_use_project(C)
cmt_use_project(B)

cmt_action()

