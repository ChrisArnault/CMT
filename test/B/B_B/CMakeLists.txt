
#-----------------
cmt_package(B_B)
cmt_use_package (B_F)
cmt_use_package (B_G)

cmt_library(LibB_B src/LibB_B.cxx "LibB_F;LibB_G")
cmt_executable(testB_B src/testB_B.cxx LibB_B)
cmt_test(mytestB_B)

#-----------------
