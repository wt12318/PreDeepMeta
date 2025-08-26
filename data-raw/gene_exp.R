## code to prepare `exp` dataset goes here
library(dplyr)
gene_exp <- data.table::fread("/home/data/sdb/wt/model_data/OmicsExpressionProteinCodingGenesTPMLogp1.csv",
                              data.table = F)
rownames(gene_exp) <- gene_exp$V1
gene_exp <- gene_exp %>% select(-V1)
colnames(gene_exp) <- gsub(" [(].+","",colnames(gene_exp))

cell_info <- load("~/PreDeepMeta/data/cell_info.rda")
gene_exp <- gene_exp[cell_info$ModelID,]
gene_exp <- na.omit(gene_exp) %>% t() %>% as.data.frame()

usethis::use_data(gene_exp, overwrite = TRUE)
