#!/usr/bin/awk
# Takes output of "samtools depth" and reformats into grouped bedgraph format:
# samtools depth -r ${loc} -Q 1 --reference $fasta $bam | mawk -f scripts/depth2bedgraph.awk > /tmp/my.bedgraph
# Example input:
#chr1     26      2
#chr1     27      2
#chr1     28      2
#chr1     29      5
#chr1     30      5
#chr1     31      5
#chr1     32      5
#chr1     33      5
#chr1     34      5
#chr1     35      5
# Example output:
#chr1     25      28     2
#chr1     28      35     5

BEGIN{FS="\t";OFS="\t"}{
  if(NR>1 && ($1!=prev_seq || $3!=prev_cov || $2>prev_pos+1)){
    print prev_seq,start,end,prev_cov
    start = $2-1
  } else if(NR==1){
    start = $2-1
  }
  end = $2
  prev_seq = $1
  prev_pos = $2
  prev_cov = $3
}
END{
  print prev_seq,start,end,prev_cov
}