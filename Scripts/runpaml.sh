#!/bin/bash

# Function to create alignments
run_translatorx() {
  echo "Running TranslatorX and MAFFT..."
  mkdir translatorx
  cd translatorx
  
  # Run TranslatorX to align nucleotide sequences and translate to amino acids
  translatorx -i ../${gene_name}_ol.fna -p F

  # Additional alignment to run as a check
  mafft --auto translatorx_res.aaseqs.fasta > translatorx_res.aa_ali.fasta
  mv translatorx_res.aa_ali.fasta aa_ali.fasta
  
  #
  translatorx -i ${gene_name}_ol.fna -p F -a aa_ali.fasta
  cp translatorx_res.nt_ali.fasta ${gene_name}_mafft_aln.fna
  cp translatorx_res.aa_ali.fasta ${gene_name}_mafft_aln.faa
  cd ..
  echo "Alignment completed."
}

# Function to remove gaps
run_gap_removal() {
  echo "Running gap removal..."
  ./~/selection/scripts/remove_gap.py
  echo "Gap removal completed."
}

# Function to generate gene tree for PAML
run_paml_prepare() {
  # run_phyl script in order to
  ./~/selection/run_phyl.sh
  
  # Generate a gene tree using RAxML
  raxmlHPC -f a -m GTRGAMMA -p 12345 -# 100 -x 12345 -# 500 -s ${gene_name}_mafft.phy -o D_spectabilis -n mvd_mafft
  mv RAxML_bestTree.${gene_name}_mafft ${gene_name}.tree

  # Remove branch length from the tree
  sed 's/\:[0-9]*\.[0-9]*//g' ${gene_name}.tree >> ${gene_name}_root.tree
}

# Function to run site models analysis
run_null_model() {
  echo "Running null model analysis..."
  mkdir M0
  cd M0

  # Run codeml with edited template control file for M0 analysis
  codeml codeml_M0.ctl

  # Extract omega values to a new omega_est.txt file
  printf "omega\n" > omega_est.txt
  grep 'omega ' out_M0.txt | sed 's/..*= *//' >> omega_est.txt
  cd ..
}

run_site_models() {
  echo "Running site models analysis..."
  mkdir Site_models
  cd Site_models 

  # Run codeml using custom edited control file for M1a and M2a site tests
  codeml codeml-sites.ctl

  # Extract information from Likelihood Ratio Test (LRT) for downstream analysis
  lnL_vals=$( grep 'lnL' out_sites.txt | sed 's/..*\:\ *//' | sed 's/\ ..*//' )
  np_vals=$( grep 'lnL' out_sites.txt | sed 's/..*np\:\ //' | sed 's/)..*//' )
  header=$( grep 'Model ' out_sites.txt | sed 's/\:..*//' | sed 's/\ /\_/' )
  echo $header > lnL_sites.txt
  echo $lnL_vals >> lnL_sites.txt
  echo $np_vals >> lnL_sites.txt
  sed -i 's/NSsites\_//g' lnL_sites.txt 
  sed -i 's/Model\ 1/Model\_1a/' lnL_sites.txt
  sed -i 's/Model\ 2/Model\_2a/' lnL_sites.txt
  sed -i 's/Model\ /Model\_/g' lnL_sites.txt
  cd ../../..
  echo "Models analysis completed."
}

# Check if a gene name argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <gene_name>"
  exit 1
fi

gene_name="$1"

# Call functions in sequence
run_translatorx
run_gap_removal
run_paml_prepare
run_null_model
run_site_models

echo "Full pipeline completed for gene: $gene_name"