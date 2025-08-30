# Brochure → Pipeline Module Mapping

- **Bioinformatics analysis & data mining** (p.5): modules `01_ingest_data`, `02_network_build`
- **Network pharmacology** (p.5): `02_network_build` computes drug–disease proximity and network metrics
- **Machine learning / pathway-based clustering** (p.5): `03_signature_matching` + `04_ml_link_prediction`
- **Docking & virtual screening** (p.6; plus p.9–10 mentions AutoDock & ZINC): `05_docking_screen`
- **Pharmacokinetic simulation** (p.6): `08_admet_pk` (offline descriptors + proxy models)
- **Molecular dynamics** (p.6) and **stability analysis** (p.8): `06_md_gromacs` + `07_mmgbsa`
- **Binding mode & docking analysis** (p.8): `05_docking_screen` outputs pose scores and contacts
- **Software** (p.10: AutoDock, Schrödinger Suite, GROMACS): we use **AutoDock Vina** and **GROMACS**.
