#!/bin/bash

for i in dgemm dotprod reduc
do

    (cd $i && make clean)
    (cd $i && make cleandata)

    for k in gcc clang
    do
        mkdir $i/$k

        for j in 0 1 2 3 fast
        do
            mkdir $i/$k/$j

            (cd $i && make clean)
            (cd $i && make CC=$k OFLAGS=-O$j)

            a=8

            if [ "$i" = "dgemm" ]
            then
                for m in {1..5}
                do
                    mkdir $i/$k/$j/$a
                    taskset -c 2 ./$i/$i 1 1 > temp
                    grep title temp > data/$i/table/$i-$k$j-$a.csv
                    rm temp

                    for n in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
                    do
                        count=0

                        taskset -c 2 ./$i/$i $a 33 | grep $n > $i/$k/$j/$a/$n.dat

                        b=$(awk -F '[;( )]+' 'END{print $12}' $i/$k/$j/$a/$n.dat)

                        if [ "$(bc <<< "$b < $limit")" == "1" ]
                        then
                            cat $i/$k/$j/$a/$n.dat >> data/$i/table/$i-$k$j-$a.csv
                        else
                            while [ "$(bc <<< "$b >= $limit")" == "1" ]
                            do
                                if [ $count -eq 50 ]
                                then
                                    min=$b

                                    for o in {1..40}
                                    do
                                        taskset -c 2 ./$i/$i $a 33 | grep $n >> temp
                                        b=$(awk -F '[;( )]+' 'END{print $12}' temp)

                                        if [ "$(bc <<< "$min > $b")" == "1" ]
                                        then
                                            min=$b
                                        fi
                                    done

                                    grep $min temp > $i/$k/$j/$a/$n.dat
                                    rm temp

                                    break
                                fi

                                taskset -c 2 ./$i/$i $a 33 | grep $n > $i/$k/$j/$a/$n.dat
                                b=$(awk -F '[;( )]+' 'END{print $12}' $i/$k/$j/$a/$n.dat)

                                count=$(($count+1))
                            done

                            cat $i/$k/$j/$a/$n.dat >> data/$i/table/$i-$k$j-$a.csv
                        fi
                    done

                    a=$(($a*2))
                done
            else
                for m in {1..14}
                do
                    mkdir $i/$k/$j/$a
                    taskset -c 2 ./$i/$i 1 1 > temp
                    grep title temp > data/$i/table/$i-$k$j-$a.csv
                    rm temp

                    for n in BASE UNROLL4 UNROLL8 CBLAS
                    do
                        count=0

                        taskset -c 2 ./$i/$i $a 33 | grep $n > $i/$k/$j/$a/$n.dat

                        b=$(awk -F '[;( )]+' 'END{print $13}' $i/$k/$j/$a/$n.dat)

                        if [ "$(bc <<< "$b < $limit")" == "1" ]
                        then
                            cat $i/$k/$j/$a/$n.dat >> data/$i/table/$i-$k$j-$a.csv
                        else
                            while [ "$(bc <<< "$b >= $limit")" == "1" ]
                            do
                                if [ $count -eq 50 ]
                                then
                                    min=$b

                                    for o in {1..40}
                                    do
                                        taskset -c 2 ./$i/$i $a 33 | grep $n >> temp
                                        b=$(awk -F '[;( )]+' 'END{print $13}' temp)

                                        if [ "$(bc <<< "$min > $b")" == "1" ]
                                        then
                                            min=$b
                                        fi
                                    done

                                    grep $min temp > $i/$k/$j/$a/$n.dat
                                    rm temp

                                    break
                                fi

                                taskset -c 2 ./$i/$i $a 33 | grep $n > $i/$k/$j/$a/$n.dat
                                b=$(awk -F '[;( )]+' 'END{print $13}' $i/$k/$j/$a/$n.dat)

                                count=$(($count+1))
                            done

                            cat $i/$k/$j/$a/$n.dat >> data/$i/table/$i-$k$j-$a.csv
                        fi
                    done

                    a=$(($a*2))
                done
            fi
        done
    done
done