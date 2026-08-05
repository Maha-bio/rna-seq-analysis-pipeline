#  Reproducible RNA-seq Analysis Pipeline 




## Project Overview

This repository contains a **complete and reproducible RNA-sequencing analysis workflow** developed for mouse transcriptomic data.

The pipeline implements a standard bioinformatics workflow used in genomics research laboratories, starting from raw sequencing reads and leading to biological interpretation through differential expression and pathway enrichment analyses.

The workflow integrates:

* Quality control of sequencing reads
* Transcript-level quantification
* Gene-level summarization
* Differential gene expression analysis
* Functional enrichment analysis

The entire analysis environment is managed using **Conda** to ensure reproducibility.

---

#  Pipeline Workflow

```
Raw FASTQ files
        |
        v
FastQC
(Read quality assessment)
        |
        v
MultiQC
(QC report aggregation)
        |
        v
Salmon
(Transcript abundance estimation)
        |
        v
tximport
(Transcript-to-gene summarization)
        |
        v
DESeq2
(Differential expression analysis)
        |
        v
clusterProfiler
(GO / KEGG enrichment)
        |
        v
Biological interpretation
```

---

# Biological Dataset

## Organism

**Mus musculus (mouse)**

Reference annotation:

* Genome assembly: **GRCm38 / mm10**
* Annotation source: **GENCODE release M25**

## Experimental design

The dataset contains two biological conditions:

| Sample ID  | Condition |
| ---------- | --------- |
| SRR1552444 | Control   |
| SRR1552445 | Control   |
| SRR1552446 | Case      |
| SRR1552447 | Case      |

Experimental metadata is stored in:

```
data/sample_metadata.csv
```

---

# Computational Tools

## Quality Control

| FastQC  | Read quality assessment |
| MultiQC | Aggregated QC reporting |

## Quantification

| Salmon | Transcript abundance estimation |

## Statistical Analysis

| tximport | Transcript-level to gene-level summarization |
| DESeq2   | Differential expression analysis             |

## Functional Annotation

| clusterProfiler | GO and KEGG enrichment |
| org.Mm.eg.db    | Mouse gene annotation  |

## Programming

* R
* Bash
* Conda

---

# Repository Structure

```
rna-seq-analysis-pipeline/

├── data/
│
│   ├── raw/
│   │   └── FASTQ sequencing files
│   │
│   └── reference/
│       ├── gencode.vM25.annotation.gtf
│       └── tx2gene.csv
│
├── scripts/
│
│   ├── create_tx2gene.R
│   │
│   └── R/
│       ├── deseq2_analysis.R
│       └── enrichment_GO_KEGG.R
│
├── results/
│
│   ├── fastqc/
│   ├── multiqc/
│   ├── salmon/
│   ├── deseq2/
│   └── enrichment/
│
├── environment.yml
├── sample_metadata.csv
└── README.md
```

---

# Installation

## Clone repository

```bash
git clone https://github.com/Maha-bio/rna-seq-analysis-pipeline.git

cd rna-seq-analysis-pipeline
```

---

## Create reproducible environment

```bash
conda env create -f environment.yml
```

Activate:

```bash
conda activate rnaseq
```

The environment contains:

* R 4.5
* Bioconductor packages
* Salmon
* FastQC
* MultiQC
* DESeq2
* clusterProfiler

---

# Analysis Steps

## 1. Quality Control

Run:

```bash
fastqc data/raw/*.fastq.gz \
-o results/fastqc
```

Generate summary report:

```bash
multiqc results/fastqc \
-o results/multiqc
```

---

## 2. Transcript Quantification

Salmon generates transcript abundance estimates:

```
results/salmon/<sample>/quant.sf
```

Example output:

```
Name
Length
EffectiveLength
TPM
NumReads
```

---

## 3. Transcript-to-Gene Mapping

Generate mapping table from GENCODE annotation:

```bash
Rscript scripts/create_tx2gene.R
```

Output:

```
data/reference/tx2gene.csv
```

---

## 4. Differential Expression Analysis

Run:

```bash
Rscript scripts/R/deseq2_analysis.R
```

The workflow performs:

* normalization
* dispersion estimation
* statistical testing
* adjusted p-value correction

Output:

```
results/deseq2/

├── DESeq2_results.csv
├── normalized_counts.csv
├── PCA.png
├── MA_plot.png
├── Volcano_plot.png
└── Heatmap.png
```

---

## 5. Functional Enrichment

Run:

```bash
Rscript scripts/R/enrichment_GO_KEGG.R
```

The analysis identifies enriched biological functions:

* Gene Ontology Biological Processes
* KEGG pathways

Results:

```
results/enrichment/
```

---

# Generated Visualizations

The pipeline automatically generates:

### Principal Component Analysis (PCA)

Evaluates sample clustering and experimental variation.

### MA Plot

Visualizes expression changes between conditions.

### Volcano Plot

Highlights significantly differentially expressed genes.

### Heatmap

Displays expression patterns of the most variable genes.

### GO / KEGG Dotplots

Summarizes enriched biological pathways.

---

# Reproducibility and Best Practices

This project follows bioinformatics reproducibility principles:

 Conda-based environment management
 Version-controlled scripts
 Structured project organization
 Automated result generation
 Separation of raw data, scripts and results
 Documented workflow

---

# Future Development

Planned improvements:

* Snakemake workflow automation
* Automated pipeline execution
*  Docker/Singularity containerization
* RNA-seq report generation with Quarto
* Support for paired-end sequencing
* Integration of alignment-based workflow (STAR + featureCounts)
* Interactive HTML reports

---

# Author

**Maha Abbaci**

Bioinformatics | Genomics | computational biology | AI for Healthcare

GitHub: https://github.com/Maha-bio

---

# 📄 License

This project is intended for academic, research and educational purposes.

