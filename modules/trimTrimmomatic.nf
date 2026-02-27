process trimTrimmomatic {

    label 'process_single'
    container 'quay.io/biocontainers/trimmomatic:0.40--hdfd78af_0'

    tag "$sample_id"
    publishDir("$params.outdir/trimmomatic", mode: "symlink")

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}*.trim.fq.gz")

    script:
    def is_paired = reads.size() == 2

    if (is_paired) """
        echo "Running Trimmomatic PE for ${sample_id}"

        trimmomatic PE -threads ${task.cpus ?: 1} \
          ${reads[0]} ${reads[1]} \
          ${sample_id}_R1.trim.fq.gz ${sample_id}_R1.unpaired.fq.gz \
          ${sample_id}_R2.trim.fq.gz ${sample_id}_R2.unpaired.fq.gz \
          ILLUMINACLIP:${projectDir}/assets/adapters/TruSeq3-PE.fa:2:30:10 \
          LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50

        # Keep outputs consistent with other trimmers: paired only
        rm -f ${sample_id}_R1.unpaired.fq.gz ${sample_id}_R2.unpaired.fq.gz

        echo "Trimmomatic PE complete for ${sample_id}"
    """ else """
        echo "Running Trimmomatic SE for ${sample_id}"

        trimmomatic SE -threads ${task.cpus ?: 1} \
          ${reads[0]} \
          ${sample_id}.trim.fq.gz \
          ILLUMINACLIP:${projectDir}/assets/adapters/TruSeq3-SE.fa:2:30:10 \
          LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50

        echo "Trimmomatic SE complete for ${sample_id}"
    """
}