#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1000M
#SBATCH --time=02:00:10
#SBATCH --job-name=quality_check
#SBATCH --mail-user=carla.andrade@students.unibe.ch
#SBATCH --mail-type=begin,end


READS_DIR=/data/courses/rnaseq_course/toxoplasma_de/reads
QUALITY_CONTROL_DIR=/home/candrade/quality_control/


cd $READS_DIR

module load UHTS/Quality_control/fastqc/0.11.9

 fastqc  *.fastq.gz \
 --t 4 \
 --outdir $QUALITY_CONTROL_DIR


cd QUALITY_CONTROL_DIR

module load UHTS/Analysis/MultiQC/1.8;

 multiqc .