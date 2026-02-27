process samtoolsStats {

    label 'process_single'
    container 'quay.io/biocontainers/samtools:1.23--h96c455f_0'

    tag "$sample_id"
    publishDir("$params.outdir/samtools_stats", mode: "copy")

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    tuple val(sample_id), path("${sample_id}.samtools.stats.txt")

    script:
    """
    samtools stats ${bam} > ${sample_id}.samtools.stats.txt
    """
}