#!/bin/bash

# If no argument is given -> Downloads the most recently released
# kustomize binary to your current working directory.
# (e.g. 'install_kustomize.sh')
#
# If an argument is given -> Downloads the specified version of the
# kustomize binary to your current working directory.
# (e.g. 'install_kustomize.sh 3.8.2')
#
# Fails if the file already exists.

curl_timeout=600
release_url=https://api.github.com/repos/kubernetes-sigs/kustomize/releases

if [ -n "$1" ]; then
    version=v$1
    release_url=${release_url}/tags/kustomize/$version
fi

where=$PWD
if [ -f $where/kustomize ]; then
  echo "A file named kustomize already exists (remove it first)."
  exit 1
fi

tmpDir=`mktemp -d`
if [[ ! "$tmpDir" || ! -d "$tmpDir" ]]; then
  echo "Could not create temp dir."
  exit 1
fi

function cleanup {
  rm -rf "$tmpDir"
}

trap cleanup EXIT

pushd $tmpDir >& /dev/null

opsys=windows
arch=amd64
if [[ "$OSTYPE" == linux* ]]; then
  opsys=linux
elif [[ "$OSTYPE" == darwin* ]]; then
  opsys=darwin
fi

curl -m $curl_timeout -s $release_url |\
  grep browser_download.*${opsys}_${arch} |\
  cut -d '"' -f 4 |\
  sort | tail -n 1 |\
  xargs curl -m $curl_timeout -sLO

if [ -e ./kustomize_v*_${opsys}_amd64.tar.gz ]; then
    tar xzf ./kustomize_v*_${opsys}_amd64.tar.gz
else
    echo "Error: kustomize binary with the version ${version#v} does not exist!"
    exit 1
fi

cp ./kustomize $where

popd >& /dev/null

./kustomize version

echo kustomize installed to current directory.
