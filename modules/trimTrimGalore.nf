process trimTrimGalore {

    label 'process_single'
    container 'quay.io/biocontainers/trim-galore:0.6.10--hdfd78af_2'

    tag "$sample_id"
    publishDir("$params.outdir/trimGalore", mode: "symlink")

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}*.trim.fq.gz")

    script:
    def is_paired = reads.size() == 2

    if (is_paired) """
        trim_galore --paired --gzip ${reads[0]} ${reads[1]}
        
        mv *_val_1.fq.gz ${sample_id}_R1.trim.fq.gz
        mv *_val_2.fq.gz ${sample_id}_R2.trim.fq.gz
    """ else """
        trim_galore --gzip ${reads[0]}
        # Typical output is *_trimmed.fq.gz for SE
        mv *_trimmed.fq.gz ${sample_id}.trim.fq.gz
    """
}