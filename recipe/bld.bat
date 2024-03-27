mkdir build
cd build

set EXTRA_CMAKE_ARGS=""
if NOT "%cuda_compiler_version%"=="None" (
    set EXTRA_CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=all"
    set NVCC_APPEND_FLAGS="%NVCC_APPEND_FLAGS% --use-local-env"
    set CUDA_ENABLED=ON
    :: Remove some directories from PATH
    set "PATH=%PATH:C:\\ProgramData\\Chocolatey\\bin;=%"
    set "PATH=%PATH:C:\\Program Files (x86)\\sbt\\bin;=%"
    set "PATH=%PATH:C:\\Rust\\.cargo\\bin;=%"
    set "PATH=%PATH:C:\\Program Files\\Git\\usr\\bin;=%"
    set "PATH=%PATH:C:\\Program Files\\Git\\cmd;=%"
    set "PATH=%PATH:C:\\Program Files\\Git\\mingw64\\bin;=%"
    set "PATH=%PATH:C:\\Program Files (x86)\\Subversion\\bin;=%"
    set "PATH=%PATH:C:\\Program Files\\CMake\\bin;=%"
    set "PATH=%PATH:C:\\Program Files\\OpenSSL\\bin;=%"
    set "PATH=%PATH:C:\\Strawberry\\c\\bin;=%"
    set "PATH=%PATH:C:\\Strawberry\\perl\\bin;=%"
    set "PATH=%PATH:C:\\Strawberry\\perl\\site\\bin;=%"
    set "PATH=%PATH:c:\\tools\\php;=%"
    :: Make paths like C:\\hostedtoolcache\\windows\\Ruby\\2.5.7\\x64\\bin garbage
    set "PATH=%PATH:ostedtoolcache=%"
) else (
    set CUDA_ENABLED=OFF
)

cmake ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBOOST_STATIC=OFF ^
    -DCUDA_ENABLED=%CUDA_ENABLED% ^
    -DCMAKE_CXX_FLAGS=-DNOMINMAX ^
    -DMETIS_DIR=%LIBRARY_PREFIX% ^
    -DCUDA_NVCC_FLAGS="--use-local-env" ^
    %EXTRA_CMAKE_ARGS% ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release -- -j1
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
