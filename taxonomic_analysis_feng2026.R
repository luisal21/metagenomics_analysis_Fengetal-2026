# Taxonomic analysis of the metagenomic data of the paper Feng et al. 2026.
# This exercise is part of the research visit of Nadia Vargas, a student from
# the UNAM School of Veterinary Medicine in the Center for mathematical science.

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

# Visualize again the tax table
View(merged_metagenomes@tax_table@.Data)

# Explore how many phyla we have with the command unique()
unique(merged_metagenomes@tax_table@.Data[,"Phylum"])

# Visualize the OTU table to see abundance
View(merged_metagenomes@otu_table@.Data)

# Statistics of our metagenomes
merged_metagenomes
sample_sums(merged_metagenomes)
summary(merged_metagenomes@otu_table@.Data)

# Plot alpha diversity
plot_richness(physeq = merged_metagenomes, 
              measures = c("Observed","Chao1","Shannon")) 

# Extracting only observed richness
plot_richness(physeq = merged_metagenomes, 
              measures = "Observed") 

# Look if we have any non-identified reads.
summary(merged_metagenomes@tax_table@.Data== "")

# Remove that  blanks we get at the genus level to proceed with the analysis:
merged_metagenomes <- subset_taxa(merged_metagenomes, Genus != "") #Only genus that are no blank
summary(merged_metagenomes@tax_table@.Data== "")

# Transform the absolute abundance to percentages to obtain the relative
# abundance.
percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )

# Visualize the first 6 lines
head(percentages@otu_table@.Data)

### BETA DIVERSITY
# First we review all the possible distance metrics that Phyloseq can use:
distanceMethodList

# We use the command ordinate to generate a distance matrix with the NMDS 
# method and bray distance.
meta_ord <- ordinate(physeq = percentages, method = "NMDS", 
                     distance = "bray")

# We use the command plot_ordination() to see the results from our beta
# diversity analysis:
plot_ordination(physeq = percentages, ordination = meta_ord)

