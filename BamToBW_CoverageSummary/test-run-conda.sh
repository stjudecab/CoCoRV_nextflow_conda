module load nextflow/23.04.1
module load java/openjdk-11
nextflow run main.nf -profile conda -with-report -with-timeline -with-dag
