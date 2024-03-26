#!/usr/bin/env nextflow

bam_files = ""
bed_file = ""
reference_build = ""
outdir = ""

def parse_config_parameters() {
// Parse Nextflow Configurations and Paramters 
    bam_files = params.BAM_filelist
    bed_file = params.BED_file
    reference_build = params.reference_build 
    outdir = params.outdir
} 

/***************************************************************************************************************************************
* This Process is responsible for converting bam files to bw files
***************************************************************************************************************************************/
process bam_to_bw {
    input:
    path(bam_file)

    output:
    path("${bam_file.simpleName}.bw")

    script:
    """
    bash bamToBW.sh ${bam_file} ${outdir}/${bam_file.simpleName} ${bed_file} ${reference_build}
    ln -s ${outdir}/${bam_file.simpleName}.bw ${bam_file.simpleName}.bw
    """
}

/***************************************************************************************************************************************
* This Process is responsible for generating coverage summary from bw files
***************************************************************************************************************************************/
process bw_to_coverage_sum {
    input:
    path(bw)
    val chr

    script:
    """
    ls ${outdir}/*.bw > ${outdir}/bwFiles.txt
    bwToCoverageSummary.py -bw ${outdir}/bwFiles.txt -bed ${bed_file} -out ${outdir}/Coverage-summary -chr ${chr}
    """
}

workflow {
    parse_config_parameters()   
    bam_ch = Channel
            .fromPath(bam_files)
            .splitText()
            .map{it.replaceFirst(/\n/, "")}
            .map{ file(it) }   //map the file path string into file object, then can extract the file information.

    chr_ch = Channel
        .of(1..22, 'X', 'Y')

    bw_ch = bam_to_bw(bam_ch)
    bw_to_coverage_sum(bw_ch.collect(), chr_ch)
}
