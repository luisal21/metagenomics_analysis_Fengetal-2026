# Taxonomic analysis of the metagenomic data of the paper Feng et al. 2026.
# This exercise is part of the research visit of Nadia , a student from the
# UNAM School of Veterinary Medicine in the Center for mathematical science.

# Loading libraries
library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")

# Setting working directory
getwd()
setwd("/home/luis/Descargas/Estancia_nadia_metagenomica_CCM/metagenomics_analysis_feng-etal-2026")

# Importing biom archive
merged_metagenomes <- import_biom("feng.biom")

#
class(merged_metagenomes)

#
View(merged_metagenomes@tax_table@.Data)

#
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

#
unique(merged_metagenomes@tax_table@.Data[,"Phylum"])

#
View(merged_metagenomes@otu_table@.Data)

# 
