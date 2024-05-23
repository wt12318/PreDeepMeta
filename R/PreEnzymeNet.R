#' Prepare DeepMeta model sample-specific enzyme network input
#'
#' DeepMeta framework has two inputs, the sample-specific enzyme network and the differential expression data.
#' The sample-specific enzyme network (SEN) is constructed from cancer-specific or tissue-specific GSMs (Genome-Scale Metabolic Models),
#' and in this network, enzymes are the nodes connected by edges represented by metabolites.
#' SEN are constructed by removing genes in the cancer-specific enzyme network that are not expressed in the sample,
#' defined as expression levels below 1 TPM. The features of gene nodes in the enzyme network are composed of 3247-dimensional binary (0/1) vector,
#' indicating whether the gene is exist in the collected 3247 CPG (chemical and genetic perturbation) gene set. This function
#' prepare the network input consisting of SEN (.txt file) and gene features (_feat.txt file).
#'
#' @param gene_exp A dataframe, rows are gene and cols are cell line or sample name, unit is log2(TPM + 1)
#' @param network A dataframe, network in edgelist format, at least three columns with name of `from` and `to`, indicating nodes
#' @param gene_mapping A dataframe, mapping of different gene IDs, at least contains two columns with name of `ensembl_id` and `symbol`
#' @param gene_feature A dataframe, gene CPG features, rows are CPG pathways, cols are gene symbol
#' @param cell_name A character string, cell line or sample name, must match name in `gene_exp` columns and `ModelID` column in `dep_data`
#' @param dep_data A dataframe, gene dependency data, at least contains three columns with name of `ModelID`, `gene` and `type`
#' @param save_path A character string, path name of output file saved
#' @importFrom rlang .data
#' @importFrom utils write.table
#' @return Two txt files, `.txt` file is the edge list format of SEN and `_feat.txt` file contains gene CPG features
#' @export
#' @examples
#' library(dplyr)
#' data("gene_exp")
#' data("SkinCancerNet")
#' data("enz_gene_mapping")
#' data("cpg_gene")
#' data("dep_data")
#' PreEnzymeNet(gene_exp, network = SkinCancerNet,
#'              gene_mapping = enz_gene_mapping, gene_feature = cpg_gene,
#'              cell_name = "ACH-001521", dep_data = dep_data, save_path = tempdir())
#' ##or without dependency data
#' PreEnzymeNet(gene_exp, network = SkinCancerNet,
#'              gene_mapping = enz_gene_mapping, gene_feature = cpg_gene,
#'              cell_name = "ACH-001521", exp_cutoff = 1, save_path = tempdir())
PreEnzymeNet <- function(gene_exp, network, gene_mapping, gene_feature,
                         cell_name, exp_cutoff, dep_data=NULL, save_path){
  ###cell expressed gene which TPM > exp_cutoff
  cell_exp <- gene_exp[cell_name]
  cell_exp$gene <- rownames(cell_exp)
  colnames(cell_exp)[1] <- "exp"
  cell_exp <- cell_exp$gene[which(cell_exp$exp > exp_cutoff)]
  ###
  cell_net <- data.frame(id = unique(c(network$from, network$to))) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(gene=ensg2name(.data$id,gene_mapping,cell_exp,gene_feature)[[1]],
                  fea=ensg2name(.data$id,gene_mapping,cell_exp,gene_feature)[[2]],
                  is_exp=ensg2name(.data$id,gene_mapping,cell_exp,gene_feature)[[3]]) %>%
    dplyr::ungroup() %>%
    dplyr::filter(nchar(.data$gene)>1 & .data$is_exp & !is.na(.data$fea))
  cell_net <- cell_net %>%
    tidyr::separate_wider_delim(cols = .data$fea,delim = ",",names_sep="-") %>%
    dplyr::mutate(dplyr::across(dplyr::starts_with("fea-"),as.numeric))

  ####add dep data
  if (!is.null(dep_data)){
    dep_cell <- dep_data %>% dplyr::filter(.data$ModelID == cell_name)
    cell_net_dep <- cell_net %>%
      dplyr::rowwise() %>%
      dplyr::mutate(is_dep = get_dep(.data$gene,dep_cell)) %>%
      dplyr::ungroup() %>%
      dplyr::select(1:2,.data$is_dep,dplyr::everything())

    write.table(cell_net_dep,
                file = paste0(save_path, "/", cell_name, "_feat.txt"),
                sep = "\t",row.names = F)
  }else{
    write.table(cell_net,
                file = paste0(save_path, "/", cell_name, "_feat.txt"),
                sep = "\t",row.names = F)
  }
  write.table(network,
              file = paste0(save_path, "/", cell_name, ".txt"),
              sep = "\t",row.names = F)
}
