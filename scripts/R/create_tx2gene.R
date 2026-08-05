library(rtracklayer)

# Importer le fichier GTF
gtf <- import("/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/data/reference/gencode.vM25.annotation.gtf")

# Extraire uniquement les transcrits
tx <- gtf[gtf$type == "transcript"]

# Construire la table tx2gene
tx2gene <- data.frame(
    transcript_id = sub("\\..*$", "", mcols(tx)$transcript_id),
    gene_id = sub("\\..*$", "", mcols(tx)$gene_id),
    stringsAsFactors = FALSE
)

# Supprimer les doublons
tx2gene <- unique(tx2gene)

# Sauvegarder
write.csv(
    tx2gene,
    "/home/clinique/bioinformatics_projects/rna-seq-analysis-pipeline/data/reference/tx2gene.csv",
    row.names = FALSE,
    quote = FALSE
)

cat("Nombre de transcrits :", nrow(tx2gene), "\n")


