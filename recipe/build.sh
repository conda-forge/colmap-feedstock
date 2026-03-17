#!/bin/sh

mkdir build
cd build

CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

if [[ ! -z "${cuda_compiler_version+x}" && "${cuda_compiler_version}" != "None" ]]
  then
    EXTRA_CMAKE_ARGS="-DCMAKE_CUDA_ARCHITECTURES=all -DCUDA_ENABLED=ON"
  else
    EXTRA_CMAKE_ARGS="-DCUDA_ENABLED=OFF"
fi

if [[ "$target_platform" != "osx-64" ]]; then
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DONNX_ENABLED=ON"
else
  EXTRA_CMAKE_ARGS="${EXTRA_CMAKE_ARGS} -DONNX_ENABLED=OFF"
fi

cmake ${CMAKE_ARGS} \
      -DCMAKE_BUILD_TYPE=Release \
      -DBOOST_STATIC=OFF \
      -DOPENGL_ENABLED=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DFETCH_FAISS=OFF \
      -DFETCH_POSELIB=OFF \
      -DFETCH_ONNX=OFF \
      ${EXTRA_CMAKE_ARGS} \
..

cmake --build . --config Release -- -j$CPU_COUNT
cmake --build . --config Release --target install
