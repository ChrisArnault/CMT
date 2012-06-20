
#-----------------
cmt_package(B_F)

cmt_library(LibB_F src/LibB_F.cxx "")
cmt_executable(testB_F src/testB_F.cxx LibB_F)
cmt_test(mytestB_F)

#-----------------
