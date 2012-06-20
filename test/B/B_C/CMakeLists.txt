
#-----------------
cmt_package(B_C)

cmt_library(LibB_C src/LibB_C.cxx "")
cmt_executable(testB_C src/testB_C.cxx LibB_C)
cmt_test(mytestB_C)

#-----------------
