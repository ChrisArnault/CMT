
#-----------------
cmt_package(B_C)
cmt_use_package (B_F)

cmt_library(LibB_C src/LibB_C.cxx "LibB_F")
cmt_executable(testB_C src/testB_C.cxx LibB_C)
cmt_test(mytestB_C)

#-----------------
