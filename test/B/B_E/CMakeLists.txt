
#-----------------
cmt_package(B_E)

cmt_library(LibB_E src/LibB_E.cxx "")
cmt_executable(testB_E src/testB_E.cxx LibB_E)
cmt_test(mytestB_E)

#-----------------
