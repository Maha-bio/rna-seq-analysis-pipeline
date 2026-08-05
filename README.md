# Reproducible RNA-seq Analysis Pipeline with Snakemake

## Project Overview

This repository contains a **fully reproducible RNA-seq analysis workflow** developed using **Snakemake**.

The pipeline implements a standard transcriptomics workflow commonly used in genomics and molecular biology research laboratories, starting from raw sequencing reads and producing differential expression results and biological interpretation.

The workflow integrates:

- Raw sequencing quality control
- Read preprocessing
- Transcript-level quantification
- Transcript-to-gene summarization
- Differential gene expression analysis
- Functional enrichment analysis

The complete computational environment is managed using **Conda** to ensure reproducibility across systems.

---

## Pipeline Workflow

```text
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

## Workflow Execution

The complete analysis is automated through **Snakemake**.

Run the entire pipeline:

```bash
snakemake --cores 4
```

---

## Biological Dataset

### Organism

**Mus musculus (mouse)**

Reference annotation:

- Genome assembly: **GRCm38 / mm10**
- Annotation source: **GENCODE release M25**

### Experimental Design

The dataset contains two biological conditions:

| Sample ID | Condition |
|-----------|-----------|
| SRR1552444 | Control |
| SRR1552445 | Control |
| SRR1552446 | Case |
| SRR1552447 | Case |

Experimental metadata is stored in:

```text
data/sample_metadata.csv
```

---

## Computational Tools

### Quality Control

| Tool | Purpose |
|------|---------|
| FastQC | Read quality assessment |
| MultiQC | Aggregated QC reporting |

### Quantification

| Tool | Purpose |
|------|---------|
| Salmon | Transcript abundance estimation |

### Statistical Analysis

| Tool | Purpose |
|------|---------|
| tximport | Transcript-level to gene-level summarization |
| DESeq2 | Differential expression analysis |

### Functional Annotation

| Tool | Purpose |
|------|---------|
| clusterProfiler | GO and KEGG enrichment |
| org.Mm.eg.db | Mouse gene annotation |

### Programming

- R
- Bash
- Conda

---

## Repository Structure

```text
rna-seq-analysis-pipeline/

├── Snakefile
├── environment.yml
├── README.md
│
├── config/
│   └── config.yaml
│
├── data/
│   ├── sample_metadata.csv
│   └── reference/
│       └── tx2gene.csv
│
├── scripts/
│   └── R/
│       ├── create_tx2gene.R
│       ├── deseq2_analysis.R
│       └── enrichment_GO_KEGG.R
│
└── results/
    └── example/
        ├── PCA.png
        ├── MA_plot.png
        ├── Volcano_plot.png
        └── Heatmap.png
```

---

## Installation

### Clone Repository

```bash
git clone https://github.com/Maha-bio/rna-seq-analysis-pipeline.git
cd rna-seq-analysis-pipeline
```

### Create Reproducible Environment

```bash
conda env create -f environment.yml
```

Activate the environment:

```bash
conda activate rnaseq
```

The environment contains:

- R 4.5
- Bioconductor packages
- Salmon
- FastQC
- MultiQC
- DESeq2
- clusterProfiler

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

## Workflow Outputs

### Quality Control

Generated reports:

```text
results/fastqc/
results/multiqc/
```

### Salmon Quantification

Transcript abundance estimation:

```text
results/salmon/<sample>/quant.sf
```

Each quantification file contains:

```text
Name
Length
EffectiveLength
TPM
NumReads
```

### Transcript-to-Gene Mapping

The workflow generates:

```text
data/reference/tx2gene.csv
```

This table links transcript identifiers to gene identifiers for downstream analysis.

### Differential Expression Analysis

DESeq2 performs:

- library normalization
- dispersion estimation
- statistical testing
- multiple testing correction

Generated outputs:

```text
results/deseq2/

├── DESeq2_results.csv
├── normalized_counts.csv
├── PCA.png
├── MA_plot.png
├── Volcano_plot.png
└── Heatmap.png
```

### Functional Enrichment Analysis

Functional interpretation is performed using:

- Gene Ontology (GO)
- KEGG pathways

Results:

```text
results/enrichment/
```
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

* Conda-based environment management
* Version-controlled scripts
* Structured project organization
* Automated result generation
* Separation of raw data, scripts and results
* Documented workflow

---

# Planned improvements

* Nextflow version
* Docker/Singularity containerization
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

