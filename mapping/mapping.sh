#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8000M
#SBATCH --time=04:30:10
#SBATCH --job-name=hisat_mapping
#SBATCH --mail-user=carla.andrade@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --array=0-15

# Add all the necessary modules for mapping
module add UHTS/Aligner/hisat/2.2.1

# Calling the files directories and names of fasta files as variables
INDEX_DIR=/data/courses/rnaseq_course/toxoplasma_de/reference/hisat2
READ_DIR=/data/courses/rnaseq_course/toxoplasma_de/reads
NAMES=("SRR7821918" "SRR7821919" "SRR7821920" "SRR7821921" "SRR7821922" "SRR7821937" "SRR7821938" "SRR7821939" "SRR7821949" "SRR7821950" "SRR7821951" "SRR7821952" "SRR7821953" "SRR7821968" "SRR7821969" "SRR7821970")

# Run hisat2 mapping jobs
hisat2 -x $INDEX_DIR/Mus_musculus.GRCm39.dna.primary_assembly.fa -1 $READ_DIR/${NAMES[$SLURM_ARRAY_TASK_ID]}_1.fastq.gz -2 $READ_DIR/${NAMES[$SLURM_ARRAY_TASK_ID]}_2.fastq.gz -S ${NAMES[$SLURM_ARRAY_TASK_ID]}.sam -p 4 --rna-strandness RF


module add UHTS/Analysis/samtools/1.10
samtools view -hbS  ${NAMES[$SLURM_ARRAY_TASK_ID]}.sam >  ${NAMES[$SLURM_ARRAY_TASK_ID]}.bam
