#!/bin/bash

for i in dgemm dotprod reduc
do
    for j in gcc clang
    do
        for k in 0 1 2 3 fast
        do
            a=1

            if [ "$i" = "dgemm" ];
            then
                for l in {1..8}
                do
                    for m in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
                    do
                        touch means/$i/$i-$a-$m.dat
                        lines=$(wc -l < means/$i/$i-$a-$m.dat)
                        if [ $lines -eq 0 ];
                        then
                            printf "$m ; MiB/s\n" >> means/$i/$i-$a-$m.dat
                        fi

                        awk -F ';' -v j="$j" -v k="$k" '{sum+=$11} END {print j k, ";", sum/NR;}' $i/$j/$k/$a/$m.dat >> means/$i/$i-$a-$m.dat
                    done

                    a=$(($a*2))
                done
            else
                for l in {1..17}
                do
                    for m in BASE UNROLL4 UNROLL8 CBLAS
                    do  
                        touch means/$i/$i-$a-$m.dat
                        lines=$(wc -l < means/$i/$i-$a-$m.dat)
                        if [ $lines -eq 0 ];
                        then
                            printf "$m ; MiB/s\n" >> means/$i/$i-$a-$m.dat
                        fi

                        awk -F ';' -v j="$j" -v k="$k" '{sum+=$12} END {print j k, ";", sum/NR;}' $i/$j/$k/$a/$m.dat >> means/$i/$i-$a-$m.dat
                    done

                    a=$(($a*2))
                done
            fi
        done
    done
done