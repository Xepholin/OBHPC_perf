#!/bin/bash

for i in dgemm dotprod reduc
do
    for j in gcc clang
    do
        for k in 0 1 2 3 fast
        do
            a=8

            if [ "$i" = "dgemm" ];
            then
                for l in {1..5}
                do
                    for m in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
                    do
                        touch data/$i/$i-$a-$m.dat
                        lines=$(wc -l < data/$i/$i-$a-$m.dat)
                        if [ $lines -eq 0 ];
                        then
                            printf "$m ; MiB/s\n" >> data/$i/$i-$a-$m.dat
                        fi

                        awk -F '[;( )]+' -v j="$j" -v k="$k" '{debit=$14} END {print j k, ";", debit;}' $i/$j/$k/$a/$m.dat >> data/$i/$i-$a-$m.dat
                    done

                    a=$(($a*2))
                done
            else
                for l in {1..14}
                do
                    for m in BASE UNROLL4 UNROLL8 CBLAS
                    do  
                        touch data/$i/$i-$a-$m.dat
                        lines=$(wc -l < data/$i/$i-$a-$m.dat)
                        if [ $lines -eq 0 ];
                        then
                            printf "$m ; MiB/s\n" >> data/$i/$i-$a-$m.dat
                        fi

                        awk -F '[;( )]+' -v j="$j" -v k="$k" '{debit=$15} END {print j k, ";", debit;}' $i/$j/$k/$a/$m.dat >> data/$i/$i-$a-$m.dat
                    done

                    a=$(($a*2))
                done
            fi
        done
    done
done