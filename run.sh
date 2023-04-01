#!/usr/bin/env bash

set -eu -o pipefail

echo "=== build kaldi ==="
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
        # extras/install_openblas.sh
        echo "=== install mkl ==="
        sudo ./extras/install_mkl.sh
        make -j4
    )
    (
        set -eu -o pipefail

        cd src
        ./configure --static --use-cuda=no # --mathlib=OPENBLAS
        make -j4 depend
        cd featbin
        make -j4
    )
)

