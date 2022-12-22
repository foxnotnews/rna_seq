#libraries and data
setwd("C:/Users/carla/Documents/rna_seq")
count <- read.table("count_arrange.txt", header = TRUE, row.names = 1)
library("DESeq2")
library("ggplot2")
library("clusterProfiler")
library("org.Mm.eg.db")
library("enrichplot")
library("gridExtra")


#data specification  for DEseq analysis 
condition=as.factor(c(rep("lung",5), rep("control_lung",3),
                            rep( "blood",5), rep("control_blood",3)))

coldata=data.frame(condition)
rownames(coldata)=colnames(count)

matrix=DESeqDataSetFromMatrix(count, coldata , design =  ~condition)

#DES
dds=DESeq(matrix)


vds=vst(dds, blind=T)
plotPCA(vds)+ggtitle("PCA")+
  theme(plot.title = element_text(hjust = 0.5)) 


packageVersion("DESeq2")


#part6 blood 

colData(dds)
resultsNames(vds)


res=results(dds, contrast = c("condition","blood", "control_blood"))
res=na.omit(res)

#DE 
nrow(res[res$padj<0.05,])

#upregulated
nrow(res[res$padj<0.05 & res$log2FoldChange >0,])


#downregulated
nrow(res[res$padj<0.05 & res$log2FoldChange <0,])


#top 10
res[with(res,order(log2FoldChange, decreasing = TRUE)),][1:10,]

res[res$padj<0.01 & res$log2FoldChange >5,][1:5]

# Lung step 6 
res2=results(dds, contrast = c("condition","lung", "control_lung"))
res2=na.omit(res2)



nrow(res2[res$pvalue<0.01,])
nrow(res2[res$pvalue<0.05,])

#DE 
nrow(res2[res$padj<0.05,])

#upregulated
nrow(res2[res2$padj<0.05 & res2$log2FoldChange >0,])


#downregulated
nrow(res2[res2$padj<0.05 & res2$log2FoldChange <0,])

#top 10
res2[with(res,order(log2FoldChange, decreasing =T)),][1:5,]

res2[res2$padj<0.01 & res2$log2FoldChange <5,]


#7
genes_to_test=rownames(res[res$log2FoldChange>0.5,])



ego <- enrichGO(gene          = genes_to_test,
                universe      = row.names(count),
                OrgDb         = "org.Mm.eg.db",
                ont           = "BP",
                keyType = "ENSEMBL")
head(ego)

a=barplot(ego)+
  ggtitle("Overrepresentation in Blood")


#7 lung

genes_to_test2=rownames(res2[res2$log2FoldChange>0.5,])



ego2 <- enrichGO(gene          = genes_to_test2,
                universe      = row.names(count),
                OrgDb         = "org.Mm.eg.db",
                ont           = "BP",
                keyType = "ENSEMBL")
head(ego)

b=barplot(ego2)+
  ggtitle("Overrepresentation in Lung")

grid.arrange(a,b,ncol=2)


      
