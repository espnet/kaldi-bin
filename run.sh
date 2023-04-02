#!/usr/bin/env bash

set -eu -o pipefail

if [ -z ${BUILD_OPENBLAS:-} ]; then
  build_openblas=false
else
  build_openblas=true
fi

if [ -z $1 ]; then
   target=$1
else
   target=
fi

(
    set -eu -o pipefail

    git clone --depth=1 https://github.com/kaldi-asr/kaldi
    cd kaldi
    
    (
         set -eu -o pipefail
         cd tools
         echo "=== build sctk ==="
         bash ../../install_sctk.sh
         echo "=== build sph2pie ==="
         bash ../../install_sph2pipe.sh
         bash ../../download_openfst.sh
    )

    (
        set -eu -o pipefail

        cd tools
        ./extras/check_dependencies.sh
        # 
        if "${build_openblas}"; then
          echo "=== install openblas ==="
          extras/install_openblas.sh
        else
          echo "=== install mkl ==="
          sudo ./extras/install_mkl.sh
        fi
        make -j4
    )
    (
        set -eu -o pipefail
        echo "=== build kaldi ==="
        cd src
        if "${build_openblas}"; then
          ./configure --static --use-cuda=no --mathlib=OPENBLAS
        else
          ./configure --static --use-cuda=no
        fi
        make -j4 depend
        if [ -z $target ]; then
          make -j4
        else
          cd $target
          make -j4
        fi
    )
)

