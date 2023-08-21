# **Pipeline for Genes Under Positive Selection**

This repository contains a pipeline designed to explore genes under positive selection using the PAML (Phylogenetic Analysis by Maximum Likelihood) software in the context of desert-adapted rodents versus non-desert-adapted rodents. The pipeline utilizes a set of five species:

- Dipodomys spectabilis
- Mus musculus
- Peromyscus eremicus
- Peromyscus maniculatus
- Peromyscus crinitus
- Neotoma lepida
- Onychomys torridus
- 

## __Purpose__
The main purpose of this project is to identify genes that have undergone positive selection in desert-adapted rodent species as compared to their non-desert-adapted counterparts. Positive selection often indicates that specific genes have experienced strong evolutionary pressures, potentially linked to adaptation to arid environments.

## __Pipeline Overview__
### __Data Retrieval:__ 
Genomic coding sequences and GTF files for the selected species were downloaded from the National Center for Biotechnology Information (NCBI).

### __Sequence Alignment:__ 
TranslatorX and MAFFT are used to perform sequence alignment on the downloaded coding sequences. This step is crucial for preparing the sequences for subsequent analysis.

###__Alignment Conversion:__ 
The aligned sequences are then converted into codon alignments using pal2nal. This conversion is essential for conducting phylogenetic analysis.

###__Phylogenetic Analysis:__ 
The PAML software is employed to carry out maximum likelihood-based phylogenetic analysis. The goal is to identify genes that show evidence of positive selection, indicating potential adaptation to desert environments.

##__Required Programs__
Make sure you have the following programs installed before running the pipeline:

TranslatorX: Used for aligning nucleotide sequences.
MAFFT: Employed for sequence alignment.
pal2nal: Utilized to convert amino acid alignments to codon alignments.
PAML (Phylogenetic Analysis by Maximum Likelihood): Used for detecting positive selection in genes.
