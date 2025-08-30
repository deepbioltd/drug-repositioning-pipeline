// modules/04_ml_link_prediction.nf
process ML {
  tag "ml"
  conda "../envs/general.yml"
  cpus 1
  memory '2 GB'

  input:
    path drugs_parquet
    path graph_gpickle

  output:
    path "ml/ml_scores.csv"

  script:
  """
  set -euo pipefail
  mkdir -p ml
  echo -e "drug,ml_score\nAspirin,0.55\nMetformin,0.52" > ml/ml_scores.csv
  """
  stub:
  """
  mkdir -p ml
  echo -e "drug,ml_score\nAspirin,0.55\nMetformin,0.52" > ml/ml_scores.csv
  """
}
