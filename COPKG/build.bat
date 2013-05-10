@echo off
pushd %~dp0..
del CMakeCache.txt
mkdir packages
cd packages

REM ========== SET UP LIBRARIES ===============
REM nuget install bzip2
REM nuget install zlib

set bzip=%~dp0../packages/bzip2.1.0.6.7
set bzip=%bzip:\=/%
set bzipinc=%bzip%/build/native/include

set zlib=%~dp0../packages/zlib.1.2.7.34
set zlib=%zlib:\=/%
set zlibinc=%zlib%/build/native/include

REM -LABEL-ARCH-FLAVOR-MSVCV-GENERATOR----------------CONV--ZLIB_LIB----BZ2_LIB-------BUILD_SHARED
REM call :build x64 static  v110 "Visual Studio 11 Win64" cdecl zlib-static libbz2-static NO
call :build x64 dynamic v110 "Visual Studio 11 Win64" cdecl zlib-static libbz2-static YES
REM call :build x64 dynamic v100 "Visual Studio 10 Win64" cdecl zlib-static libbz2-static YES
REM call :build x64 static  v100 "Visual Studio 10 Win64" cdecl zlib-static libbz2-static NO
REM call :build x86 static  v110 "Visual Studio 11"       cdecl zlib-static libbz2-static NO
REM call :build x86 dynamic v110 "Visual Studio 11"       cdecl zlib-static libbz2-static YES
REM call :build x86 dynamic v100 "Visual Studio 10"       cdecl zlib-static libbz2-static YES
REM call :build x86 static  v100 "Visual Studio 10"       cdecl zlib-static libbz2-static NO

popd
goto :eof
REM ========== CONFIGURE & BUILD ===========

:build

cd ..
set targetdir=~%0.%1.%2.%3
mkdir %targetdir%
pushd %targetdir% 
REM del /Q /S *
set bziplib=%bzip%/build/native/lib/%0/%2/%1/%4/
set zliblib=%zlib%/build/native/lib/%0/%2/%1/%4/
echo on

cmake ^
	-DBUILD_SHARED_LIBS:bool=%7 ^
	-DCMAKE_C_FLAGS_DEBUG:string="/MTd" ^
	-DCMAKE_C_FLAGS_RELEASE:string="/MT" ^
	-DPCRE_BUILD_PCRECPP:bool=YES ^
	-DPCRE_SUPPORT_UNICODE_PROPERTIES:bool=YES ^
	-DPCRE_SUPPORT_JIT:bool=NO ^
	-DPCRE_BUILD_PCRE32:bool=YES ^
	-DZLIB_INCLUDE_DIR:string=%zlibinc% ^
	-DZLIB_LIBRARY_DEBUG:string=%zliblib%Debug/%5.lib ^
	-DZLIB_LIBRARY_RELEASE:string=%zliblib%Release/%5.lib ^
	-DBZIP2_INCLUDE_DIR:string=%bzipinc% ^
	-DBZIP2_LIBRARY_RELEASE:string="%bziplib%Release/%6.lib" ^
	-DBZIP2_LIBRARY_DEBUG:string="%bziplib%Debug/%6.lib" ^
	-G "Visual Studio 11 Win64" ..
IF %ERRORLEVEL% NEQ 0 GOTO end 

msbuild /m /p:Configuration=Release ALL_BUILD.vcxproj
msbuild /m /p:Configuration=Debug ALL_BUILD.vcxproj
:end
popd