pushd %~dp0\..
del CMakeCache.txt

mkdir ~vc11.x64
cd ~vc11.x64
cmake -G "Visual Studio 11 Win64" ..
msbuild /m /p:Configuration=Release pcre.sln
msbuild /m /p:Configuration=Debug pcre.sln

pause

cd ..
del CMakeCache.txt

mkdir ~vc11.x86
cd ~vc11.x86
cmake -G "Visual Studio 11" ..
msbuild /m /p:Configuration=Release pcre.sln
msbuild /m /p:Configuration=Debug pcre.sln


mkdir ~vc10.x64
cd ~vc10.x64
cmake -G "Visual Studio 10 Win64" ..
msbuild /m /p:Configuration=Release pcre.sln
msbuild /m /p:Configuration=Debug pcre.sln


mkdir ~vc10.x86
cd ~vc10.x86
cmake -G "Visual Studio 10" ..
msbuild /m /p:Configuration=Release pcre.sln
msbuild /m /p:Configuration=Debug pcre.sln

popd