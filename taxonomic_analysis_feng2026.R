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

# Import biom archive
merged_metagenomes <- import_biom("feng.biom")

# Verify if we generated the phyloseq object
class(merged_metagenomes)

# Visualize the tax table
View(merged_metagenomes@tax_table@.Data)

# Remove unnecessary characters in .Data (matrix) with the command substring()
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
# Then rename the columns names with the correct taxonomic range
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

# Explore how many phyla we have with the command unique()
unique(merged_metagenomes@tax_table@.Data[,"Phylum"])

# Visualize the OTU table
View(merged_metagenomes@otu_table@.Data)

# 
