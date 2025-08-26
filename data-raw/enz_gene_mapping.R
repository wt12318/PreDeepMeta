## code to prepare `enz_gene_mapping` dataset goes here
library(dplyr)

enz_ensm <- org.Hs.eg.db::org.Hs.egENSEMBL
enz_sym <- org.Hs.eg.db::org.Hs.egSYMBOL
mapped_genes <- AnnotationDbi::mappedkeys(enz_ensm)
mapping_enz <- enz_ensm[mapped_genes] %>% as.data.frame()
mapped_genes <- AnnotationDbi::mappedkeys(enz_sym)
mapping_sym <- enz_sym[mapped_genes] %>% as.data.frame()
mapping <- inner_join(mapping_enz,mapping_sym)
enz_gene_mapping <- mapping
usethis::use_data(enz_gene_mapping, overwrite = TRUE)
