#' Convert ENSEMBL ID to Gene Symbol and get corresponding features
#'
#' Convert ENSEMBL gene ID to Gene symbol, extract CPG gene features and gene expression information.
#'
#' @param ensg A character String, indicting ENSEMBL gene ID; gene complex with multiple gene ID separated by commas
#' @param mapping A dataframe, gene ID mapping file, containing at least two columns of `ensembl_id` and `symbol`
#' @param exp_list A character vector, containing expressed gene symbols.
#' @param pathway A dataframe, gene CPG features, which rowname is name of pathway and colname is gene symbol
#' @importFrom rlang .data
#' @return A list with three elements, gene symbol, gene CPG feature, and whether the gene is expressed
#' @export
#'
#' @examples
#' library(dplyr)
#' data("enz_gene_mapping")
#' data("cpg_gene")
#' data("SkinCancerNet")
#' data("cell_info")
#' data("gene_exp")
#' cell_info <- cell_info %>% filter(grepl("SkinCancer",origin_net))
#' gene_exp <- gene_exp %>% select(any_of(cell_info$ModelID))
#'
#' ##Net with gene expressed in cell ACH-001521
#' cell_exp <- gene_exp["ACH-001521"]
#' cell_exp$gene <- rownames(cell_exp)
#' colnames(cell_exp)[1] <- "exp"
#' cell_exp <- cell_exp$gene[which(cell_exp$exp > 1)]
#'
#' SkinCancerNet <- SkinCancerNet[1:10,]
#' cell_net <- data.frame(id = unique(c(SkinCancerNet$from,SkinCancerNet$to))) %>%
#'    rowwise() %>%
#'    mutate(gene = ensg2name(id,enz_gene_mapping,cell_exp,cpg_gene)[[1]],
#'           fea = ensg2name(id,enz_gene_mapping,cell_exp,cpg_gene)[[2]],
#'           is_exp = ensg2name(id,enz_gene_mapping,cell_exp,cpg_gene)[[3]]) %>%
#'    ungroup()
#'
ensg2name <- function(ensg, mapping, exp_list=NULL, pathway){
  split_genes <- strsplit(ensg," and ")[[1]]
  split_genes <- mapping$symbol[which(mapping$ensembl_id %in% split_genes)] %>%
    unique()
  sym <- paste(split_genes, collapse=",")
  gene_fea <- pathway %>% dplyr::select(dplyr::any_of(split_genes))
  if (nrow(gene_fea) != 0){
    if (ncol(gene_fea) == 1){
      gene_fea$final <- gene_fea[,1]
    }else{
      gene_fea$final <- rowSums(gene_fea[ , colnames(gene_fea)])
    }
    gene_fea <- gene_fea %>%
      dplyr::mutate(final = ifelse(.data$final == 0,0,1))
    if (is.null(exp_list)){
      is_exp <- NA
    }else{
      is_exp <- all(split_genes %in% exp_list)
    }
    return(list(sym,paste(gene_fea$final,collapse = ","),is_exp))
  }else{
    if (is.null(exp_list)){
      is_exp <- NA
    }else{
      is_exp <- all(split_genes %in% exp_list)
    }
    return(list(sym,NA,is_exp))
  }
}

#' Get dependency probability label for gene
#'
#' For one specific gene or gene complex, extract corresponding dependency probability score.
#' The dependency probability score of the gene complex is the max score of genes in the gene complex.
#'
#' @param gene Character string, gene name or gene complex with multiple gene names separated by commas.
#' @param dep_data Dataframe, dependency probability score data with at least three columns, ModelID, gene and type.
#' @param per_cell_mode Boolean value, whether in single cell mode
#' @param cell_name Character string, only used when `per_cell_mode` is TRUE, cell line ID, match with ModelID in `dep_data`
#'
#' @return Dependency probability lable for specific gene
#' @export
#'
#' @examples
#' library(dplyr)
#' data("dep_data")
#' get_dep(gene = "ACAA1,EHHADH,HSD17B4", dep_data = dep_data,
#' per_cell_mode = TRUE, cell_name = "ACH-000014")
get_dep <- function(gene, dep_data, per_cell_mode=FALSE, cell_name=NULL){
  split_genes <- strsplit(gene,",")[[1]]
  if (per_cell_mode){
    dt <- dep_data %>%
      dplyr::filter(.data$gene %in% split_genes) %>%
      dplyr::filter(.data$ModelID %in% cell_name)
  }else{
    dt <- dep_data %>% dplyr::filter(.data$gene %in% split_genes)
  }
  if (nrow(dt) == 0){
    return(NA)
  }else{
    return(max(dt$type))
  }
}


