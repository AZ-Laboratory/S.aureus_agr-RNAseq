#outputdirectrory
outputdir = paste0(wd,"/output")


# Function to check and install CRAN packages
install_if_missing <- function(packages) {
  to_install <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(to_install)) {
    install.packages(to_install)
  }
}

# Function to check and install Bioconductor packages
install_bioc_if_missing <- function(packages) {
  to_install <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(to_install)) {
    BiocManager::install(to_install)
  }
}

# CRAN packages
cran_packages <- c("dplyr", "readr", "tidyverse")
install_if_missing(cran_packages)

# Install BiocManager if not installed
if (!"BiocManager" %in% installed.packages()[, "Package"]) {
  install.packages("BiocManager")
}

# Bioconductor packages
bioc_packages <- c("DESeq2", "apeglm", "pheatmap", "ggplot2", "EnhancedVolcano")
install_bioc_if_missing(bioc_packages)
library(dplyr)
library(readr)
library(DESeq2)
library(apeglm)  # For log fold change shrinkage
library(pheatmap) # For heatmaps
library(ggplot2)  # For PCA and other plots
library(EnhancedVolcano) # For volcano plots
library(tidyverse)




#custom ggplot theme
szmain = 16
sztxt = 14

theme_set(theme_bw(base_size = szmain))
theme_poster <- function(base_size = szmain, base_family = "") {
  # Starts with theme_grey and then modify some parts
  theme_bw(base_size = base_size, base_family = "sans") %+replace%
    theme(
      plot.title = element_text(size = szmain),
      strip.background = element_blank(),
      strip.text.x = element_text(size = sztxt),
      strip.text.y = element_text(size = sztxt, hjust=0),
      axis.text.x = element_text(size=sztxt,vjust=-1, colour = "black"),
      axis.text.y = element_text(size=sztxt,hjust=1, colour = "black"),
      axis.ticks =  element_line(colour = "black"), 
      axis.title.x= element_text(size=szmain, vjust=-1.1, colour = "black"),
      axis.title.y= element_text(size=szmain,angle=90, vjust=1.5, colour = "black"),
      legend.position = "bottom", 
      legend.text=element_text(size=szmain),
      panel.background = element_blank(), 
      panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(), 
      plot.background = element_blank(), 
      panel.border = element_blank(),
      plot.margin = unit(c(0.5,  0.5, 0.5, 0.5), "lines"),
      axis.line = element_line(colour = "black")
    )
}

c_strains = c("#ffffff",
              "#6666FF",
              "#CC99CC",
              "#990066",
              "#66CCFF")

c_time = c("#a0c3d1","#5da0C7", "#3b3d69")

c_gradient = c("white","#0400ff")