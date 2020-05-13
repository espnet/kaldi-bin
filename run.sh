#!/usr/bin/env bash

set -eu -o pipefail

echo "=== build kaldi ==="
(
    set -eu -o pipefail

    mkdir kaldi
    cd kaldi
    git init
    git fetch --depth=1 git://github.com/kaldi-asr/kaldi 29b3265104fc10ce3e06bfacb8f1e7ef9f16e3be
    git checkout FETCH_HEAD

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

