process trimTrimmomatic {

    label 'process_single'
    container 'quay.io/biocontainers/trimmomatic:0.40--hdfd78af_0'

    tag "$sample_id"
    publishDir("$params.outdir/trimmomatic", mode: "symlink")

    input:
    tuple val(sample_id), path(reads)
    path adapter_pe
    path adapter_se

    output:
    tuple val(sample_id), path("${sample_id}*.trim.fq.gz")

    script:
        def read_list = (reads instanceof List) ? reads : [reads]
        def is_paired = (read_list.size() == 2)
    
    if (is_paired) """
        echo "Running Trimmomatic (paired-end) for ${sample_id}"
    
        trimmomatic PE \
          ${read_list[0]} ${read_list[1]} \
          ${sample_id}_R1.trim.fq.gz ${sample_id}_R1.unpaired.fq.gz \
          ${sample_id}_R2.trim.fq.gz ${sample_id}_R2.unpaired.fq.gz \
          ILLUMINACLIP:${adapter_pe}:2:30:10 \
          SLIDINGWINDOW:4:20 \
          MINLEN:20
    """ else """
        echo "Running Trimmomatic (single-end) for ${sample_id}"
    
        trimmomatic SE \
          ${read_list[0]} \
          ${sample_id}.trim.fq.gz \
          ILLUMINACLIP:${adapter_se}:2:30:10 \
          SLIDINGWINDOW:4:20 \
          MINLEN:20
    """
}
