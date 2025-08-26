## code to prepare `SkinCancerNet` dataset goes here
library(Met2Graph)
infiles <- "~/meta_target/data/GSM_xml/iSkinCancer1386.xml"
outDir <- "~/meta_target/data/meta_net/"
Met2EnzGraph(infiles, rmMets=TRUE, outDir=outDir, outFormat="ncol")

SkinCancerNet <- read.table("~/meta_target/data/meta_net/EnzGraphs/iSkinCancer1386_enzymes_based_graph.tsv")

usethis::use_data(SkinCancerNet, overwrite = TRUE)
