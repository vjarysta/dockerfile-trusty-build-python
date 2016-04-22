# dockerfile-trusty-build-python

[![Build Status](https://travis-ci.org/infOpen/dockerfile-trusty-build-python.svg?branch=master)](https://travis-ci.org/infOpen/dockerfile-trusty-build-python)

Dockerfile used to build a base jenkins slave image used to build ubuntu packages for python apps

## Warning

We use gosu to build packages with a non root user.
To be used with jenkins user, need to set setuid so take care about commands
launch in container with gosu.

