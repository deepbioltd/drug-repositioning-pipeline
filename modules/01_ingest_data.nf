// modules/01_ingest_data.nf
process INGEST {
  tag "ingest"
  conda "../envs/general.yml"
  cpus 1
  memory '2 GB'

  input:
    path drugs_smi
    path drug_targets_csv
    path disease_genes
    path ppi_sif

  output:
    path "ingest/drugs.parquet"
    path "ingest/disease_genes.txt"
    path "ingest/ppi.sif"

  script:
  """
  set -euo pipefail
  mkdir -p ingest
  # Convert SMILES to a simple table
  python - << 'PY'
import pandas as pd
smiles = []
with open("${drugs_smi}") as f:
    for line in f:
        if not line.strip(): continue
        smi, name = line.strip().split("\t")
        smiles.append({"drug": name, "smiles": smi})
pd.DataFrame(smiles).to_parquet("ingest/drugs.parquet", index=False)
PY
  cp "${disease_genes}" ingest/disease_genes.txt
  cp "${ppi_sif}" ingest/ppi.sif
  """
  stub:
  """
  mkdir -p ingest
  echo 'drug,smiles' > ingest/drugs.parquet
  cp "${disease_genes}" ingest/disease_genes.txt
  cp "${ppi_sif}" ingest/ppi.sif
  """
}
