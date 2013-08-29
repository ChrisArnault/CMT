CMT
===

Little environment to generate a (set of) project(s)

Each project contains a set of packages

Each package offers:
- a C++ class
- a library implementing the class
- a test program to instantiate some objects

The packages are structured to form a use graph.

A package using one or several other packages will implement the usage of objects of the used classes.

One shell script 'generator.sh' automates the testbed as follows: 

- in an empty directory
- it generates one random set of packages into one project
- it configures the project using HWAF
- it builds the project
- it tests all test programs

Operation:

1) get the generator:

```sh
> (cd /my/dev; git clone -b HWAF https://github.com/ChristianArnault/CMT.git)
```

2) produce the testbed:

```sh
> (cd /my/dev; mkdir test; cd test; /my/dev/CMT/generator.sh )
```


