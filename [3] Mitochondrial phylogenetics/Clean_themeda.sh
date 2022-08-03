#!/bin/bash
#$ -l h_rt=300:00:00
#$ -l mem=16G
#$ -l rmem=16G
#$ -pe openmp 6
#$ -v OMP_NUM_THREADS=6
#$ -m ea
#$ -M l.dunning@sheffield.ac.uk
#$ -j y
#$ -o /fastdata-sharc/bo1ltd/logs/

start=`date +%s`

source /usr/local/extras/Genomics/.bashrc

# switch to perl multithread before using IlluQC
perlbrew switch perl-5.26.1-thread

# trimmomatic adapter
adapters=/shared/dunning_lab/User/adapters

# programs
IlluQC=/usr/local/extras/Genomics/apps/ngsqcoolkit/current/QC
AmbiguityFilter=/usr/local/extras/Genomics/apps/ngsqcoolkit/current/Trimming


# output folder
out1=/fastdata-sharc/bo1ltd/Themeda_clean/1_trimmomatic
out2=/fastdata-sharc/bo1ltd/Themeda_clean/2_IlluQC
out3=/fastdata-sharc/bo1ltd/Themeda_clean/3_AmbiguityFilter
out4=/fastdata-sharc/bo1ltd/Themeda_clean/4_PRINSEQ
out5=/fastdata-sharc/bo1ltd/Themeda_clean/5_Cleaned_merged

mkdir -p ${out1} ${out2} ${out3} ${out4} ${out1}

# input data

data=/shared/dunning_lab/Shared/Themeda_Jobson/raw
ls ${data} | sed 's/_R[1|2].fastq.gz//g' | sort | uniq  > files.txt

## START HERE ## 
cat files.txt | while read line; 
  do echo "$line";
  echo "Step 1: Trimmomatic to remove adapters and to trim low quality bases; removing reads shorter than 50 bp. . . . . ";
  trimmomatic PE -threads 6 ${data}/"$line"_R1.fastq.gz ${data}/"$line"_R2.fastq.gz -baseout ${out1}/"$line".fastq_trimmomatic ILLUMINACLIP:${adapters}/TruSeq3-PE-2coo.fa:2:30:10:8:TRUE SLIDINGWINDOW:4:20 MINLEN:50;

  echo "Running FASTQC after trimmomatic. . . . . ";
  fastqc ${out1}/"$line".fastq_trimmomatic_1P -t 6;
  fastqc ${out1}/"$line".fastq_trimmomatic_2P -t 6;
  
  echo "Step 2: NGSQC Toolkit to remove reads with <80% >q20. . . . . ";
  perl ${IlluQC}/IlluQC_PRLL.pl -pe ${out1}/"$line".fastq_trimmomatic_1P ${out1}/"$line".fastq_trimmomatic_2P 2 A -l 80 -s 20 -c 6 -o ${out2}/;
  
  echo "Step 3: NGSQC Toolkit to remove any sequence with ambiguous bases. . . . . ";
  perl ${AmbiguityFilter}/AmbiguityFiltering.pl -i ${out2}/"$line".fastq_trimmomatic_1P_filtered -irev ${out2}/"$line".fastq_trimmomatic_2P_filtered -c 0;
  mv ${out2}/"$line"*filtered_trimmed ${out3}/;  
  
  echo "Step 4: PRINSEQ to remove identical duplicates. . . . . ";
  prinseq-lite.pl -fastq ${out3}/"$line".fastq_trimmomatic_1P_filtered_trimmed -fastq2 ${out3}/"$line".fastq_trimmomatic_2P_filtered_trimmed -derep 1 -out_good "$line"_prinseq -no_qual_header;
  mv ${out3}/"$line"*_prinseq* ${out4}/; # not sure where prinseq ouputs the files, so trying both
  mv "$line"*_prinseq* ${out4}/; # not sure where prinseq ouputs the files, so trying both
  
  echo "Merge both runs"; 
  cp ${out4}/"$line"_prinseq_1.fastq >> ${out5};
  cp ${out4}/"$line"_prinseq_2.fastq >> ${out5};

  echo "Gzip"; 
  gzip ${out5}/"$line"_prinseq_1.fastq;
  gzip ${out5}/"$line"_prinseq_2.fastq;

  echo "Running FASTQC after cleaning"; 
  fastqc ${out5}/"$line"_prinseq_1.fastq -t 6;
  fastqc ${out5}/"$line"_prinseq_2.fastq -t 6;

  echo "Finish sample . . . .  . . . . . . . . . . " "$line";
done

end=`date +%s`
runtime=$((end-start))

echo "This analysis took -----" ${runtime} " seconds ------- to be completed" 

