#!/bin/bash

generate_histogram_dgemm()  {
    local title="$1"
    local output="$2"

    local ijk="$3"
    local ikj="$4"
    local iex="$5"
    local unroll4="$6"
    local unroll8="$7"
    local cblas="$8"

    gnuplot -persist <<-EOF
    reset

    set style data histograms

    set key top left

    set term png size 1280,720
    set output "$output"

    set datafile separator ";"

    set title "$title"
    set xlabel "Flags d'optimisation"
    set ylabel "Bande passante (Mib/s)"

    set lmargin at screen 0.15
    set rmargin at screen 0.9
    set bmargin at screen 0.3
    set tmargin at screen 0.85

    set xtics rotate by -45

    set style histogram clustered gap 1
    set boxwidth $boxwidth
    set style fill solid 0.5

    plot "$ijk" using 2:xtic(1) title columnheader(1), \
    "$ikj" using 2:xtic(1) title columnheader(1), \
    "$iex" using 2:xtic(1) title columnheader(1), \
    "$unroll4" using 2:xtic(1) title columnheader(1), \
    "$unroll4" using 2:xtic(1) title columnheader(1), \
    "$cblas" using 2:xtic(1) title columnheader(1)
EOF
}

generate_histogram_dotprod()    {
    local title="$1"
    local output="$2"

    local base="$3"
    local unroll4="$4"
    local unroll8="$5"
    local cblas="$6"

    gnuplot -persist <<-EOF
    reset

    set style data histograms

    set key top left

    set term png size 1280,720
    set output "$output"

    set datafile separator ";"

    set title "$title"
    set xlabel "Flags d'optimisation"
    set ylabel "Bande passante (Mib/s)"

    set lmargin at screen 0.15
    set rmargin at screen 0.9
    set bmargin at screen 0.3
    set tmargin at screen 0.85

    set xtics rotate by -45

    set style histogram clustered gap 1
    set boxwidth $boxwidth
    set style fill solid 0.5

    plot "$base" using 2:xtic(1) title columnheader(1), \
    "$unroll4" using 2:xtic(1) title columnheader(1), \
    "$unroll8" using 2:xtic(1) title columnheader(1), \
    "$cblas" using 2:xtic(1) title columnheader(1)
EOF
}

generate_histogram_reduc()    {
    local title="$1"
    local output="$2"
    
    local base="$3"
    local unroll4="$4"
    local unroll8="$5"
    local cblas="$6"

    gnuplot -persist <<-EOF
    reset

    set style data histograms

    set key top left

    set term png size 1280,720
    set output "$output"

    set datafile separator ";"

    set title "$title"
    set xlabel "Flags d'optimisation"
    set ylabel "Bande passante (Mib/s)"

    set lmargin at screen 0.15
    set rmargin at screen 0.9
    set bmargin at screen 0.3
    set tmargin at screen 0.85

    set xtics rotate by -45

    set style histogram clustered gap 1
    set boxwidth $boxwidth
    set style fill solid 0.5

    plot "$base" using 2:xtic(1) title columnheader(1), \
    "$unroll4" using 2:xtic(1) title columnheader(1), \
    "$unroll8" using 2:xtic(1) title columnheader(1), \
    "$cblas" using 2:xtic(1) title columnheader(1)
EOF
}

for i in dgemm dotprod reduc
do
    a=8

    if [ "$i" = "dgemm" ]
    then
        for j in {1..5}
        do
            generate_histogram_dgemm "$i: Histogramme des bandes passantes en fonction des flags d'optimisation, $k avec des matrices de taille $a" "plot/$i/$i-$a.png" "data/$i/$i-$a-IJK.dat" "data/$i/$i-$a-IKJ.dat" "data/$i/$i-$a-IEX.dat" "data/$i/$i-$a-UNROLL4.dat" "data/$i/$i-$a-UNROLL8.dat" "data/$i/$i-$a-CBLAS.dat"

            a=$(($a*2))
        done
    elif [ "$i" = "dotprod" ]
    then
        for j in {1..14}
        do
            generate_histogram_dotprod "$i: Histogramme des bandes passantes en fonction des flags d'optimisation, $k avec des matrices de taille $a" "plot/$i/$i-$a.png" "data/$i/$i-$a-BASE.dat" "data/$i/$i-$a-UNROLL4.dat" "data/$i/$i-$a-UNROLL8.dat" "data/$i/$i-$a-CBLAS.dat"

            a=$(($a*2))
        done
    else
        for j in {1..14}
        do
            generate_histogram_reduc "$i: Histogramme des bandes passantes en fonction des flags d'optimisation, $k avec des matrices de taille $a" "plot/$i/$i-$a.png" "data/$i/$i-$a-BASE.dat" "data/$i/$i-$a-UNROLL4.dat" "data/$i/$i-$a-UNROLL8.dat" "data/$i/$i-$a-CBLAS.dat"

            a=$(($a*2))
        done
    fi
done