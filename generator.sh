#! /bin/sh

echo "aaa"

set -x

here=$PWD

rm -rf test
mkdir test
cd test

python ${CMTROOT}/generator.py projects=1 packages=8

hwaf init A
cd A
hwaf setup
hwaf configure
hwaf
hwaf show pck-tree
hwaf run testA_A

cd ${here}


