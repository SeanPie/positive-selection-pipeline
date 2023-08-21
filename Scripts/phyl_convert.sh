#! /bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 input_fasta_file"
    exit 1
fi

input_file=$1
output_file="${input_file%.fna}_mafft.phy"

# Count the number of sequences in the FASTA file
num=$(grep '>' "$input_file" | wc -l)

# Get the length of the sequences from the second sequence line
len=$(sed -n '2,2p' "$input_file" | sed 's/\r//' | sed 's/\n//' | wc --m)

# Convert the FASTA file to PHYLIP format using the script "fasta_to_phyl.pl"
./fasta_to_phyl.pl "$input_file" "$num" "$len"

# Rename the generated PHYLIP file to the specified output filename
mv "${input_file%.fna}.phy" "$output_file"
