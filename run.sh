#!/usr/bin/env bash

set -eu -o pipefail

echo "=== build kaldi ==="
git clone https://github.com/kaldi-asr/kaldi
(
    cd kaldi
    git checkout 29b3265104fc10ce3e06bfacb8f1e7ef9f16e3be
    (
	cd tools
	./extras/check_dependencies.sh
	./extras/install_openblas.sh
	make -j
    )
    (
	cd src
	./configure --static --use-cuda=no --mathlib=OPENBLAS
	make -j depend
    )
)

echo "=== copy bins ==="