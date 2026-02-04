# S.aureus_agr-RNAseq
This repository contains the R code and data used for the statistical analysis in the publication "Staphylococcus aureus agr-type vs genetic background: molecular signatures determining differential metabolism and virulence potential" (Pivard et al., 2026).
Analyses include differential expression testing, PCA, clustering, enrichment analysis, and visualization of RNA‑seq results.

If you use any part of this code or data, please cite:
Pivard M., et al. (2026). Staphylococcus aureus agr-type vs genetic background: molecular signatures determining differential metabolism and virulence potential.

## Repository Structure:
/data            → count, metadata, and gene name replacement files
  /Counts        → Folder containing count matrices (kept separate), within the data folder
/script          → R scripts used for statistical analysis  
/environment     → R session info

Raw sequencing reads are available on the European Nucleotide Archive:
Project ID: PRJEB107700

And RNAseq analysis performed with Tomas Demeter's pipeline: 

## License
- Code is licensed under MIT.
- Data (in the /data directory) is licensed under CC BY 4.0.

################################################################################################################

How to Run the Analysis:

1. Download the repository.
2. Place all files from data and script into one directory (your working directory, WD).
3. Keep raw count files inside a subfolder named Counts within the WD.
4. Create an output folder inside the WD – all results will be saved there.
5. Open the R script and set the working directory accordingly.
6. Run the script.

################################################################################################################
