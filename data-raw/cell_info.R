## code to prepare `cell_info` dataset goes here
library(dplyr)
cell_info <- read.csv("/home/data/sdc/wt/update/data/Model.csv")
cell_info <- cell_info %>%
  filter((OncotreeLineage != "Normal") & (OncotreePrimaryDisease != "Non-Cancerous"))
net_cell_mapping <- data.frame(origin_net=NA,cell=unique(cell_info$OncotreeLineage))
net_cell_mapping$origin_net <- c("iOvarianCancer1620.xml","bone_marrow.xml",
                                 "iColorectalCancer1750.xml","iSkinCancer1386.xml",
                                 "iUrothelialCancer1532.xml","iLungCancer1490.xml",
                                 "kidney.xml","iBreastCancer1746.xml",NA,
                                 "iPancreaticCancer1613.xml","brain.xml",NA,NA,
                                 "iStomachCancer1511.xml","iThyroidCancer1710.xml",NA,NA,
                                 "iProstateCancer1560.xml",NA,"iHeadNeckCancer1628.xml",
                                 "iEndometrialCancer1713.xml",NA,"iLiverCancer1788.xml",
                                 "iCervicalCancer1611.xml",NA,NA,"adrenal_gland.xml",
                                 NA,"iTestisCancer1483.xml",NA)
net_cell_mapping <- na.omit(net_cell_mapping)
cell_info <- cell_info %>%
  select(ModelID,OncotreeLineage) %>%
  rename(cell = OncotreeLineage) %>%
  left_join(.,net_cell_mapping)
cell_info <- na.omit(cell_info)
cell_info <- cell_info %>%
  mutate(net = paste0(gsub(".xml","",origin_net),"_enzymes_based_graph.tsv"))

####sample 5 tissue and 100 cell lines as example dataset
tissues <- sample(unique(cell_info$net),5)
cell_info <- cell_info %>%
  filter(net %in% tissues) %>%
  sample_n(100)
usethis::use_data(cell_info, overwrite = TRUE)



