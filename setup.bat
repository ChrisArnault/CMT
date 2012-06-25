rem >>>> configure git???
set path=\install\git\bin;%path% 

rem >>>> discover where we are
for /f "delims=" %%i in ('cd') do Set pwd=%%i
set CMTROOT=%pwd%

rem >>>> configure various external sofware
rem >>>>   python
rem >>>>   graphiz
rem >>>>   CMake
set PATH=c:\Install\python27;c:\Install\Graphviz\bin;c:\Install\CMake\bin;%PATH%



