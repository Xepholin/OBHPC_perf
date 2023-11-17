#!/bin/bash

for i in dgemm dotprod reduc
do
    for k in gcc0 gcc1 gcc2 gcc3 gccfast clang0 clang1 clang2 clang3 clangfast
    do
        a=8

        if [ "$i" = "dgemm" ];
        then

            for j in {1..5}
            do
                for m in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
                do
                    touch data/$i/regroup/$i-$k-$m.dat
                    lines=$(wc -l < data/$i/regroup/$i-$k-$m.dat)
                    if [ $lines -eq 0 ];
                    then
                        printf "$m ; MiB/s ; n\n" >> data/$i/regroup/$i-$k-$m.dat
                    fi

                    grep $k data/$i/$i-$a-$m.dat | tr -d '\n' >> data/$i/regroup/$i-$k-$m.dat
                    printf " ; $a\n" >> data/$i/regroup/$i-$k-$m.dat
                done

                a=$(($a*2))
            done
        else
            for j in {1..14}
            do
                for n in BASE UNROLL4 UNROLL8 CBLAS
                do
                    touch data/$i/regroup/$i-$k-$n.dat
                    lines=$(wc -l < data/$i/regroup/$i-$k-$n.dat)
                    if [ $lines -eq 0 ];
                    then
                        printf "$m ; MiB/s ; n\n" >> data/$i/regroup/$i-$k-$n.dat
                    fi

                    grep $k data/$i/$i-$a-$n.dat | tr -d '\n' >> data/$i/regroup/$i-$k-$n.dat
                    printf " ; $a\n" >> data/$i/regroup/$i-$k-$n.dat
                done

                a=$(($a*2))
            done
        fi
    done
done