
#-----------------
cmt_package(A_A)

cmt_library(LibA_A src/LibA_A.cxx "")
cmt_executable(testA_A src/testA_A.cxx LibA_A)
cmt_test(mytestA_A)

#-----------------
