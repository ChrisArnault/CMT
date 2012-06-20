
#-----------------
cmt_package(B_G)

cmt_library(LibB_G src/LibB_G.cxx "")
cmt_executable(testB_G src/testB_G.cxx LibB_G)
cmt_test(mytestB_G)

#-----------------
