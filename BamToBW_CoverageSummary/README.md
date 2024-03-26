# A nextflow based pipeline for generating coverage statistics for CoCoRV analysis #

### What is this repository for? ###
Converts bam file to bigwig file by first calculating per base depth of coverage using samtools depth and then storing the coverage information in a bigwig file format. Then calculates coverage summary statistics for the generated bigwig files and outputs a gzipped tab delimited file containing coverage statistics for each position. Creates seperate coverage statistics files for each chromosome presented in the input bams.

### Installation ###
#### Micromamba ####
Please check the README.md in [CoCoRV_nextflow_conda](https://github.com/stjudecab/CoCoRV_nextflow_conda) repository for Micromamba installation.

#### Create Micromamba environment ####
Download the git repository "stjudecab/CoCoRV_nextflow_conda". Go to "BamToBW_CoverageSummary/conda-envs" folder and craete conda environment "coverage-env":
```bash
git clone https://github.com/stjudecab/CoCoRV_nextflow_conda.git
cd CoCoRV_nextflow_conda/BamToBW_CoverageSummary/conda-envs
micromamba create -f coverage-env.yaml
```
It will create a conda environment with name "coverage-env" with all necessary python packages and Samtools.

#### Nextflow ####
Load nextflow using the following commands:
```bash
module load nextflow/23.04.1
module load java/openjdk-11
```
If you want to install nextflow, please check https://www.nextflow.io/.

### Examples ###
This repository contains the following files.

* *main.nf*: main nextflow script for calculating coverage statistics for CoCoRV.
* *nextflow.config*: contains default configuration for running coverage pipeline, please update the "process.conda" parameter to specify your home directory's micromamba environment folder containing "coverage-env" environment. You also need to update the input parameters which are "BAM_filelist", "BED_file", "reference_build", and output folder parameter which is "outdir" for your run.
* *sample-input folder*: contains 3 sample bam files, "bamFiles.txt" containing input bam file paths, and BED file "sample-bed.bed".
    * HG00096-subset.bam, HG00097-subset.bam, HG00099-subset.bam : Input bam files from where we want to calculate coverage summary
    * bamFiles.txt : the text file containing input bam file paths, each line containing full path of one bam file 
    * sample-bed.bed : Input BED file that specifies the region to calculate the covearge summary
* *conda-envs folder*: contains YAML file for creating conda environment.
* *bin folder*: contains scripts for coverage calculation.

#### Run using sample inputs ####
A sample bash script named "test-run-conda.sh" is given which can be used to generate coverage summary for the given input files in "sample-input" folder. This script will run bamToBW.sh script for the three input bam files and will generate three bigwig files with name HG00096.bw, HG00097.bw, and HG00099.bw and will save them in the "sample-output" folder. It will then run the bwToCoverageSummary.py script using the three bigwig files. As the sample input bed file contains poistions for chromosomes 1 and 2, it will generate two coverage summary files with name "Coverage-summary_1.tsv.gz" and "Coverage-summary_2.tsv.gz" and will save them in the "sample-output" folder.

To run the "test-run-conda.sh" script, please update the "process.conda" parameter to specify your home directory's micromamba environment folder containing "coverage-env" environment (usually YOUR_HOME_DIRECTORY/micromamba/envs/coverage-env). You also need to update the path of input parameters in *nextflow.config* file, which are "BAM_filelist", "BED_file", and output folder path "outdir" for your run.
