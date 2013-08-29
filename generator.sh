#! /bin/sh

echo "aaa"

set -x

here=$PWD

rm -rf test
mkdir test
cd test

python ${CMTROOT}/generator.py projects=3 packages=8

cd ${here}


