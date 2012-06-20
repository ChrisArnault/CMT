
set CMTROOT=\Arnault\CMTCMake\CMT
cd %CMTROOT%
del /F/S/Q test
cd test
python ..\generator.py projects=2 packages=5
dot -Tjpg generator.dot >generator.jpg
generator.jpg @
cd build && \Install\CMake\bin\cmake --build=. ..\CMakeLists.txt && cd ..
cd ..
rem test\work.sln

