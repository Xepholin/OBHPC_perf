#!/bin/bash

for i in dgemm dotprod reduc
do

    for k in gcc clang
    do

        for j in 0 1 2 3 fast
        do

            a=8

            if [ "$i" = "dgemm" ]
            then
                for m in {1..5}
                do
                    taskset -c 2 ./$i/$i 1 1 > temp
                    grep title temp > data/$i/table/$i-$k$j-$a.csv
                    rm temp

                    for n in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
                    do
                        cat $i/$k/$j/$a/$n.dat >> data/$i/table/$i-$k$j-$a.csv
                    done

                    a=$(($a*2))
                done
            else
                for m in {1..14}
                do
                    taskset -c 2 ./$i/$i 1 1 > temp
                    grep title temp > data/$i/table/$i-$k$j-$a.csv
                    rm temp

                    for n in BASE UNROLL4 UNROLL8 CBLAS
                    do
                        cat $i/$k/$j/$a/$n.dat >> data/$i/table/$i-$k$j-$a.csv
                    done

                    a=$(($a*2))
                done
            fi
        done
    done
done