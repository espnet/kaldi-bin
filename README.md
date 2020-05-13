# kaldi-bin

## Upload

```bash
tag="v0.0.3"
git tag ${tag}
git push origin ${tag} # Run CI on tag
```

You can get the binary from assets

```
wget https://github.com/espnet/kaldi-bin/releases/download/${tag}/ubuntu-latest-featbin.tar.gz
```

## TODO

Create Binaries for CentOS and MacOSX
