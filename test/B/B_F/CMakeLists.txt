
#-----------------
cmt_package(B_F)
cmt_use_package (B_G)

cmt_library(LibB_F src/LibB_F.cxx "LibB_G")
cmt_executable(testB_F src/testB_F.cxx LibB_F)
cmt_test(mytestB_F)

#-----------------
