source /usr/local/extras/Genomics/.bashrc

genome=ntEditTTPHk65

cd NO-HET-ragtag.scaffold.500.org_w100000
mkdir results
cd results

wc -l ../combined/* | grep " 984 " | cut -f 3 -d '/' > Completed_fragments.txt

cat Completed_fragments.txt | while read line ; do cat ../combined/"$line" | sed -e '/Sample:/{n;N;N;N;N;N;N;N;N;N;d}'  |  grep "Sample:" -A 1 | sed -e '/^--$/,+d' | grep -v "Fil" | sed 's/1\s2\s3\s4\s5\s6/NA/g' > "$line".1 ; done

paste *1 > COMBO

rm *HMMploidy.1

split -l 1 --numeric-suffixes=1 -a 4 COMBO

sed 's/\s/\n/g' -i x00*

ls x* | while read line ; do grep -c "NA" "$line" >> count_"$line" ; done
ls x* | while read line ; do grep -c "1" "$line" >> count_"$line" ; done
ls x* | while read line ; do grep -c "2" "$line" >> count_"$line" ; done
ls x* | while read line ; do grep -c "3" "$line" >> count_"$line" ; done
ls x* | while read line ; do grep -c "4" "$line" >> count_"$line" ; done
ls x* | while read line ; do grep -c "5" "$line" >> count_"$line" ; done
ls x* | while read line ; do grep -c "6" "$line" >> count_"$line" ; done

paste count_x00* > V1.Results


rm count_x00* COMBO x00*



