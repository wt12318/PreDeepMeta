## code to prepare `CervicalCancerNet` dataset goes here
library(Met2Graph)
infiles <- "~/meta_target/data/GSM_xml/iCervicalCancer1611.xml"
outDir <- "~/meta_target/data/meta_net/"
Met2EnzGraph(infiles, rmMets=TRUE, outDir=outDir, outFormat="ncol")

CervicalCancerNet <- read.table("~/meta_target/data/meta_net/EnzGraphs/iCervicalCancer1611_enzymes_based_graph.tsv")

usethis::use_data(CervicalCancerNet, overwrite = TRUE)
