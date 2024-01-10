## code to prepare `PancreaticCancerNet` dataset goes here
library(Met2Graph)
infiles <- "~/meta_target/data/GSM_xml/iPancreaticCancer1613.xml"
outDir <- "~/meta_target/data/meta_net/"
Met2EnzGraph(infiles, rmMets=TRUE, outDir=outDir, outFormat="ncol")

PancreaticCancerNet <- read.table("~/meta_target/data/meta_net/EnzGraphs/iPancreaticCancer1613_enzymes_based_graph.tsv")

usethis::use_data(PancreaticCancerNet, overwrite = TRUE)
