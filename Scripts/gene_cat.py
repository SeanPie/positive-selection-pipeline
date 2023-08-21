#! /usr/bin/env python

import os, sys

# Script to search for cds headers and create a file of matching gene sequences from different species

#File containing headers for a specific gene
gene = sys.argv[1]

search_ids = []
with open(gene, 'r') as f:
    for line in f:
        search_ids.append(line.strip())

output_dir = "./output/"  # Output directory to save results
if not os.path.exists(output_dir):
    os.mkdir(output_dir)

# Loop through all files in the current directory and subdirectories
for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".fasta"):
            filepath = os.path.join(root, file)
            with open(filepath, "r") as f:
                # Search through the file for matching IDs
                header = ""
                sequence = ""
                for line in f:
                    if line.startswith(">"):
                        # Check if the header contains a matching ID
                        if any(search_id in line for search_id in search_ids):
                            header = line.strip()
                    else:
                        # Append sequence lines to the current sequence
                        sequence += line.strip()

                # If a matching sequence was found, write it to the output file
                if header and sequence:
                    output_file = os.path.join(output_dir, file)
                    with open(output_file, "a") as out:
                        out.write(header + "\n" + sequence + "\n")
