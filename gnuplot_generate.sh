#!/bin/bash

limit="1.5"

boxwidth=0.5
pointsize=1.5

export limit

export boxwidth
export pointsize

rm -rf data
rm -rf plot

mkdir -p data/dgemm/regroup
mkdir -p data/dotprod/regroup
mkdir -p data/reduc/regroup

mkdir -p data/dgemm/table
mkdir -p data/dotprod/table
mkdir -p data/reduc/table

mkdir -p plot/dgemm/regroup
mkdir -p plot/dotprod/regroup
mkdir -p plot/reduc/regroup

./generate/generate_data.sh
./generate/generate_group.sh
./generate/gnuplot_histo.sh

./generate/generate_regroup.sh
./generate/gnuplot_graph.sh