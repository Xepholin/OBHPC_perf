#!/bin/bash

make clean
make cleandata

for k in gcc clang
do
    mkdir $k

    for j in 0 1 2 3 fast
    do
        mkdir $k/$j

        make clean
        make CC=$k OFLAGS=-O$j

        a=1 

        for m in {1..17}
        do
            mkdir $k/$j/$a

            taskset -c 2 ./dotprod $a 33 > temp

            grep BASE temp >> $k/$j/$a/BASE.dat
            grep UNROLL4 temp >> $k/$j/$a/UNROLL4.dat
            grep UNROLL8 temp >> $k/$j/$a/UNROLL8.dat
            grep CBLAS temp >> $k/$j/$a/CBLAS.dat

            a=$(($a*2))
        done
    done
done

rm temp