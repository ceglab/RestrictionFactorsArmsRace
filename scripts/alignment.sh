#!/bin/bash
# /home/aclab/alignment/DNA_alignment/Pan_paniscus/alignment.sh /home/aclab/alignment/DNA_alignment/Pan_paniscus/index/Pan_paniscus.panpan1.1.dna_sm.toplevel.fa /home/aclab/alignment/DNA_alignment/Pan_paniscus/
ref=$1
path=$2
#loop for single end 
for i in `ls -1 $path/*.fastq.gz|grep -v "_2.fastq.gz"|grep -v "_1.fastq.gz"`
do
bwa mem -t 22 $ref $i -o "$i".sam 
done
wait
#move single paired sam file in directory
mkdir single_sam
mv $path/*.sam single_sam/
#loop for double paired sam
for i in `ls -1 $path/*_2.fastq.gz`
do
j=`echo $i|sed 's/_2/_1/g'`
bwa mem -t 22 $ref $i $j -o "$i".sam 
done
wait
#move paired sam to diff. directory
mkdir paired_sam
mv $path/*.sam paired_sam/
#loop to sort sam files
cd single_sam 
for i in `ls -1 *.sam`
do
samtools view -@10 -bhS $i -o "$i".bam
samtools sort -@10 "$i".bam -o "$i".sorted.bam
done
cd ..
cd paired_sam
for i in `ls -1 *.sam`
do
samtools view -@10 -bhS $i -o "$i".bam
samtools sort -@10 "$i".bam -o "$i".sorted.bam
done
cd ..




