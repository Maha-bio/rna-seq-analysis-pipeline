############################################################
## Functional enrichment analysis
## DESeq2 -> GO / KEGG
############################################################

suppressPackageStartupMessages({

library(clusterProfiler)
library(org.Mm.eg.db)
library(enrichplot)
library(ggplot2)
library(readr)
library(dplyr)

})


############################################################
# Import DESeq2 results
############################################################

res <- read.csv(
    "results/deseq2/DESeq2_results.csv",
    row.names = 1
)


############################################################
# Prepare significant genes
############################################################

sig <- res %>%
    filter(
        padj < 0.05,
        abs(log2FoldChange) > 1
    )


cat("Nombre de gènes différentiellement exprimés :",
    nrow(sig), "\n")


############################################################
# Up / Down regulated
############################################################

up <- sig %>%
    filter(log2FoldChange > 1)

down <- sig %>%
    filter(log2FoldChange < -1)


############################################################
# Convert Ensembl -> Entrez
############################################################

convert_ids <- function(x){

    bitr(
        x,
        fromType="ENSEMBL",
        toType="ENTREZID",
        OrgDb=org.Mm.eg.db
    )

}


up_ids <- convert_ids(rownames(up))
down_ids <- convert_ids(rownames(down))


############################################################
# GO Biological Process
############################################################

ego_up <- enrichGO(
    gene = up_ids$ENTREZID,
    OrgDb = org.Mm.eg.db,
    ont = "BP",
    pAdjustMethod = "BH",
    pvalueCutoff = 0.05,
    readable = TRUE
)


ego_down <- enrichGO(
    gene = down_ids$ENTREZID,
    OrgDb = org.Mm.eg.db,
    ont = "BP",
    pAdjustMethod = "BH",
    pvalueCutoff = 0.05,
    readable = TRUE
)


############################################################
# KEGG
############################################################

kegg_up <- enrichKEGG(
    gene = up_ids$ENTREZID,
    organism = "mmu",
    pvalueCutoff = 0.05
)


kegg_down <- enrichKEGG(
    gene = down_ids$ENTREZID,
    organism = "mmu",
    pvalueCutoff = 0.05
)


############################################################
# Save tables
############################################################

write.csv(
    as.data.frame(ego_up),
    "results/enrichment/GO_BP_upregulated.csv"
)

write.csv(
    as.data.frame(ego_down),
    "results/enrichment/GO_BP_downregulated.csv"
)


write.csv(
    as.data.frame(kegg_up),
    "results/enrichment/KEGG_upregulated.csv"
)

write.csv(
    as.data.frame(kegg_down),
    "results/enrichment/KEGG_downregulated.csv"
)


############################################################
# Plots
############################################################


png(
"results/enrichment/GO_up_dotplot.png",
width=1200,
height=900,
res=150
)

dotplot(
    ego_up,
    showCategory=15
)

dev.off()



png(
"results/enrichment/GO_down_dotplot.png",
width=1200,
height=900,
res=150
)

dotplot(
    ego_down,
    showCategory=15
)

dev.off()



png(
"results/enrichment/KEGG_up_dotplot.png",
width=1200,
height=900,
res=150
)

dotplot(
    kegg_up,
    showCategory=15
)

dev.off()


cat("\nEnrichment analysis completed successfully\n")
