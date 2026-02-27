/*
 * Run FASTQC on the read fastq files
 */
process FASTQC {

    label 'process_single'
    container 'variantvalidator/fastqc:0.12.1'

    tag "$sample_id"

    publishDir("$params.outdir/FASTQC", mode: "copy")

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_${params.trimming}_logs/*"

    script:
    """
    echo "Running FASTQC"

    mkdir -p fastqc_${sample_id}_${params.trimming}_logs

    if [ ${reads.size()} -eq 2 ]; then
        fastqc ${reads[0]} ${reads[1]} \
            -o fastqc_${sample_id}_${params.trimming}_logs
    else
        fastqc ${reads[0]} \
            -o fastqc_${sample_id}_${params.trimming}_logs
    fi

    echo "FASTQC Complete"
    """
}
