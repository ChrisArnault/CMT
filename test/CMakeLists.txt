
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

unset(status)
cmt_init(status)

if("${status}" STREQUAL "stop")
 return()
endif()

cmt_off()

cmt_use_project(work)

cmt_project(work "")

cmt_use_project(A)
cmt_use_project(B)

cmt_action()

