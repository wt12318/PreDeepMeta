# PreDeepMeta

### Introduction

we present the DeepMeta framework to predict the dependence of metabolic genes based on the local pathway information characterized by enzyme networks and sample status information characterized by gene expression. Thus, this framework has two inputs, the sample-specific enzyme network and the differential expression data. The sample-specific enzyme network (SEN) is constructed from cancer-specific or tissue-specific GSMs (Genome-Scale Metabolic Models), and in this network, enzymes are the nodes connected by edges represented by metabolites. SEN are constructed by removing genes in the cancer-specific enzyme network that are not expressed in the sample, defined as expression levels below 1 TPM. The features of gene nodes in the enzyme network are composed of 3247-dimensional binary (0/1) vector, indicating whether the gene is exist in the collected 3247 CPG (chemical and genetic perturbation) gene set. The gene expression was represented by expression of genes in cancer relative to normal tissue, which reflects dysregulated cancer cell state.

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/undefined%E5%9B%BE%E7%89%8711-20240111152705-7zwvtug.png)

This package can be used for preparation of DeepMeta two kind of input. Can be installed by:

```r
devtools::install_github("wt12318/PreDeepMeta")
```

### Usage

`PreDeepMeta`​ has two main functions for preparing DeepMeta input:

* `PreEnzymeNet`​ for enzyme net and corresponding gene node features
* `PreDiffExp`​ for differential expression profile

`PreEnzymeNet`​ function has six mandatory input and one optional input:

* gene_exp: gene expression matrix (gene × sample), the unit is log2(TPM + 1)
* network: network in edgelist format, at least three columns with name of `from`​ and `to`​, indicating nodes in network, the gene ID in `from`​ and `to`​ is ENSEMBL ID
* gene_mapping: mapping of different gene IDs, at least contains two columns with name of `ensembl_id`​ and `symbol`​
* gene_feature: gene CPG features, rows are CPG pathways, cols are gene symbol. The CPG features of 3075 genes used in our manuscript can be used by calling `data("cpg_gene")`​
* cell_name: cell line or sample ID, which cell/sample do you want to analysis, must match with colname of above gene_exp dataframe
* dep_data: optional, gene dependency data, at least contains three columns with name of `ModelID`​, `gene`​ and `type`​. When this file is provided, the output file `_feat.txt`​ will contain another column with name `is_dep`​, indicting whether the cell is dependent on the gene.
* save_path: the path where the output file is stored

```R
library(dplyr)
data("gene_exp")
data("SkinCancerNet")
data("enz_gene_mapping")
data("cpg_gene")
data("dep_data")
PreEnzymeNet(gene_exp, network = SkinCancerNet,
			 gene_mapping = enz_gene_mapping, gene_feature = cpg_gene,
	 		 cell_name = "ACH-001521", dep_data = dep_data, save_path = ".")
##or without dependency data
PreEnzymeNet(gene_exp, network = SkinCancerNet,
			 gene_mapping = enz_gene_mapping, gene_feature = cpg_gene,
			 cell_name = "ACH-001521", save_path = ".")
```

The output contains two files: `_feat.txt`​ and `.txt`​ ; The first two columns of `_feat.txt`​ file are `id`​ and `gene`​, refering to gene ENSEMBL ID and gene symbol, if `dep_data`​ is provided, then the third colum is `is_dep`​, and the following columns are gene CPG features.  The `.txt`​ file contains three columns with name `from`​ , `to`​ and `Metabolite`​, is the edge list format of enzyme network. 

```R
list.files(".",pattern = ".txt")
[1] "ACH-001521_feat.txt" "ACH-001521.txt" 
dt <- data.table::fread("ACH-001521_feat.txt",data.table = F)
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/undefinedimage-20240111163157-83vj6jz.png)​

```R
dt <- data.table::fread("ACH-001521.txt",data.table = F)
```

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/undefinedimage-20240111163224-ky5k3qk.png)​

`PreDiffExp`​ function has four mandatory input and two optional input:

* tumor_exp: gene expression matrix (gene × sample), the unit is log2(TPM + 1)
* normal_exp: normal tissue median expression, the first column with name `Description`​ is gene symbol and following columns are median gene expression of different tissues, unit is TPM, this file can be download from GTEx
* tumor_normal_mapping: mapping between sample name (in `tumor_exp`​) and tissue name (in `normal_exp`​)
* gene_order: the input order of genes. Can obtained by calling `data("model_gene_order")`​
* save_file: A boolean value, whether save file in `csv`​ format
* save_path: file save path, needed when `save_file`​ is TRUE

```R
library(dplyr)
data("gene_exp")
data("Gtex_exp5")
data("cell_info")
data("model_gene_order")
res <- PreDiffExp(tumor_exp = gene_exp, normal_exp = Gtex_exp5,
                  tumor_normal_mapping = cell_info,
                  gene_order = model_gene_order,
                  save_file = FALSE)
```

The output is sample × gene expression matrix, which the number of gene is 7993. The first column is cell/sample ID:

![](https://picgo-wutao.oss-cn-shanghai.aliyuncs.com/undefinedimage-20240111164409-yov9gya.png)​

The value of this dataframe is differential expression, defined by:

$$
\frac{Tumor}{log2(Normal+0.01)}
$$

‍
