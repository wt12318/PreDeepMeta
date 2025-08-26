## code to prepare `UrothelialCancerNet` dataset goes here
library(Met2Graph)
infiles <- "~/meta_target/data/GSM_xml/iUrothelialCancer1532.xml"
outDir <- "~/meta_target/data/meta_net/"
Met2EnzGraph(infiles, rmMets=TRUE, outDir=outDir, outFormat="ncol")

UrothelialCancerNet <- read.table("~/meta_target/data/meta_net/EnzGraphs/iUrothelialCancer1532_enzymes_based_graph.tsv")

usethis::use_data(UrothelialCancerNet, overwrite = TRUE)
