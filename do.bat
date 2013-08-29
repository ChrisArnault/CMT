
rmdir /S/Q test
mkdir test
cd test
python ..\generator.py projects=3 packages=8
dot -Tjpg generator.dot >generator.jpg
cd ..


