#!/bin/sh

mkdir build
cd build


if [[ ! -z "${cuda_compiler_version+x}" && "${cuda_compiler_version}" != "None" ]]
then
    CUDA_ENABLED=ON
else
    CUDA_ENABLED=OFF
fi


cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DBOOST_STATIC=OFF \
      -DCUDA_ENABLED=${CUDA_ENABLED} \
      -DBUILD_SHARED_LIBS=ON \
      ..

cmake --build . --config Release -- -j$CPU_COUNT
cmake --build . --config Release --target install
