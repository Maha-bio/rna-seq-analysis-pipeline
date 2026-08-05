############################################################
## RNA-seq Differential Expression Analysis
## Author: Maha
## Pipeline: Salmon -> tximport -> DESeq2
############################################################

suppressPackageStartupMessages({

library(tximport)
library(DESeq2)
library(readr)
library(ggplot2)
library(pheatmap)
library(EnhancedVolcano)

})

############################################################
# Metadata
############################################################
samples <- read.csv(
    "data/sample_metadata.csv",
    stringsAsFactors = FALSE
)

rownames(samples) <- samples$sample


############################################################
# Salmon files
############################################################


files <- file.path(
    "results/salmon",
    rownames(samples),
    "quant.sf"
)

names(files) <- rownames(samples)


print("Fichiers Salmon détectés :")
print(files)

print("Existence des fichiers :")
print(file.exists(files))


if(!all(file.exists(files))){
    stop("Certains fichiers quant.sf sont introuvables")
}





############################################################
# tx2gene
############################################################

tx2gene <- read.csv(
    "/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/data/reference/tx2gene.csv"
)

############################################################
# Import Salmon
############################################################

txi <- tximport(
    files,
    type="salmon",
    tx2gene=tx2gene,
    ignoreTxVersion=TRUE
)

############################################################
# DESeq2 object
############################################################

dds <- DESeqDataSetFromTximport(
    txi,
    colData=samples,
    design=~condition
)

############################################################
# Filtering
############################################################

dds <- dds[rowSums(counts(dds)) >= 10, ]

############################################################
# Differential expression
############################################################

dds <- DESeq(dds)

############################################################
# Results
############################################################

res <- results(dds)

res <- res[order(res$padj), ]

############################################################
# Output
############################################################

dir.create("/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2",
           showWarnings = FALSE)

############################################################
# Save results
############################################################

res_df <- as.data.frame(res)

write.csv(
    res_df,
    "/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2/DESeq2_results.csv"
)

top100 <- head(res_df[order(res_df$padj), ], 100)

write.csv(
    top100,
    "/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/DESeq2_results_top100.csv"
)
write.csv(
    counts(dds, normalized=TRUE),
    "/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2/normalized_counts.csv"
)

############################################################
# PCA
############################################################

vsd <- vst(dds)

png(
"/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2/PCA.png",
width=1200,
height=900,
res=150
)

plotPCA(vsd, intgroup="condition")

dev.off()

############################################################
# MA plot
############################################################

png(
"/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2/MA_plot.png",
width=1200,
height=900,
res=150
)

plotMA(res)

dev.off()

############################################################
# Volcano
############################################################

png(
"/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2/Volcano_plot.png",
width=1400,
height=1200,
res=180
)

EnhancedVolcano(

res,

lab=rownames(res),

x="log2FoldChange",

y="padj"

)

dev.off()

############################################################
# Heatmap
############################################################



top <- head(order(rowVars(assay(vsd)), decreasing = TRUE), 50)

ann <- data.frame(condition = samples$condition)
rownames(ann) <- rownames(samples)

png(
    "/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/results/deseq2/Heatmap.png",
    width = 1200,
    height = 1200,
    res = 180
)

pheatmap(
    assay(vsd)[top, ],
    scale = "row",
    annotation_col = ann,
    show_rownames = FALSE,
    clustering_distance_rows = "euclidean",
    clustering_distance_cols = "euclidean"
)

dev.off()
############################################################

cat("\nAnalysis completed successfully!\n")
