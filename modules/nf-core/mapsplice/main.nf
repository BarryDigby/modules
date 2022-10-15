process MAPSPLICE {
    tag "$meta.id"
    label 'process_high'

    conda (params.enable_conda ? "bioconda::mapsplice=2.2.1" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mapsplice:2.2.1--py36h07887db_0':
        'quay.io/biocontainers/mapsplice:2.2.1--py36h07887db_0' }"

    input:
    tuple val(meta), path(reads)
    path(bowtie_index)
    path(gtf)
    val(reference_chromosomes)

    output:
    // TODO nf-core: Named file extensions MUST be emitted for ALL output channels
    tuple val(meta), path("*.bam"), emit: bam
    // TODO nf-core: List additional required output channels/values here
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def gzip_r1 = "${reads[0]}".endsWith(".gz") ? "gzip -d --force ${reads[0]}" : ""
    def gzip_r2 = meta.single_end ?: "${reads[1]}".endsWith(".gz") ? "gzip -d --force ${reads[1]}" : ""
    def read1 = "${reads[0]}".endsWith('.gz') ? "${reads[0]}" - ~/.gz/ : reads[0]
    def read2 = meta.single_end ?: "${reads[1]}".endsWith('.gz') ? "${reads[0]}" - ~/.gz/ : reads[1]
    def input_reads = meta.single_end ?
    """
    printf " $prefix $gzip_r1 $gzip_r2 $read1 $read2 $input_reads " 
    """
}
