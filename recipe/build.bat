mkdir build
cd build

set EXTRA_CMAKE_ARGS=""
if NOT "%cuda_compiler_version%"=="None" (
    set EXTRA_CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=all"
    set CUDA_ENABLED=ON
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
    -DCMAKE_CUDA_FLAGS=--use-local-env ^
    %EXTRA_CMAKE_ARGS% ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release -- -j1
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1
