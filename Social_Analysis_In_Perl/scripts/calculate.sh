#! /bin/sh

for year in {1997..2019}
do
    echo "exe calculate.pl $year"
    perl calculate.pl $year
done