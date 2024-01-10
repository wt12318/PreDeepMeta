#' Cell line information
#'
#' A subset data, which contains 100 cell lines of 5 tissues, of DepMap data.
#'
#' @format ## `cell_info`
#' A data frame with 100 rows and 5 columns:
#' \describe{
#'   \item{ModelID}{Cell line DepMap ID}
#'   \item{cell}{Tissue of the cell line, original name in DepMap is OncotreeLineage}
#'   \item{origin_net}{Name of original metabolic network downloaded from Metabolic Atlas}
#'   \item{net}{Name of transformed enzyme network by Met2Graph package}
#' }
#' @source DepMap
"cell_info"

#' Gene expression of cell lines
#'
#' A subset data, which contains gene expression of 81 cell lines , of DepMap data.
#'
#' @format ## `gene_exp`
#' A data frame with 19193 rows and 81 columns:
#' \describe{
#'   \item{ACH-001521}{Gene mRNA expression of cell line ACH-001521, unit is log2(TPM+1)}
#'   ...
#' }
#' @source DepMap
"gene_exp"

#' Edge list of enzyme network of Prostate Cancer
#'
#' Cancer-specific enzyme network represented by edge list, converted from XML file using Met2Graph
#'
#' @format ## `ProstateCancerNet`
#' A data frame with 18441 rows and 3 columns:
#' \describe{
#'   \item{from}{One node}
#'   \item{to}{Another node}
#'   \item{Metabolite}{Metabolite ID which connect from node and to node}
#' }
#' @source NULL
"ProstateCancerNet"

#' Edge list of enzyme network of Skin Cancer
#'
#' Cancer-specific enzyme network represented by edge list, converted from XML file using Met2Graph
#'
#' @format ## `SkinCancerNet`
#' A data frame with 18441 rows and 3 columns:
#' \describe{
#'   \item{from}{One node}
#'   \item{to}{Another node}
#'   \item{Metabolite}{Metabolite ID which connect from node and to node}
#' }
#' @source NULL
"SkinCancerNet"

#' Edge list of enzyme network of Pancreatic Cancer
#'
#' Cancer-specific enzyme network represented by edge list, converted from XML file using Met2Graph
#'
#' @format ## `PancreaticCancerNet`
#' A data frame with 21500 rows and 3 columns:
#' \describe{
#'   \item{from}{One node}
#'   \item{to}{Another node}
#'   \item{Metabolite}{Metabolite ID which connect from node and to node}
#' }
#' @source NULL
"PancreaticCancerNet"

#' Edge list of enzyme network of Urothelial Cancer
#'
#' Cancer-specific enzyme network represented by edge list, converted from XML file using Met2Graph
#'
#' @format ## `UrothelialCancerNet`
#' A data frame with 18553 rows and 3 columns:
#' \describe{
#'   \item{from}{One node}
#'   \item{to}{Another node}
#'   \item{Metabolite}{Metabolite ID which connect from node and to node}
#' }
#' @source NULL
"UrothelialCancerNet"

#' Edge list of enzyme network of Cervical Cancer
#'
#' Cancer-specific enzyme network represented by edge list, converted from XML file using Met2Graph
#'
#' @format ## `CervicalCancerNet`
#' A data frame with 19514 rows and 3 columns:
#' \describe{
#'   \item{from}{One node}
#'   \item{to}{Another node}
#'   \item{Metabolite}{Metabolite ID which connect from node and to node}
#' }
#' @source NULL
"CervicalCancerNet"

#' Gene ID mapping file
#'
#' Gene ID mapping between Entrez gene ID and ENSEMBL ID and Gene Symbol
#'
#' @format ## `enz_gene_mapping`
#' A data frame with 40102 rows and 3 columns:
#' \describe{
#'   \item{gene_id}{Entrez gene ID}
#'   \item{ensembl_id}{ENSEMBL gene ID}
#'   \item{symbol}{Gene Symbol}
#' }
#' @source NULL
"enz_gene_mapping"

#' Gene CPG features
#'
#' To obtain the features of genes, we collected the CGP (chemical and genetic perturbations) gene sets from MSigDB database.
#' After filter gene sets without any gene existed in GSMs, we got 3247 gene sets.
#' For each gene to be predicted, its feature is a 3247-dimensional 0/1 vector
#'
#' @format ## `cpg_gene`
#' A data frame with 3247 rows and 3075 columns:
#' \describe{
#'   \item{A4GALT}{The CPG feature of gene A4GALT}
#'   ...
#' }
#' @source MSigDB database
"cpg_gene"

#' Gene dependency data
#'
#' Subset of post-Chronos gene dependency probability score data obtained from Depmap.
#' This subset data only contains 25 skin cancer cell lines.
#'
#' @format ## `dep_data`
#' A data frame with 436325 rows and 4 columns:
#' \describe{
#'   \item{ModelID}{Cell line DepMap ID}
#'   \item{gene}{Gene symbol}
#'   \item{score}{post-Chronos gene dependency probability score}
#'   \item{type}{Dependency label, when score > 0.5 the label is 1, otherwise 0}
#' }
#' @source DepMap database
"dep_data"




