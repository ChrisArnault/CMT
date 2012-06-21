
#-----------------
cmt_package(B_E)
cmt_use_package (B_D)

cmt_library(LibB_E src/LibB_E.cxx "LibB_D")
cmt_executable(testB_E src/testB_E.cxx LibB_E)
cmt_test(mytestB_E)

#-----------------
