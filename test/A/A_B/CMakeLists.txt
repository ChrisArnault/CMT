
#-----------------
cmt_package(A_B)

cmt_library(LibA_B src/LibA_B.cxx "")
cmt_executable(testA_B src/testA_B.cxx LibA_B)
cmt_test(mytestA_B)

#-----------------
