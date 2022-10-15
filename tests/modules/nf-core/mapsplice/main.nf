#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { MAPSPLICE } from '../../../../modules/nf-core/mapsplice/main.nf'

workflow test_mapsplice {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    MAPSPLICE ( input )
}
