// workflows/main.nf
nextflow.enable.dsl=2

include { INGEST }   from '../modules/01_ingest_data.nf'
include { NET }      from '../modules/02_network_build.nf'
include { SIGN }     from '../modules/03_signature_matching.nf'
include { ML }       from '../modules/04_ml_link_prediction.nf'
include { DOCK }     from '../modules/05_docking_screen.nf'
include { MD }       from '../modules/06_md_gromacs.nf'
include { MMGBSA }   from '../modules/07_mmgbsa.nf'
include { ADMET }    from '../modules/08_admet_pk.nf'
include { RANK }     from '../modules/09_rank.nf'
include { REPORT }   from '../modules/10_report.nf'

workflow {
  Channel.fromPath(params.drugs_smi).set { drugs_ch }
  Channel.fromPath(params.drug_targets_csv).set { dt_ch }
  Channel.fromPath(params.disease_genes).set { disease_ch }
  Channel.fromPath(params.ppi_sif).set { ppi_ch }
  Channel.fromPath(params.target_pdb).set { pdb_ch }
  Channel.fromPath(params.disease_up).set { up_ch }
  Channel.fromPath(params.disease_down).set { down_ch }
  Channel.fromPath(params.drug_sigs).set { dsigs_ch }

  INGEST(drugs_ch, dt_ch, disease_ch, ppi_ch)

  NET(INGEST.out[0], INGEST.out[1], INGEST.out[2])

  SIGN(up_ch, down_ch, dsigs_ch)

  ML(INGEST.out[0], NET.out[0])  // optional ML score (stub)

  DOCK(pdb_ch, drugs_ch)

  MD(DOCK.out[1])                // pass top pose (stubbed artifacts)
  MMGBSA(MD.out[0], MD.out[1])

  ADMET(drugs_ch)

  RANK(NET.out[1], SIGN.out[0], DOCK.out[0], ADMET.out[0])

  REPORT(NET.out[1], SIGN.out[0], DOCK.out[0], ADMET.out[0], MD.out[2], MMGBSA.out[0], RANK.out[0])
}
