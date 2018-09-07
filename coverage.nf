#!/usr/bin/env nextflow

params.cpus = 3
params.bowtie_index="/home/sdv/m2bi/hkabbech/SWDC/nextflow-intro/data/db/FN433596"

params.read = "/home/sdv/m2bi/hkabbech/SWDC/nextflow-intro/data"
params.res = "/home/sdv/m2bi/hkabbech/SWDC/nextflow-intro/res"
outDir = file(params.res)

readChannel = Channel.fromFilePairs("${params.read}/*{1,2}.fastq.gz").ifEmpty { exit 1 , "no file found"}

process mapping {
	conda "bioconda::bowtie2"

	input:
	set pair_id, file(reads) from readChannel

	output:
	set pair_id, file("*.sam") into mappingChannel

	script:
	"""
	bowtie2 -q -1 ${reads[0]} -2 ${reads[1]} -x ${params.bowtie_index} -S ${pair_id}.sam -p ${params.cpus}
	"""
}
