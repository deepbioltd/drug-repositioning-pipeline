// modules/02_network_build.nf
process NET {
  tag "network"
  conda "../envs/general.yml"
  cpus 1
  memory '3 GB'

  input:
    path drugs_parquet
    path disease_genes
    path ppi_sif

  output:
    path "network/graph.gpickle"
    path "network/proximity.csv"

  script:
  """
  set -euo pipefail
  mkdir -p network
  python - << 'PY'
import pandas as pd, networkx as nx
# Build PPI graph
G = nx.Graph()
with open("${ppi_sif}") as f:
    for line in f:
        a,b = line.strip().split()
        G.add_edge(a,b,weight=1)
nx.write_gpickle(G, "network/graph.gpickle")

# Placeholder proximity: shared neighbors between disease genes and toy drug targets
drug_targets = {"Aspirin": ["PTGS1","PTGS2"], "Metformin": ["PRKAA1","PRKAA2"]}
disease = [l.strip() for l in open("${disease_genes}") if l.strip()]
def score(drug):
    tgts = drug_targets.get(drug, [])
    neighbors = set()
    for t in tgts:
        if t in G: neighbors |= set(G.neighbors(t))
    inter = len(neighbors & set(disease))
    return inter / max(1,len(tgts))

out = pd.DataFrame({"drug": list(drug_targets.keys()), "network_proximity": [score(d) for d in drug_targets]})
out.sort_values("network_proximity", ascending=False).to_csv("network/proximity.csv", index=False)
PY
  """
  stub:
  """
  mkdir -p network
  echo -e "drug,network_proximity\nAspirin,0.67\nMetformin,0.33" > network/proximity.csv
  echo 'stub' > network/graph.gpickle
  """
}
