#' Prepare DeepMeta model differential expression profile input
#'
#' DeepMeta framework has two inputs, the sample-specific enzyme network and the differential expression data.
#' The sample-specific enzyme network (SEN) is constructed from cancer-specific or tissue-specific GSMs (Genome-Scale Metabolic Models),
#' and in this network, enzymes are the nodes connected by edges represented by metabolites.
#' SEN are constructed by removing genes in the cancer-specific enzyme network that are not expressed in the sample,
#' defined as expression levels below 1 TPM. The features of gene nodes in the enzyme network are composed of 3247-dimensional binary (0/1) vector,
#' indicating whether the gene is exist in the collected 3247 CPG (chemical and genetic perturbation) gene set. This function
#' prepares gene differential expression profile input, consisting 7993 gene differential expression compared to GTEx normal tissue.
#'
#' @param tumor_exp A dataframe, gene expression of tumor samples, rows are gene names and cols are sample names, unit is log2(TPM+1)
#' @param normal_exp A dataframe, normal tissue median expression, the first column with name `Description` is gene symbol and following columns are different tissues, unit is TPM
#' @param tumor_normal_mapping A dataframe, mapping between sample name (in `tumor_exp`) and tissue name (in `normal_exp`)
#' @param gene_order A character vector, containing the genes of DeepMeta input. Can obtained by calling `data("model_gene_order")`
#' @param save_file A boolean value, whether save file
#' @param save_path A character string, file save path, needed when `save_file` is TRUE
#' @importFrom utils setTxtProgressBar
#' @importFrom utils txtProgressBar
#' @importFrom utils write.csv
#' @importFrom crayon red
#' @return A dataframe of differential expression with first column is sample name and following columns are gene names
#' @export
#'
#' @examples
#' library(dplyr)
#' data("gene_exp")
#' data("Gtex_exp5")
#' data("cell_info")
#' data("model_gene_order")
#' res <- PreDiffExp(tumor_exp = gene_exp, normal_exp = Gtex_exp5,
#'                   tumor_normal_mapping = cell_info,
#'                   gene_order = model_gene_order,
#'                   save_file = FALSE)
PreDiffExp <- function(tumor_exp, normal_exp,
                       tumor_normal_mapping, gene_order,
                       save_file=FALSE, save_path = NULL){

  all_cells <- intersect(unique(colnames(tumor_exp)),tumor_normal_mapping$ModelID)
  all_genes <- gene_order

  ###check whether all genes exist
  not_in_tumor <- all_genes[which(!(all_genes %in% rownames(tumor_exp)))]
  if (length(not_in_tumor) != 0){
    stop(crayon::red(paste(not_in_tumor,collapse = ","),
                     " not in rownames of tumor_exp, please check!"))
  }
  not_in_normal <- all_genes[which(!(all_genes %in% normal_exp$Description))]
  if (length(not_in_normal) != 0){
    stop(crayon::red(paste(not_in_normal,collapse = ","),
                     " not in Description of normal_exp, please check!"))
  }

  pb <- txtProgressBar(min = 0, max = length(all_cells),
                       style = 3, width = 50, char = "=")
  res <- vector("list",length(all_cells))
  for (i in 1:length(all_cells)){
    normal_tissue <- tumor_normal_mapping$normal[which(tumor_normal_mapping$ModelID==all_cells[i])]
    ne <- normal_exp %>%
      dplyr::select(.data$Description, dplyr::all_of(normal_tissue)) %>%
      dplyr::filter(.data$Description %in% all_genes) %>%
      dplyr::rename("gene" = "Description")
    colnames(ne)[2] <- "exp"
    ###same gene mean
    ne <- ne %>%
      dplyr::group_by(.data$gene) %>%
      dplyr::summarise(exp = mean(.data$exp)) %>%
      dplyr::ungroup() %>%
      as.data.frame()
    rownames(ne) <- ne$gene
    ne <- ne[all_genes,]
    colnames(ne)[2] <- all_cells[i]
    res[[i]] <- ne %>% dplyr::select(-.data$gene)
    setTxtProgressBar(pb, i)
  }
  close(pb)
  res <- dplyr::bind_cols(res)

  tumor_exp <- tumor_exp[all_genes,all_cells] %>% as.matrix()
  normal_exp <- as.matrix(res)

  diff <- tumor_exp / (log2(normal_exp + 1.01))
  diff <- diff %>% t() %>% as.data.frame()
  diff$cell <- rownames(diff)
  diff <- diff %>% dplyr::select(.data$cell, dplyr::everything())
  if (save_file){
    write.csv(diff,
              file = save_path,
              quote = F,row.names = F)
  }
  return(diff)
}
