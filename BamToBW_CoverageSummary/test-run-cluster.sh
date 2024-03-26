module load nextflow/23.04.1
module load java/openjdk-11
nextflow run main.nf -profile cluster -with-report -with-timeline -with-dag
