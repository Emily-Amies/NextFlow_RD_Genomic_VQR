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
    def read_list = (reads instanceof List) ? reads : [reads]
    def is_paired = (read_list.size() == 2)

    // shared flags for both modes (keep experiment consistent)
    def base_flags = """
      --length_required 20 \
      --disable_quality_filtering \
      --json ${sample_id}.json \
      --html ${sample_id}.html
    """

    // optional sliding-window trimming flags
    def window_flags = params.fastp_sliding_window ? """
      --cut_front \
      --cut_tail \
      --cut_window_size 4 \
      --cut_mean_quality 20
    """ : ""

    if (is_paired) """
      echo "Running fastp (paired-end) for ${sample_id} (sliding_window=${params.fastp_sliding_window})"

      fastp \
        -i ${read_list[0]} \
        -I ${read_list[1]} \
        -o ${sample_id}_R1.trim.fq.gz \
        -O ${sample_id}_R2.trim.fq.gz \
        --detect_adapter_for_pe \
        ${base_flags} \
        ${window_flags}

      echo "fastp complete for ${sample_id}"
    """ else """
      echo "Running fastp (single-end) for ${sample_id} (sliding_window=${params.fastp_sliding_window})"

      fastp \
        -i ${read_list[0]} \
        -o ${sample_id}.trim.fq.gz \
        ${base_flags} \
        ${window_flags}

      echo "fastp complete for ${sample_id}"
    """
}
