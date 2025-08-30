#!/usr/bin/env python3
import sys, pandas as pd, os, pathlib
from datetime import datetime

if len(sys.argv) != 9:
    print("Usage: report.py <proximity.csv> <connectivity.csv> <binding_affinities.csv> <admet.csv> <md_qc.csv> <mmgbsa.csv> <ranking.csv> <out.html>")
    sys.exit(1)

proximity, connectivity, docking, admet, mdqc, mmgbsa, ranking, out_html = sys.argv[1:]

def maybe_read(p):
    try:
        return pd.read_csv(p)
    except Exception:
        return pd.DataFrame()

P = maybe_read(proximity)
C = maybe_read(connectivity)
D = maybe_read(docking)
A = maybe_read(admet)
Q = maybe_read(mdqc)
M = maybe_read(mmgbsa)
R = maybe_read(ranking)

html = []
html.append("<h1>Computational Drug Repositioning Report</h1>")
html.append(f"<p>Generated: {datetime.now().isoformat()}</p>")
def tbl(title, df, n=20):
    if df is None or df.empty:
        return f"<h2>{title}</h2><p><em>No data.</em></p>"
    return "<h2>{}</h2>{}".format(title, df.head(n).to_html(index=False))

html.append(tbl("Network Proximity (Top)", P))
html.append(tbl("Signature Connectivity Scores (Top)", C))
html.append(tbl("Docking Scores (Vina) (Top)", D))
html.append(tbl("ADMET / PK Proxies", A))
html.append(tbl("MD Quality Metrics", Q))
html.append(tbl("MM/GBSA Summary", M))
html.append(tbl("Final Candidate Ranking", R, n=50))

pathlib.Path(out_html).parent.mkdir(parents=True, exist_ok=True)
with open(out_html, "w", encoding="utf-8") as f:
    f.write("\n".join(html))

print(f"[report] Wrote {out_html}")
