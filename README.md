# Computational Drug Repositioning – Reproducible Pipeline (Nextflow DSL2)

This repository provides a **modular, reproducible pipeline** for computational drug repositioning:
**data mining & bioinformatics, network pharmacology, signature-based matching, ML scoring, docking,
molecular dynamics + MM/GBSA, ADMET/PK screening**, and a consolidated HTML report.

- **Engine:** Nextflow (DSL2); profiles for local, SLURM, AWS Batch.
- **Reproducibility:** per-step Conda envs (or containers), fixed seeds, deterministic artifacts.
- **Onboarding:** `-stub-run` works out‑of‑the‑box (no heavy dependencies), producing
  placeholder outputs and a demo report.

> This pipeline operationalizes the stages described in the *Computational Drug Repositioning* brochure
> (bioinformatics data mining, network pharmacology, docking, virtual screening, pharmacokinetic simulation,
> MD) and mirrors the report components shown for binding/stability/network analysis.
>
> Generated: **2025-08-30**

---

## Quickstart

### 1) Smoke test (no dependencies)
```bash
# Requires Java 11+
curl -s https://get.nextflow.io | bash
./nextflow run workflows/main.nf -stub-run -profile standard
```
This will create `report/report.html` and CSVs in module folders.

### 2) Real run (with Conda)
```bash
./nextflow run workflows/main.nf \
  -params-file configs/params.example.yaml \
  -profile conda,local \
  -with-report -with-trace -with-timeline
```

For **HPC** use `-profile conda,slurm`; for **containers** use `-profile docker` or `-profile singularity`
and add image digests in `configs/nextflow.config`.

---

## Inputs
- `data/drugs.smi` – candidate drugs (SMILES + ID)
- `data/drug_targets.csv` – drug → target gene(s)
- `data/disease_genes.txt` – disease module (gene list)
- `data/ppi.sif` – interactome subset (tab‑separated: nodeA nodeB)
- `data/target_structures/target.pdb` – protein structure for docking
- (optional) `data/signatures/` – disease up/down genes and drug signatures

## Key outputs
- `network/proximity.csv` – network proximity scores (drug–disease)
- `signatures/connectivity.csv` – signature reversal/connectivity scores
- `docking/binding_affinities.csv` – AutoDock Vina docking scores
- `md/qc.csv` – MD quality metrics; `mmgbsa/summary.csv` – ΔG terms
- `admet/admet.csv` – basic ADMET/PK proxy metrics from RDKit descriptors
- `ranking/final_ranking.csv` – multi‑objective score across modules
- `report/report.html` – consolidated report

## Structure
```
drug-repositioning-pipeline/
├─ data/                     # demo inputs (replace with your own)
├─ workflows/main.nf         # orchestrates modules
├─ modules/                  # 01..10 modules (DSL2)
├─ envs/                     # per‑module Conda envs (pinned)
├─ configs/                  # nextflow + profiles
├─ scripts/                  # helper Python scripts
├─ docs/mapping.md           # brochure-to-module mapping
└─ .github/workflows/ci.yml  # GitHub Actions_stub smoke test
```

## License
MIT
