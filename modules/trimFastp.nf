process trimFastp {

    label 'process_single'
    container 'quay.io/biocontainers/fastp:1.1.0--heae3180_0'

    tag "$sample_id"
    publishDir("$params.outdir/fastp", mode: "symlink")

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}*.trim.fq.gz")

    script:
    def is_paired = reads.size() == 2

    if (is_paired) """
        echo "Running fastp (paired-end) for ${sample_id}"

        fastp \
          -i ${reads[0]} \
          -I ${reads[1]} \
          -o ${sample_id}_R1.trim.fq.gz \
          -O ${sample_id}_R2.trim.fq.gz \
          --detect_adapter_for_pe \
          --qualified_quality_phred 20 \
          --length_required 50 \
          --json ${sample_id}.json \
          --html ${sample_id}.html

        echo "fastp complete for ${sample_id}"
    """ else """
        echo "Running fastp (single-end) for ${sample_id}"

        fastp \
          -i ${reads[0]} \
          -o ${sample_id}.trim.fq.gz \
          --qualified_quality_phred 20 \
          --length_required 50 \
          --json ${sample_id}.json \
          --html ${sample_id}.html

        echo "fastp complete for ${sample_id}"
    """
}