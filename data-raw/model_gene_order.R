## code to prepare `model_gene_order` dataset goes here
library(dplyr)

diff_exp <- data.table::fread("/home/data/sdb/wt/model_data/cell_gene_exp_vs_normal_filter.csv",
                              data.table = F)
model_gene_order <- colnames(diff_exp)[2:ncol(diff_exp)]
usethis::use_data(model_gene_order, overwrite = TRUE)
