## code to prepare `dep_data` dataset goes here
library(dplyr)

dep_data <- data.table::fread("/home/data/sdb/wt/model_data/CRISPRGeneDependency.csv",
                            data.table = F)
colnames(dep_data)[2:ncol(dep_data)] <- gsub("\\s*\\([^\\)]+\\)","",
                                           colnames(dep_data)[2:ncol(dep_data)])
dep_data <- dep_data %>%
  tidyr::pivot_longer(cols = colnames(dep_data)[2:ncol(dep_data)],names_to = "gene",
                      values_to = "score")
data("cell_info")

###only keep for Skin cancer
cell_info <- cell_info %>%
  filter(net %in% "iSkinCancer1386_enzymes_based_graph.tsv")
dep_data <- dep_data %>%
  filter(ModelID %in% cell_info$ModelID)
dep_data <- dep_data %>%
  mutate(type = case_when(
    score > 0.5 ~ 1,
    score <= 0.5 ~ 0
  ))
usethis::use_data(dep_data, overwrite = TRUE)
