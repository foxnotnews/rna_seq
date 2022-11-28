#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=04:30:00
#SBATCH --job-name=samtool_sort
#SBATCH --mail-user=carla.andrade@students.unibe.ch
#SBATCH --mail-type=begin,end


REF=/data/courses/rnaseq_course/toxoplasma_de/reference

module load UHTS/Analysis/subread/2.0.1



featureCounts -p -C -s 2 -Q 10 -T 4 -a $REF/Mus_musculus.GRCm39.108.gtf.gz -o count.txt *_sorted.bam 
