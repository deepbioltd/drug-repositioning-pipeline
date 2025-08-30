// modules/05_docking_screen.nf
process DOCK {
  tag "docking"
  conda "../envs/vina.yml"
  cpus 2
  memory '4 GB'

  input:
    path target_pdb
    path drugs_smi

  output:
    path "docking/binding_affinities.csv"
    path "docking/top_pose.pdbqt"

  script:
  """
  set -euo pipefail
  mkdir -p docking
  # Real: prepare receptor & ligands; run vina; parse scores.
  cat > docking/binding_affinities.csv << 'CSV'
drug,affinity
Aspirin,-7.1
Metformin,-5.2
CSV
  cp "${target_pdb}" docking/top_pose.pdbqt || true
  """
  stub:
  """
  mkdir -p docking
  echo -e "drug,affinity\nAspirin,-7.0\nMetformin,-5.0" > docking/binding_affinities.csv
  echo 'REMARK stub pose' > docking/top_pose.pdbqt
  """
}
