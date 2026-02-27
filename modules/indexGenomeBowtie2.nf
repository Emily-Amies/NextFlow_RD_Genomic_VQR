process indexGenomeBowtie2 {

        if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_medium'
    }

    container 'quay.io/biocontainers/bowtie2:2.5.5--ha27dd3b_0'

    publishDir("$params.outdir/GENOME_IDX", mode: "copy")

    input:
    path genomeFasta

    output:
    tuple path(genomeFasta), path("${genomeFasta.baseName}.bt2*")

    script:
    """
    echo "Running Bowtie2 Indexing"

    bowtie2-build ${genomeFasta} ${genomeFasta.baseName}

    echo "Bowtie2 Indexing complete."
    """
}