#!/bin/sh

export GIT_DIR=`pwd`; cd ..; export GIT_WORK_TREE=`pwd`
git add $1
git commit -m 'auto: update markdown files'
