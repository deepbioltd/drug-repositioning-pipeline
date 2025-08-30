// modules/10_report.nf
process REPORT {
  tag "report"
  conda "../envs/report.yml"
  cpus 1
  memory '1 GB'

  input:
    path proximity_csv
    path connectivity_csv
    path docking_csv
    path admet_csv
    path md_qc_csv
    path mmgbsa_csv
    path ranking_csv

  output:
    path "report/report.html"

  script:
  """
  set -euo pipefail
  mkdir -p report
  python3 ../scripts/report.py "${proximity_csv}" "${connectivity_csv}" "${docking_csv}" "${admet_csv}" "${md_qc_csv}" "${mmgbsa_csv}" "${ranking_csv}" report/report.html
  """
  stub:
  """
  mkdir -p report
  echo '<h1>Stub Report</h1><p>Run without -stub-run to build a detailed report.</p>' > report/report.html
  """
}
