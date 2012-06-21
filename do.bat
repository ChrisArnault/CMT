
cd %CMTROOT%
del /F/S/Q test
mkdir test
cd test
python ..\generator.py projects=2 packages=5
dot -Tjpg generator.dot >generator.jpg
generator.jpg @
cd build && cmake --build=. ..\CMakeLists.txt && cd ..
cd ..
rem test\work.sln

