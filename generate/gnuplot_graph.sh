#!/bin/bash

generate_graph() {
    local title="$1"
    local file="$2"
    local output="$3"

    gnuplot <<-EOF
        reset

        set title "$title"

        set style data linespoints
        set terminal pngcairo enhanced font "Arial,12" size 1280,720

        set datafile separator ";"

        set output "$output"

        set logscale x 2

        set xlabel "n"
        set ylabel "Bande passante MiB/s"

        set pointsize $pointsize

        plot "$file" using 3:2:xtic(3) notitle
EOF
}

for i in dgemm dotprod reduc
do
    for j in gcc0 gcc1 gcc2 gcc3 gccfast clang0 clang1 clang2 clang3 clangfast
    do
        if [ "$i" = "dgemm" ];
        then
            for k in IJK IKJ IEX UNROLL4 UNROLL8 CBLAS
            do
                generate_graph "$k: Histogramme des bandes passantes en fonction des flags d'optimisation, flag: $j" "data/$i/regroup/$i-$j-$k.dat" "plot/$i/regroup/$i-$j-$k.png"
            done
        else
            for m in BASE UNROLL4 UNROLL8 CBLAS
            do
                generate_graph "$m: Graphique des bandes passantes en fonction des tailles des matrices, flag: $j" "data/$i/regroup/$i-$j-$m.dat" "plot/$i/regroup/$i-$j-$m.png"
            done
        fi
    done
done
