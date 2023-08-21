#! /usr/bin/env python

import sys

if len(sys.argv) != 2:
    print("Usage: python script_name.py input_filename")
    sys.exit(1)

input_filename = sys.argv[1]
output_filename = input_filename.replace(".fna", "_nogaps.fna")

# Code to remove the beginning and end gaps from aligned sequences

# Open the input and output files
with open(input_filename, "r") as in_file, open(output_filename, "w") as out_file:
    # Initialize variables to hold the first sequence and the number of beginning and end gaps
    first_seq = ""
    beg_gaps = 0
    end_gaps = 0

    # Loop through the input file line by line
    for line in in_file:
        if line.startswith(">"):
            out_file.write(line)
        # Check if the line is a sequence line
        else:
            # If it's the first sequence, save it and count the beginning and end gaps
            if not first_seq:
                first_seq = line.strip()
                beg_gaps = len(first_seq) - len(first_seq.lstrip("-"))
                end_gaps = len(first_seq) - len(first_seq.rstrip("-"))
                print("beginning gaps: ", beg_gaps)
                print("ending gaps: ", end_gaps)

                # Write the header and first sequence to the output file
                out_file.write(first_seq[beg_gaps:len(first_seq)-end_gaps] + "\n")

            # If it's not the first sequence, remove the same number of beginning and end gaps and
            # write to the output file
            else:
                seq = line.strip()
                out_file.write(seq[beg_gaps:len(seq)-end_gaps] + "\n")
