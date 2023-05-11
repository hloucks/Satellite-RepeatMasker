version 1.0

workflow RepeatMasker{
    input {
         File fastq
        
         Int threadCount=20
         Int preemptible = 1
     }

    call maskReads {
        input:
            fastq=fastq,

            preemptible=preemptible,
            threadCount=threadCount
    }

    output {
        File outFile = maskReads.outFile
    }

    parameter_meta {
        # fastq: "RepeatMasker"
    }
    meta {
        author: "Hailey Loucks"
        email: "hloucks@ucsc.edu"
    }
}

task maskReads {
    input {
        File fastq

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

        RepeatMasker > out.txt


    >>>

    output {
         File outFile = "out.txt"
    }

    runtime {
        memory: memSizeGB + " GB"
        preemptible : preemptible
        docker: 'dfam/tetools:latest'
    }
}