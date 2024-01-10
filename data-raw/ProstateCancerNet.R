## code to prepare `ProstateCancerNet` dataset goes here
library(Met2Graph)
infiles <- "~/meta_target/data/GSM_xml/iProstateCancer1560.xml"
outDir <- "~/meta_target/data/meta_net/"
Met2EnzGraph(infiles, rmMets=TRUE, outDir=outDir, outFormat="ncol")

ProstateCancerNet <- read.table("~/meta_target/data/meta_net/EnzGraphs/iProstateCancer1560_enzymes_based_graph.tsv")

usethis::use_data(ProstateCancerNet, overwrite = TRUE)
