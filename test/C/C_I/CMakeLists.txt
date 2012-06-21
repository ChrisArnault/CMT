
#-----------------
cmt_package(C_I)

cmt_library(LibC_I src/LibC_I.cxx "")
cmt_executable(testC_I src/testC_I.cxx LibC_I)
cmt_test(mytestC_I)

#-----------------
