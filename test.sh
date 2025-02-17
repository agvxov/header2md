#!/bin/bash
bake header2md.l
./header2md.out test.h > test.md
ts-md2man -o test.1 test.md
man ./test.1
