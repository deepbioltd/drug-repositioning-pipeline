// modules/08_admet_pk.nf
process ADMET {
  tag "admet"
  conda "../envs/rdkit.yml"
  cpus 1
  memory '2 GB'

  input:
    path drugs_smi

  output:
    path "admet/admet.csv"

  script:
  """
  set -euo pipefail
  mkdir -p admet
  python - << 'PY'
from rdkit import Chem
from rdkit.Chem import Descriptors, Crippen
import pandas as pd
records = []
for line in open("${drugs_smi}"):
  if not line.strip(): continue
  smi, name = line.strip().split("\t")
  m = Chem.MolFromSmiles(smi)
  mw = Descriptors.MolWt(m)
  logp = Crippen.MolLogP(m)
  hbd = Descriptors.NumHDonors(m)
  hba = Descriptors.NumHAcceptors(m)
  psa = Descriptors.TPSA(m)
  lipinski = int((mw < 500) and (logp < 5) and (hbd <= 5) and (hba <= 10))
  records.append({"drug": name, "MW": mw, "logP": logp, "HBD": hbd, "HBA": hba, "TPSA": psa, "Lipinski": lipinski})
pd.DataFrame(records).to_csv("admet/admet.csv", index=False)
PY
  """
  stub:
  """
  mkdir -p admet
  echo -e "drug,MW,logP,HBD,HBA,TPSA,Lipinski\nAspirin,180.16,1.2,1,4,63.6,1\nMetformin,129.16,-1.4,3,5,88.5,1" > admet/admet.csv
  """
}
