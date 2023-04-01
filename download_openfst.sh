#!/usr/bin/env bash

OPENFST_VERSION=1.7.2
wget --no-check-certificate -nv -T 10 -t 1 http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-${OPENFST_VERSION}.tar.gz || \
	  wget --no-check-certificate -nv -T 10 -t 3 -c https://www.openslr.org/resources/2/openfst-${OPENFST_VERSION}.tar.gz;
