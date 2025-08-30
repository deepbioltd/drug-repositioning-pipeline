// modules/03_signature_matching.nf
process SIGN {
  tag "signatures"
  conda "../envs/general.yml"
  cpus 1
  memory '2 GB'

  input:
    path disease_up
    path disease_down
    path drug_signatures

  output:
    path "signatures/connectivity.csv"

  script:
  """
  set -euo pipefail
  mkdir -p signatures
  python - << 'PY'
import pandas as pd
up = set([l.strip() for l in open("${disease_up}") if l.strip()])
down = set([l.strip() for l in open("${disease_down}") if l.strip()])
ds = pd.read_csv("${drug_signatures}")
def toy_score(df):
    s = 0.0
    for _,r in df.iterrows():
        g = r["gene"]
        if g in up: s += -r["logFC"]
        if g in down: s += r["logFC"]
    return s
scores = ds.groupby("drug").apply(toy_score).reset_index().rename(columns={0:"connectivity"})
scores.sort_values("connectivity", ascending=False).to_csv("signatures/connectivity.csv", index=False)
PY
  """
  stub:
  """
  mkdir -p signatures
  echo -e "drug,connectivity\nAspirin,0.8\nMetformin,0.6" > signatures/connectivity.csv
  """
}
