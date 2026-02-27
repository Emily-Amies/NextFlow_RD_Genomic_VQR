/*
 * Convert SAM/BAM to filtered, sorted BAM (MAPQ >= 30)
 */
process sortBam {

    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_medium'
    }

    container 'variantvalidator/indexgenome:1.1.0'

    tag "$sample_id"

    input:
    tuple val(sample_id), path(alnFile)

    output:
    tuple val(sample_id), path("${sample_id}_filtered_sorted.bam")

    script:
    """
    echo "Running Sort and Filter (MAPQ >= 30) for ${sample_id}"
    echo "Input: ${alnFile}"

    # -S lets samtools auto-detect SAM/BAM; -h keeps headers; -q filters MAPQ
    samtools view -h -q 30 -b ${alnFile} | samtools sort -o ${sample_id}_filtered_sorted.bam -

    echo "BAM Sorting and Filtering complete for ${sample_id}"
    """
}
