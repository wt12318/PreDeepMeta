## code to prepare `cpg_gene` dataset goes here
library(dplyr)

###all enzyme in network
enz_gene_mapping <- readRDS("~/meta_target/data/enz_gene_mapping.rds")
res <- vector("list",19)
for (i in seq_along(res)){
  dt <- read.table(paste0("~/meta_target/data/meta_net/EnzGraphs/",
                          paste0(gsub(".xml","",net_cell_mapping$origin_net[i]),
                                 "_enzymes_based_graph.tsv")))
  dt_gene <- data.frame(gene=strsplit(paste0(unique(c(dt$from,dt$to)),
                                             collapse = " and "),
                                      split = " and ")[[1]])
  res[[i]] <- dt_gene
}
res <- bind_rows(res)
all_gene <- enz_gene_mapping$symbol[which(enz_gene_mapping$ensembl_id %in% res$gene)] %>%
  unique()

cpg <- fgsea::gmtPathways("~/meta_target/data/c2.cgp.v2023.1.Hs.symbols.gmt")
res <- vector("list",length(all_gene))
for (i in seq_along(res)){
  dt <- sapply(cpg,function(x){all_gene[i] %in% x}) %>% as.data.frame()
  colnames(dt) <- all_gene[i]
  dt[,1] <- as.numeric(dt[,1])
  res[[i]] <- dt
}
res <- bind_cols(res)
dep_dt <- readRDS("/home/data/sdb/wt/model_data/dep_dt.rds")
res <- res %>% dplyr::select(any_of(unique(dep_dt$gene)))
res_summ <- apply(res,1,sum) %>% as.data.frame()
res_summ$pathway <- rownames(res_summ)
colnames(res_summ)[1] <- "gene_num"
res_summ <- res_summ %>% filter(gene_num > 0)
res <- res[res_summ$pathway,]
cpg_gene <- res

usethis::use_data(cpg_gene, overwrite = TRUE)



