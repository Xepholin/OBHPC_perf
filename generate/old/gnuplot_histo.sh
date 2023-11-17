#!/bin/bash

generate_histogram()  {
    local title="$1"
    local file="$2"
    local output="$3"

    gnuplot -persist <<-EOF
        reset

        set title "$title"

        set style data histogram
        set terminal pngcairo enhanced font "Arial,12" size 1280,720

        set datafile separator ";"

        set output "$output"

        set boxwidth $boxwidth
        set style fill solid

        set ylabel "Bande passante MiB/s"

        plot "$file" using 2:xtic(1) title columnheader(1)
EOF
}

for i in dgemm dotprod reduc
do
    a=1

    if [ "$i" = "dgemm" ];
    then
        for j in {1..8}
        do
            for k in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
            do
                generate_histogram "$i: Histogramme des bandes passantes en fonction des flags d'optimisation, $k avec des matrices de taille $a" "means/$i/$i-$a-$k.dat" "plots/$i/$i-$a-$k.png"
            done

            a=$(($a*2))
        done
    else
        for j in {1..17}
        do
            for m in BASE UNROLL4 UNROLL8 CBLAS
            do
                generate_histogram "$i: Histogramme des bandes passantes en fonction des flags d'optimisation, $k avec des matrices de taille $a" "means/$i/$i-$a-$m.dat" "plots/$i/$i-$a-$m.png"
            done

            a=$(($a*2))
        done
    fi
done