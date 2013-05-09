
pushd %~dp0..
del CMakeCache.txt
mkdir packages
cd packages
nuget install bzip2
nuget install zlib

REM ========== SET UP LIBRARIES ===============

set bzip=%~dp0../packages/bzip2.1.0.6.7
set bzip=%bzip:\=/%
set bzipinc=%bzip%/build/native/include

set zlib=%~dp0../packages/zlib.1.2.7.34
set zlib=%zlib:\=/%
set zlibinc=%zlib%/build/native/include

REM ========== BUILD 64-BIT MSVC 11 ===========
cd ..
mkdir ~vc11.x64
cd ~vc11.x64
del /Q /S *
set bziplib=%bzip%/build/native/lib/x64/v110/static/cdecl/
set zliblib=%zlib%/build/native/lib/x64/v110/static/cdecl/
echo on

cmake ^
	-DCMAKE_C_FLAGS_DEBUG:string="/MTd" ^
	-DCMAKE_C_FLAGS_RELEASE:string="/MT" ^
	-DPCRE_BUILD_PCRECPP:bool=YES ^
	-DPCRE_SUPPORT_UNICODE_PROPERTIES:bool=YES ^
	-DPCRE_SUPPORT_JIT:bool=NO ^
	-DPCRE_BUILD_PCRE32:bool=YES ^
	-DZLIB_INCLUDE_DIR:string=%zlibinc% ^
	-DZLIB_LIBRARY_DEBUG:string=%zliblib%Debug/zlib-static.lib ^
	-DZLIB_LIBRARY_RELEASE:string=%zliblib%Release/zlib-static.lib ^
	-DBZIP2_INCLUDE_DIR:string=%bzipinc% ^
	-DBZIP2_LIBRARY_RELEASE:string="%bziplib%Release/libbz2-static.lib" ^
	-DBZIP2_LIBRARY_DEBUG:string="%bziplib%Debug/libbz2-static.lib" ^
	-G "Visual Studio 11 Win64" ..
IF %ERRORLEVEL% NEQ 0 GOTO end 

msbuild /m /p:Configuration=Release ALL_BUILD.vcxproj
msbuild /m /p:Configuration=Debug ALL_BUILD.vcxproj



REM ========== BUILD 32-BIT MSVC 11 ===========
cd ..
mkdir ~vc11.x86
cd ~vc11.x86
del /Q /S *
set bziplib=%bzip%/build/native/lib/Win32/v110/static/cdecl/
set zliblib=%zlib%/build/native/lib/Win32/v110/static/cdecl/
cmake ^
	-DCMAKE_C_FLAGS_DEBUG:string="/MTd" ^
	-DCMAKE_C_FLAGS_RELEASE:string="/MT" ^
	-DPCRE_BUILD_PCRECPP:bool=YES ^
	-DPCRE_SUPPORT_UNICODE_PROPERTIES:bool=YES ^
	-DPCRE_SUPPORT_JIT:bool=NO ^
	-DPCRE_BUILD_PCRE32:bool=YES ^
	-DZLIB_INCLUDE_DIR:string=%zlibinc% ^
	-DZLIB_LIBRARY_DEBUG:string=%zliblib%Debug/zlib-static.lib ^
	-DZLIB_LIBRARY_RELEASE:string=%zliblib%Release/zlib-static.lib ^
	-DBZIP2_INCLUDE_DIR:string=%bzipinc% ^
	-DBZIP2_LIBRARY_RELEASE:string="%bziplib%Release/libbz2-static.lib" ^
	-DBZIP2_LIBRARY_DEBUG:string="%bziplib%Debug/libbz2-static.lib" ^
	-G "Visual Studio 11" ..
msbuild /m /p:Configuration=Release ALL_BUILD.vcxproj
msbuild /m /p:Configuration=Debug ALL_BUILD.vcxproj

@echo off
REM pause

REM mkdir ~vc10.x64
REM cd ~vc10.x64
REM cmake -G "Visual Studio 10 Win64" ..
REM msbuild /m /p:Configuration=Release pcre.sln
REM msbuild /m /p:Configuration=Debug pcre.sln
REM 
REM 
REM mkdir ~vc10.x86
REM cd ~vc10.x86
REM cmake -G "Visual Studio 10" ..
REM msbuild /m /p:Configuration=Release pcre.sln
REM msbuild /m /p:Configuration=Debug pcre.sln

:end
popd