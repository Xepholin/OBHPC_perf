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

        for m in {1..8}
        do
            mkdir $k/$j/$a

            taskset -c 2 ./dgemm $a 33 > temp

            grep IJK temp >> $k/$j/$a/IJK.dat
            grep IKJ temp >> $k/$j/$a/IKJ.dat
            grep IEX temp >> $k/$j/$a/IEX.dat
            grep UNROLL4 temp >> $k/$j/$a/UNROLL4.dat
            grep UNROLL8 temp >> $k/$j/$a/UNROLL8.dat
            grep CBLAS temp >> $k/$j/$a/CBLAS.dat

            a=$(($a*2))
        done
    done
done

rm temp