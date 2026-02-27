process alignReadsBwaMem2 {

    if (params.platform == 'local') {
        label 'process_low'
    } else if (params.platform == 'cloud') {
        label 'process_high'
    }

    container 'quay.io/biocontainers/bwa-mem2:2.3--he70b90d_0'
    tag "$sample_id"

    input:
    tuple val(sample_id), path(reads)
    path(requiredIndexFiles)

    output:
    tuple val(sample_id), path("${sample_id}.sam")

    script:
    """
    # Derive the index prefix from the .amb file provided
    INDEX=\$(ls *.amb | head -n 1 | sed 's/\\.amb\$//')

    echo "Using index prefix: \$INDEX"
    echo "Running bwa-mem2"

    if [ ${reads.size()} -eq 2 ]; then
        bwa-mem2 mem -t ${task.cpus ?: 1} \$INDEX ${reads[0]} ${reads[1]} > ${sample_id}.sam
    else
        bwa-mem2 mem -t ${task.cpus ?: 1} \$INDEX ${reads[0]} > ${sample_id}.sam
    fi
    """
}
