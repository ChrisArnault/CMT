
cd %CMTROOT%
rem del /F/S/Q test
rem mkdir test
cd test
rem python ..\generator.py projects=3 packages=8
dot -Tjpg generator.dot >generator.jpg
rem generator.jpg @
mkdir build
cd build && cmake --build=. ..\CMakeLists.txt && cd ..
cd ..
rem test\work.sln

