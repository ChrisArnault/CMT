
for /f "delims=" %%i in ('cd') do Set pwd=%%i
cd %pwd%

rmdir /S/Q %pwd%\test
mkdir test
cd test
python %CMTROOT%\generator.py projects=3 packages=8
rem dot -Tjpg generator.dot >generator.jpg

cd %pwd%



