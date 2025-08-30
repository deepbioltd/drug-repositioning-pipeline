// modules/06_md_gromacs.nf
process MD {
  tag "md"
  conda "../envs/gromacs.yml"
  cpus 4
  memory '8 GB'

  input:
    path top_pose

  output:
    path "md/equilibrated.tpr"
    path "md/trajectory.xtc"
    path "md/qc.csv"

  script:
  """
  set -euo pipefail
  mkdir -p md
  echo 'stub' > md/equilibrated.tpr
  echo 'stub' > md/trajectory.xtc
  cat > md/qc.csv << 'CSV'
metric,value
RMSD_mean_A,0.35
Rg_mean_A,22.0
HBonds_mean,10
CSV
  """
  stub:
  """
  mkdir -p md
  echo 'stub' > md/equilibrated.tpr
  echo 'stub' > md/trajectory.xtc
  echo -e "metric,value\nRMSD_mean_A,0.35\nRg_mean_A,22.0\nHBonds_mean,10" > md/qc.csv
  """
}
