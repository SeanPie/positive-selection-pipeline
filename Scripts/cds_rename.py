#! /usr/bin/env python3

## Rename headers for from cds fasta sequences downloaded from ncbi
# Needs to be modified for species specific heading identifiers

with open('cds_from_genomic.fna', 'r') as f, open('cds_renamed.fna', 'w') as out_f:
    check = ''
    seq = ''
    for lines in f:
        if lines.startswith('>'):
            line = lines.split(' ')
            id = line[0].split('_')
            gene = line[1].split('=')[1].rstrip('] ')
            check = id[3]
            if check == 'NP':
                protein_id = id[4]
                out_f.write(seq)
                out_f.write('>NP_{0} {1}\n'.format(protein_id, gene))
                seq = ''
        elif check == 'NP':
            seq += lines
