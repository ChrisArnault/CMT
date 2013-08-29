#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

here=$PWD

rm -rf test
mkdir test
cd test

python ${DIR}/generator.py projects=1 packages=8

hwaf init A
cd A
hwaf setup
hwaf configure
hwaf
hwaf show pkg-tree

for n in `find . -name 'hscript.yml'`
do
  m=`dirname $n`
  p=`basename $m`
  hwaf run test$p
done


cd ${here}


