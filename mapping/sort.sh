#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=25000M
#SBATCH --time=04:30:00
#SBATCH --job-name=samtool_sort
#SBATCH --mail-user=carla.andrade@students.unibe.ch
#SBATCH --mail-type=begin,end
#SBATCH --array=0-15

NAMES=("SRR7821918" "SRR7821919" "SRR7821920" "SRR7821921" "SRR7821922" "SRR7821937" "SRR7821938" "SRR7821939" "SRR7821949" "SRR7821950" "SRR7821951" "SRR7821952" "SRR7821953" "SRR7821968" "SRR7821969" "SRR7821970")

module add UHTS/Analysis/samtools/1.10

samtools sort  -o ${NAMES[$SLURM_ARRAY_TASK_ID]}_sorted.bam -T temp${NAMES[$SLURM_ARRAY_TASK_ID]} ${NAMES[$SLURM_ARRAY_TASK_ID]}.bam

samtools index   ${NAMES[$SLURM_ARRAY_TASK_ID]}_sorted.bam 

