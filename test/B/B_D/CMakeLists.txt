
#-----------------
cmt_package(B_D)
cmt_use_package (B_E)

cmt_library(LibB_D src/LibB_D.cxx "LibB_E")
cmt_executable(testB_D src/testB_D.cxx LibB_D)
cmt_test(mytestB_D)

#-----------------
