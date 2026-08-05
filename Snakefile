SAMPLES = [
    "SRR1552444",
    "SRR1552445",
    "SRR1552446",
    "SRR1552447"
]

rule all:
    input:
        expand("results/fastp/{sample}.trimmed.fastq.gz", sample=SAMPLES),
        "results/multiqc/multiqc_report.html",
        expand("results/salmon/{sample}/quant.sf", sample=SAMPLES),
        "data/reference/tx2gene.csv",
        "results/deseq2/DESeq2_results.csv",
        "results/enrichment/GO_BP_upregulated.csv",
        "results/enrichment/KEGG_upregulated.csv"

rule fastp:
    input:
        "data/raw/{sample}.fastq.gz"

    output:
        fastq="results/fastp/{sample}.trimmed.fastq.gz",
        html="results/fastp/{sample}.html",
        json="results/fastp/{sample}.json"

    threads: 4

    shell:
        """
        mkdir -p results/fastp

        fastp \
            --in1 {input} \
            --out1 {output.fastq} \
            --html {output.html} \
            --json {output.json} \
            --thread {threads}
        """
rule fastqc:
    input:
        "results/fastp/{sample}.trimmed.fastq.gz"

    output:
        html="results/fastqc/{sample}.trimmed_fastqc.html",
        zip="results/fastqc/{sample}.trimmed_fastqc.zip"

    shell:
        """
        mkdir -p results/fastqc

        fastqc {input} \
            --outdir results/fastqc
        """

rule multiqc:
    input:
        expand(
            "results/fastqc/{sample}.trimmed_fastqc.html",
            sample=SAMPLES
        )
    output:
        "results/multiqc/multiqc_report.html"
    shell:
        """
        multiqc results/fastqc -o results/multiqc
        """

rule salmon:
    input:
        fastq="results/fastp/{sample}.trimmed.fastq.gz"

    output:
        "results/salmon/{sample}/quant.sf"

    params:
        index="data/index/mouse_index"

    threads:
        4

    shell:
        """
        mkdir -p results/salmon/{wildcards.sample}

        salmon quant \
            -i {params.index} \
            -l A \
            -r {input.fastq} \
            -p {threads} \
            -o results/salmon/{wildcards.sample}
        """
rule create_tx2gene:
    input:
        gtf="data/reference/annotation.gtf"

    output:
        "data/reference/tx2gene.csv"

    shell:
        """
        Rscript scripts/R/create_tx2gene.R
        """
rule deseq2:
    input:
        tx2gene="data/reference/tx2gene.csv",
        quant=expand(
            "results/salmon/{sample}/quant.sf",
            sample=SAMPLES
        )

    output:
        csv="results/deseq2/DESeq2_results.csv",
        counts="results/deseq2/normalized_counts.csv",
        pca="results/deseq2/PCA.png",
        ma="results/deseq2/MA_plot.png",
        volcano="results/deseq2/Volcano_plot.png",
        heatmap="results/deseq2/Heatmap.png"

    shell:
        """
        mkdir -p results/deseq2
        Rscript scripts/R/deseq2_analysis.R
        """
rule enrichment:
    input:
        "results/deseq2/DESeq2_results.csv"

    output:
        "results/enrichment/GO_BP_upregulated.csv",
        "results/enrichment/KEGG_upregulated.csv"

    shell:
        """
        mkdir -p results/enrichment

        Rscript scripts/R/enrichment_GO_KEGG.R
        """