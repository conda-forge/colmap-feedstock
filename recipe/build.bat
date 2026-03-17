mkdir build
cd build

:: Workaround for wrong faiss_gpu reference
set "FAISS_CMAKE=%LIBRARY_PREFIX%\lib\cmake\faiss\faiss-targets.cmake"

sed -i "s|INTERFACE_LINK_LIBRARIES \".*\"|INTERFACE_LINK_LIBRARIES \"faiss\"|g" "%FAISS_CMAKE%"

type "%FAISS_CMAKE%" | findstr /C:"INTERFACE_LINK_LIBRARIES"

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
    -DONNX_ENABLED=ON ^
    -DCMAKE_CXX_FLAGS=-DNOMINMAX ^
    -DMETIS_DIR=%LIBRARY_PREFIX% ^
    -DFETCH_FAISS=OFF ^
    -DFETCH_POSELIB=OFF ^
    -DFETCH_ONNX=OFF ^
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
