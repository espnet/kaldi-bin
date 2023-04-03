#!/usr/bin/env bash

set -eu -o pipefail

if [ -z ${BUILD_OPENBLAS:-} ]; then
  build_openblas=false
else
  build_openblas=true
fi

target=$1
git_hash=$2


(
    set -eu -o pipefail

    mkdir kaldi
    cd kaldi
    git init
    git remote add origin https://github.com/kaldi-asr/kaldi
    git fetch origin ${git_hash}
    git reset --hard FETCH_HEAD
    
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
        echo "=== build portaudio ==="
        if [ "${target}" = onlinebin ]; then
          extras/install_portaudio.sh
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
        cd $target
        make -j4
    )

)

