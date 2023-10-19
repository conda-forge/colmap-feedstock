#!/bin/sh

mkdir build
cd build

if [[ ! -z "${cuda_compiler_version+x}" && "${cuda_compiler_version}" != "None" ]]
  then
    EXTRA_CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=all -DCUDA_ENABLED=ON"
  else
    EXTRA_CMAKE_ARGS="-DCUDA_ENABLED=OFF"
fi

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DBOOST_STATIC=OFF \
      -DBUILD_SHARED_LIBS=OFF \
      ${EXTRA_CMAKE_ARGS} \
..

cmake --build . --config Release -- -j$CPU_COUNT
cmake --build . --config Release --target install
