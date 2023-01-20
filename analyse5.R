setwd("C:/Users/carla/Documents/rna_seq")
count <- read.table("count_arrange.txt", header = TRUE, row.names = 1)
library("DESeq2")
library("ggplot2")
library("clusterProfiler")
library("org.Mm.eg.db")
library("enrichplot")
library("gridExtra")
library("pheatmap")
library("stringr") 







condition=as.factor(c(rep("lung",5), rep("control_lung",3),
                            rep( "blood",5), rep("control_blood",3)))



coldata=data.frame(condition)
rownames(coldata)=colnames(count)


matrix=DESeqDataSetFromMatrix(count, coldata , design =  ~condition)

dds=DESeq(matrix)


vds=vst(dds, blind=T)
plotPCA(vds)+ggtitle("PCA")+
  theme(plot.title = element_text(hjust = 0.5)) 




#part6

#blood
res=results(dds, contrast = c("condition","blood", "control_blood"))
res=na.omit(res)

#DE 
nrow(res[res$padj<0.01,])

#upregulated
nrow(res[res$padj<0.01 & res$log2FoldChange >0,])


#downregulated
nrow(res[res$padj<0.01 & res$log2FoldChange <0,])


#top 10
res[with(res,order(log2FoldChange, decreasing = TRUE)),][1:10,]

res[res$padj<0.01 & res$log2FoldChange >5,][1:5]


##lung

res2=results(dds, contrast = c("condition","lung", "control_lung"))
res2=na.omit(res2)

#DE 
nrow(res2)
nrow(res2[res2$padj<0.01,])

#upregulated
nrow(res2[res2$padj<0.01 & res2$log2FoldChange >0,])


#downregulated
nrow(res2[res2$padj<0.01 & res2$log2FoldChange <0,])

#top 10
res2[with(res,order(log2FoldChange, decreasing =T)),][1:5,]

res2[res2$padj<0.01 & res2$log2FoldChange <5,]


#7

#blood
genes_to_test=rownames(res[ res$log2FoldChange>2,])




ego <- enrichGO(gene          = genes_to_test,
                universe      = row.names(count),
                pvalueCutoff = 0.01,
                OrgDb         = "org.Mm.eg.db",
                ont           = "ALL",
                keyType = "ENSEMBL")
head(ego)


barplot(ego)+
  ggtitle("Overrepresentation in Blood")




edox= setReadable(ego,"org.Mm.eg.db","ENSEMBL" )
edo <- pairwise_termsim(edox)




random.core.genes  <- sapply(
                          lapply(
                              str_split(as.data.frame(edox)[ ,"geneID"] , "/") ,
                            sample, size=5),      ## 5=number of random genes to select
                        paste, collapse="/")


edox@result$geneID <- random.core.genes

heatplot(edox, ,showCategory = 8)+
  ggtitle("Overrepresentation in blood")


# lung

genes_to_test2=rownames(res2[res2$log2FoldChange>2,])



ego2 <- enrichGO(gene          = genes_to_test2,
                universe      = row.names(count),
                pvalueCutoff = 0.01,
                OrgDb         = "org.Mm.eg.db",
                ont           = "ALL",
                keyType = "ENSEMBL")
head(ego)

barplot(ego2)+
  ggtitle("Overrepresentation in Lung")


edox2= setReadable(ego2,"org.Mm.eg.db","ENSEMBL" )



random.core.genes2  <- sapply(
  lapply(
    strsplit(as.data.frame(edox2)[ ,"geneID"] , "/") ,
    sample, size=3),      ## 5=number of random genes to select
  paste, collapse="/")


edox2@result$geneID <- random.core.genes2

heatplot(edox2, ,showCategory = 8, foldChange=)+
  ggtitle("Overrepresentation in Lung")






      
