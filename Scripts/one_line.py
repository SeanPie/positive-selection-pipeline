#! /usr/bin/env python

import sys

file = sys.argv[1] # Aligned file
name = file.split('.')[0]

# Convert fasta files to have sequences on a single line

with open(file, 'r') as in_f, open('{0}_oneline.fna'.format(name), 'w') as out_f:
    header = ''
    sequence = ''
    for line in in_f:
        if line.startswith('>'):
            # new entry found
            if header != '':
                # write previous entry
                out_f.write(header + '\n' + sequence + '\n\n')
            # reset header and sequence for new entry
            header = line.strip()
            sequence = ''
        else:
            # concatenate sequence lines for current entry
            sequence += line.strip()
    # write last entry
    out_f.write(header + '\n' + sequence + '\n')