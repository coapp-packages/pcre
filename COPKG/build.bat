@echo on
pushd %~dp0..
del CMakeCache.txt

REM ========== SET UP LIBRARIES ===============
REM mkdir packages
REM cd packages
REM nuget install bzip2
REM nuget install zlib
REM cd ..

set bzip=%~dp0../packages/bzip2.1.0.6.7
set bzip=%bzip:\=/%
set bzipinc=%bzip%/build/native/include

set zlib=%~dp0../packages/zlib.1.2.7.34
set zlib=%zlib:\=/%
set zlibinc=%zlib%/build/native/include

REM -LABEL-ARCH-FLAVOR-MSVCV-GENERATOR----------------CONV--ZLIB_LIB----BZ2_LIB-------BUILD_SHARED
setlocal
REM call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" amd64
REM call :build x64 static  v110 "Visual Studio 11 Win64" cdecl zlib-static libbz2-static NO
call :build x64 dynamic v110 "Visual Studio 11 Win64" cdecl zlib-cdecl  libbz2-cdecl  YES
REM endlocal
REM setlocal
REM call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" amd64
REM call :build x64 dynamic v100 "Visual Studio 10 Win64" cdecl zlib-cdecl  libbz2-cdecl  YES
REM call :build x64 static  v100 "Visual Studio 10 Win64" cdecl zlib-static libbz2-static NO
REM endlocal
REM setlocal
REM call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86
REM call :build x86 static  v110 "Visual Studio 11"       cdecl zlib-static libbz2-static NO
REM call :build x86 dynamic v110 "Visual Studio 11"       cdecl zlib-cdecl  libbz2-cdecl  YES
REM endlocal
REM setlocal
REM call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86
REM call :build x86 dynamic v100 "Visual Studio 10"       cdecl zlib-cdecl  libbz2-cdecl  YES
REM call :build x86 static  v100 "Visual Studio 10"       cdecl zlib-static libbz2-static NO
endlocal 

goto :end
REM ========== CONFIGURE & BUILD ===========

:build
set targetdir=.%1.%2.%3.%5
echo %targetdir%
mkdir %targetdir%
pushd %targetdir% 
set bziplib=%bzip%/build/native/lib/%1/%3/%2/%5/
set zliblib=%zlib%/build/native/lib/%1/%3/%2/%5/
echo on

cmake ^
	-DBUILD_SHARED_LIBS:bool=%8 ^
	-DCMAKE_C_FLAGS_DEBUG:string="/MTd" ^
	-DCMAKE_C_FLAGS_RELEASE:string="/MT" ^
	-DPCRE_BUILD_PCRECPP:bool=YES ^
	-DPCRE_SUPPORT_UNICODE_PROPERTIES:bool=YES ^
	-DPCRE_SUPPORT_JIT:bool=NO ^
	-DPCRE_BUILD_PCRE32:bool=YES ^
	-DZLIB_INCLUDE_DIR:string=%zlibinc% ^
	-DZLIB_LIBRARY_DEBUG:string=%zliblib%Debug/%6.lib ^
	-DZLIB_LIBRARY_RELEASE:string=%zliblib%Release/%6.lib ^
	-DBZIP2_INCLUDE_DIR:string=%bzipinc% ^
	-DBZIP2_LIBRARY_RELEASE:string="%bziplib%Release/%7.lib" ^
	-DBZIP2_LIBRARY_DEBUG:string="%bziplib%Debug/%7.lib" ^
	-G %4 ..
IF %ERRORLEVEL% NEQ 0 GOTO end 

msbuild /m /p:Configuration=Release ALL_BUILD.vcxproj
msbuild /m /p:Configuration=Debug ALL_BUILD.vcxproj
:end
popd