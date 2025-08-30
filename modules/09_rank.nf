// modules/09_rank.nf
process RANK {
  tag "rank"
  conda "../envs/general.yml"
  cpus 1
  memory '2 GB'

  input:
    path proximity_csv
    path connectivity_csv
    path docking_csv
    path admet_csv

  output:
    path "ranking/final_ranking.csv"

  script:
  """
  set -euo pipefail
  mkdir -p ranking
  python - << 'PY'
import pandas as pd, os, json
W = {"network": 0.30, "signatures": 0.30, "docking": 0.20, "admet": 0.20}
P = pd.read_csv("${proximity_csv}") if os.path.exists("${proximity_csv}") else pd.DataFrame()
C = pd.read_csv("${connectivity_csv}") if os.path.exists("${connectivity_csv}") else pd.DataFrame()
D = pd.read_csv("${docking_csv}") if os.path.exists("${docking_csv}") else pd.DataFrame()
A = pd.read_csv("${admet_csv}") if os.path.exists("${admet_csv}") else pd.DataFrame()
df = P.merge(C, on="drug", how="outer").merge(D, on="drug", how="outer").merge(A[["drug","Lipinski"]], on="drug", how="left")
for col in ["network_proximity","connectivity","affinity"]:
    if col in df and df[col].notna().sum()>0:
        if col=="affinity":
            df[col+"_norm"] = (df[col].max()-df[col])/(df[col].max()-df[col].min()+1e-9)
        else:
            df[col+"_norm"] = (df[col]-df[col].min())/(df[col].max()-df[col].min()+1e-9)
    else:
        df[col+"_norm"] = 0.0
df["admet_norm"] = df["Lipinski"].fillna(0)
df["score"] = W["network"]*df["network_proximity_norm"] + W["signatures"]*df["connectivity_norm"] + W["docking"]*df["affinity_norm"] + W["admet"]*df["admet_norm"]
df.sort_values("score", ascending=False).to_csv("ranking/final_ranking.csv", index=False)
PY
  """
  stub:
  """
  mkdir -p ranking
  echo -e "drug,score\nAspirin,0.78\nMetformin,0.55" > ranking/final_ranking.csv
  """
}
