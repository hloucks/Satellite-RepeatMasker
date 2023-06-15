version 1.0
# WDL ReapeatMasker workflow adapted from 
# https://github.com/ChaissonLab/SegDupAnnotation/blob/master/RepeatMaskGenome.snakefile#L1

workflow RepeatMasker{
    input {
         File fasta
         File t2tLib
        
         Int threadCount=20
         Int preemptible = 1
     }


    call maskContig {
        input:
            fasta=fasta,

            preemptible=preemptible,
            threadCount=threadCount
    }


    output {
        File outFile1 = maskContig.outFile1
        #File outFile2 = SpecialMaskContig.outFile2
    }

    parameter_meta {
         fasta: "RepeatMasker run on Dfam datatase and CHM13 lib"
    }
    meta {
        author: "Hailey Loucks"
        email: "hloucks@ucsc.edu"
    }
}

task maskContig {
    input {
        File fasta

        Int memSizeGB = 48
        Int preemptible
        Int threadCount
    }
    command <<<

        #handle potential errors and quit early
        set -o pipefail
        set -e
        set -u
        set -o xtrace

        RepeatMasker -s -e ncbi -gff ~{fasta}
        echo "maskContig" > maskContig.txt


    >>>

    output {
         File outFile1 = "maskContig.txt"
    }

    runtime {
        memory: memSizeGB + " GB"
        preemptible : preemptible
        docker: 'dfam/tetools:latest'
    }
}