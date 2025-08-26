## code to prepare `Gtex_exp5` dataset goes here
library(dplyr)
# cell_info2 <- read.csv("/home/data/sdc/wt/update/data/Model.csv")
# cell_info2 <- cell_info2 %>%
#   filter((OncotreeLineage != "Normal") & (OncotreePrimaryDisease != "Non-Cancerous"))
# net_cell_mapping <- data.frame(origin_net=NA,cell=unique(cell_info2$OncotreeLineage))
# net_cell_mapping$origin_net <- c("iOvarianCancer1620.xml","bone_marrow.xml",
#                                  "iColorectalCancer1750.xml","iSkinCancer1386.xml",
#                                  "iUrothelialCancer1532.xml","iLungCancer1490.xml",
#                                  "kidney.xml","iBreastCancer1746.xml",NA,
#                                  "iPancreaticCancer1613.xml","brain.xml",NA,NA,
#                                  "iStomachCancer1511.xml","iThyroidCancer1710.xml",NA,NA,
#                                  "iProstateCancer1560.xml",NA,"iHeadNeckCancer1628.xml",
#                                  "iEndometrialCancer1713.xml",NA,"iLiverCancer1788.xml",
#                                  "iCervicalCancer1611.xml",NA,NA,"adrenal_gland.xml",
#                                  NA,"iTestisCancer1483.xml",NA)
# net_cell_mapping <- na.omit(net_cell_mapping)
# net_cell_mapping$normal <- c("Ovary","Whole Blood","Colon - Sigmoid",
#                              "Skin - Sun Exposed (Lower leg)","Bladder",
#                              "Lung","Kidney - Cortex","Breast - Mammary Tissue",
#                              "Pancreas","Brain - Amygdala","Stomach","Thyroid","Prostate",
#                              "Whole Blood","Uterus","Liver","Cervix - Endocervix",
#                              "Adrenal Gland","Testis")
# cell_info2 <- cell_info2 %>%
#   select(ModelID,OncotreeLineage) %>%
#   rename(cell = OncotreeLineage) %>%
#   left_join(.,net_cell_mapping)
# cell_info2 <- na.omit(cell_info2)
#
# data("cell_info")
# cell_info <- cell_info2 %>% filter(ModelID %in% cell_info$ModelID)
# cell_info <- cell_info %>%
#   mutate(net = paste0(gsub(".xml","",origin_net),"_enzymes_based_graph.tsv"))
# usethis::use_data(cell_info, overwrite = TRUE)

data("cell_info")
gtex <- data.table::fread("~/meta_target/data/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_median_tpm.gct",
                          data.table = F,skip = 2) %>%
  filter(!grepl("PAR",Name))
gtex <- gtex %>%
  select(Description,unique(cell_info$normal))
Gtex_exp5 <- gtex
usethis::use_data(Gtex_exp5, overwrite = TRUE)
