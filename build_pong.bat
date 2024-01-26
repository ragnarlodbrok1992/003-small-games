@echo off
SET compiler_dir="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.31.31103\bin\Hostx64\x64\cl.exe"

SET SDL2INC="D:/libraries/SDL2-2.28.2/include/"
SET SDL2LIB="D:/libraries/SDL2-2.28.2/lib/x64/"
SET SDL2DLL="D:/libraries/SDL2-2.28.2/lib/x64/SDL2.dll"

echo Building Pong game...


echo Creating build folder...
if not exist "build" mkdir build

pushd build

echo %SDL2INC%
echo %SDL2LIB%

@cp %SDL2DLL% .
%compiler_dir% /Zi^
  /Fe:"pong.exe"^
  /I%SDL2INC%^
  ../games/pong/pong.c^
  /link /LIBPATH:%SDL2LIB% User32.lib Shell32.lib SDL2.lib SDL2main.lib

popd

echo Running...
.\build\pong.exe

