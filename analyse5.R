setwd("C:/Users/carla/Documents/rna_seq")
count <- read.table("count_arrange.txt", header = TRUE)
library("DESeq2")


condition=as.factor(c(rep("lung",5), rep("control_lung",3),
                            rep( "blood",5), rep("control_blood",3)))


cts=as.matrix(count[2:17])
rownames(cts)=count$Geneid

coldata=data.frame(condition)
rownames(coldata)=colnames(cts)

dds=DESeqDataSetFromMatrix(cts, coldata , design =  ~as.matrix(condition))

dds=DESeq(dds)

dds=vst(dds, blind=T)
plotPCA(dds, main="PCA")

'''
lung=round(rowMeans(count[colnames(count)[2:6]]))
control_lung=rowMeans(count[colnames(count)[7:9]])
blood=rowMeans(count[colnames(count)[10:14]])
control_blood=rowMeans(count[colnames(count)[15:17]])
'''




DESeqDataSetFromMatrix(countData, data.frame(colData) , design=~colData )

'''
treatment2=count[c("Geneid","SRR7821949_sorted.bam",
                             "SRR7821953_sorted.bam",
                             "SRR7821950_sorted.bam",
                             "SRR7821951_sorted.bam",
                             "SRR7821952_sorted.bam")]

control=count[c("Geneid","SRR7821937_sorted.bam",
                           "SRR7821938_sorted.bam",
                           "SRR7821939_sorted.bam")]

control2=count[c("Geneid","SRR7821968_sorted.bam",
                           "SRR7821969_sorted.bam",
                           "SRR7821970_sorted.bam")]
'''
packageVersion("DESeq2")

      