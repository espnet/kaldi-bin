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
         bash ./install_sph2pipe.sh
    )

    (
        set -eu -o pipefail

        cd tools
        ./extras/check_dependencies.sh
        # extras/install_openblas.sh
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

