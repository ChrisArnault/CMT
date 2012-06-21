
#-----------------
cmt_package(B_H)
cmt_use_package (B_E)
cmt_use_package (B_F)

cmt_library(LibB_H src/LibB_H.cxx "LibB_E;LibB_F")
cmt_executable(testB_H src/testB_H.cxx LibB_H)
cmt_test(mytestB_H)

#-----------------
