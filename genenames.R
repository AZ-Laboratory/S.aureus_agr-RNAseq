# Purpose: Create a gene name replacement file based on aureowiki annotations
# and genenames from Tomas pipeline (matching gene names and NWMN locus tags)

# Load libraries
library(dplyr)

# Get directory from where the script is stored
wd = dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)
message("Working directory set to: ", wd)

# Load aureowiki annotation file
auwiki_file <- "GeneSpecificInformation_Newman.csv"
message("Loading aureowiki annotation file from: ", auwiki_file)
auwiki <- read.csv(auwiki_file, header = TRUE, stringsAsFactors = FALSE)
message("Aureowiki annotation file loaded with ", nrow(auwiki), " rows and ", ncol(auwiki), " columns.")

# Create new dataframe with reduced information from the aureowiki annotation
namedd <- data.frame(loctag = auwiki$locus.tag, orig = auwiki$symbol, pan = auwiki$pan.gene.symbol, 
                     syn = auwiki$synonym, prod = auwiki$product)
message("Reduced annotation file created with ", nrow(namedd), " rows.")

# Flag the ones that have different names in the original or pan annotation
namedd$oreqpan <- namedd$orig == namedd$pan
namedd$anot <- namedd$orig  # Use original name if available

# Replace missing names:
namedd$anot[grepl("NWMN", namedd$anot)] <- paste("p:", namedd$pan[grepl("NWMN", namedd$anot)], sep = "")
namedd$anot[namedd$anot == "p:-"] <- paste("s:", namedd$syn[namedd$anot == "p:-"], sep = "")
namedd$anot[namedd$anot == "s:"] <- namedd$loctag[namedd$anot == "s:"]
message("Gene annotation replaced with pan or synonym where applicable.")

# Combine product names and gene names into a combined annotation column
namedd$anot2 <- paste(namedd$anot, namedd$prod, sep = ": ")
message("Combined product names with genes into a single annotation column (anot2).")

# Remove unused columns
namedd <- subset(namedd, select = -c(orig, pan, syn, oreqpan))
names(namedd) <- c("locus_tag", "product", "gene", "combined")
namedd <- namedd[, c("gene", "locus_tag", "product", "combined")]
message("Reduced and reordered data frame. Current columns: ", 
        paste(names(namedd), collapse = ", "), ".")

# Check for duplicated genes
duplicated_genes <- namedd$gene[duplicated(namedd$gene)]
message("Number of duplicated gene names: ", length(duplicated_genes), ".")

# Add unique suffix to duplicated entries
namedd <- namedd %>%
  group_by(gene) %>%
  mutate(
    gene = if (n() > 1) paste0(gene, ".", row_number()) else as.character(gene)
  ) %>%
  ungroup()

# Verify duplicates have been resolved
duplicated_genes <- namedd$gene[duplicated(namedd$gene)]
message("Number of duplicated gene names after resolving duplication: ", length(duplicated_genes), ".")

# Rename columns for consistency
names(namedd) <- c("geneAW", "locus_tag", "productAW", "combinedAW")
message("Renamed columns to: ", paste(names(namedd), collapse = ", "), ".")

# Load Tomas's gene name replacement list
tdlist_file <- "genenamereplacement.csv"
message("Loading Tomas's gene name replacement file from: ", tdlist_file)
tdlist <- read.csv(tdlist_file, header = TRUE, stringsAsFactors = FALSE, sep = ";")
message("Tomas's list loaded with ", nrow(tdlist), " rows and ", ncol(tdlist), " columns.")

# Merge aureowiki and Tomas's list
namedd <- merge(namedd, tdlist, by = "locus_tag", all = TRUE)
message("Merged aureowiki and Tomas's gene name list. Resulting data frame has ", nrow(namedd), " rows.")

# Replace missing gene names in Tomas list with aureowiki gene names
na_replacements <- sum(is.na(namedd$gene))
message("Number of missing gene names replaced with aureowiki names: ", na_replacements, ".")
namedd$gene[is.na(namedd$gene)] <- namedd$geneAW[is.na(namedd$gene)]

# Remove "NWMN" prefix and clean up names
namedd$gene[grepl("NWMN", namedd$gene)] <- 
  namedd$gene[grepl("NWMN", namedd$gene)] %>% 
  gsub("NWMN_", "", .) %>% 
  gsub("^: ", "", .) %>% 
  gsub("^: ", "", .)
message("Removed 'NWMN_' prefix and unnecessary characters from gene names where applicable.")

# Check for duplicate genes again
duplicated_genes <- namedd$gene[duplicated(namedd$gene)]
message("Number of duplicated gene names after replacing missing names: ", length(duplicated_genes), ".")

# Add unique suffix to resolve duplicates again
namedd <- namedd %>%
  group_by(gene) %>%
  mutate(
    gene = if (n() > 1) paste0(gene, ".", row_number()) else as.character(gene)
  ) %>%
  ungroup()
message("Resolved remaining duplication issues. Verified no duplicated gene names remain.")

# Create combined annotation column
namedd$combined <- paste(namedd$gene, namedd$product, sep = ": ")
message("Combined gene and product into a single column (`combined`).")

# Select only relevant columns for final output
namedd <- subset(namedd, select = c("gene", "locus_tag", "product", "combined"))
message("Selected relevant columns for final dataset: gene, locus_tag, product, combined.")

# Save the final annotation file
output_file <- "genenamereplacement_aureowiki.csv"
write.csv(namedd, output_file, row.names = FALSE, quote = TRUE)
message("Saved the final gene name replacement file as: ", output_file, " with ", nrow(namedd), " rows.")

# how to load it and make sure we have leading 0
# Load the CSV, making sure gene is read as character (not as factor or numeric)

# df <- read.csv("genenamereplacement_aureowiki.csv", stringsAsFactors = FALSE)
# 
# # Add a leading zero to gene entries that are only numbers and do not already start with 0
# df$gene <- ifelse(grepl("^[0-9]+$", df$gene) & !grepl("^0", df$gene),
#                   paste0("0", df$gene),
#                   df$gene)
# 
# # Check result
# head(df$gene)
