# README — Awareness of Autism Spectrum Disorder among Public Primary School Teachers in Iraq (R)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16919253.svg)](https://doi.org/10.5281/zenodo.16919253)

**Repository author:** Ghaith Al‑Gburi

**Study DOI / citation:** Saeed MA, Jaber OA, Lami F, et al. Awareness of autism spectrum disorder among public primary school teachers in Iraq. BMC Psychol. 2025;13(1):1075. doi:`10.1186/s40359-025-03218-6`

[![Read the Study](https://img.shields.io/badge/Read%20the%20Study-blue)](https://doi.org/10.1186/s40359-025-03218-6)

## Quick view
Click to view the full analysis results and visualizations:
[Open rendered report](https://rawcdn.githack.com/GhaithAl-Gburi/ASD-Teachers-Awareness/main/analysis_report.pdf)

---

## Purpose
This repository contains `compute_effect_size.R` — an R script used to analyse factors associated with public primary school teachers' awareness of autism spectrum disorder in Iraq. The script performs non-parametric group comparisons (Mann–Whitney/Wilcoxon and Kruskal–Wallis), pairwise Dunn tests, and computes effect-size measures (Wilcoxon *r*, ε²) with bootstrap confidence intervals. 

> **Data privacy:** this repository does **not** include participant‑level identifiable data.

---

## Files in this repo
- `compute_effect_size.R` — R script.  
- `compute_effect_size.Rmd` — R Markdown source (script + narrative + plots).  
- `analysis_report.pdf` — Rendered PDF report for the complete analysis workflow.  
- `teacher_awareness_dataset.csv` — CSV file containing the data used for statistical analysis (see *Expected data format*).
- `data collection tool/` — Directory containing the arabic and english version of the research survey.
- `README.md` — This file.
- `LICENSE` — AGPL-3.0 License (reuse and citation conditions).

---

- R (>= 4.0 recommended)  
- Required packages:  
  - `rcompanion` (ε², Wilcoxon *r*, bootstrap helpers)  
  - `ggplot2` (plots)  
  - `FSA` (Dunn test)  
  - `boot` (bootstrap confidence intervals)

`kruskal.test` and `wilcox.test` are base R functions (stats package).

---
The script expects a CSV file with the following columns:

| Category                     | Variable names                                                                 |
|-----------------------------|----------------------------------------------------------------------------------|
| Continuous outcome variable | `awareness`                                                                     |
| Binary grouping variables   | `gender_male`, `bachelor_or_above`, `social_media`, `colleagues`, `scientific_resources`, `workshops`, `personal_experience` |
| Multi-level grouping variable | `contact` (No contact, From school, From family/relatives, Both)     |

Notes / expectations:
- Missing rows (`NA`) are removed before each test.  
- Binary variables must be coded exactly as `No` / `Yes`.  
- Multi-level factors should follow the level ordering specified above.

---

## What the script does (high-level)
1. **Reads** the dataset.  
2. **Binary group comparisons:**  
   - Uses Mann–Whitney tests to compare `awareness` scores across binary variables.  
   - Computes Wilcoxon *r* effect sizes with bootstrap confidence intervals.  
   - Produces jitter + median crossbar plots for each group.  
3. **Multi-level group comparisons:**  
   - Uses Kruskal–Wallis tests for multi-level variables.  
   - Computes ε² effect sizes with bootstrap confidence intervals.  
   - Produces jitter + median crossbar plots for each group.  
4. **Pairwise comparisons for multi-level groups:**  
   - Performs Dunn tests with Bonferroni adjustment.  
   - Computes effect-size *r* with bootstrap confidence intervals.  
5. **Outputs:**  
   - `results_binary` — summary of binary group comparisons  
   - `results_multi` — summary of multi-level group comparisons  
   - `results_pair` — summary of pairwise Dunn tests

---

## How to run
From R (repository root):

```r
# open an R session in the project folder:
source("compute_effect_size.R")
```

From the command line:

```bash
Rscript compute_effect_size.R
```

---

## Typical outputs produced by the script (what to expect)

- Printed data frames in the R console:
  - `results_binary` — Mann–Whitney/Wilcoxon results for binary predictors of awareness (group medians, test statistic, p-value, Wilcoxon r with bootstrap CI).  
  - `results_multi` — Kruskal–Wallis results for multi-level predictors of awareness (group medians, test statistic, p-value, ε² with bootstrap CI).  
  - `results_pair` — Pairwise Dunn test results for multi-level predictors (group pairs, test statistic, Bonferroni-adjusted p-value, effect size r with bootstrap CI).  

- Plots printed to the active graphics device:
  - Jitter + median crossbar plots for binary group comparisons.  
  - Jitter + median crossbar plots for multi-level group comparisons.  

- **Note:** `compute_effect_size.R` prints objects and plots but does **not** automatically save CSVs or figure files. To save outputs, add lines such as:

```r
write.csv(results_binary, "results_binary.csv", row.names = FALSE)
write.csv(results_multi, "results_multi.csv", row.names = FALSE)
write.csv(results_pair, "results_pair.csv", row.names = FALSE)

ggsave("awareness_by_gender.png")  # after a specific plot call
```

---

## Reproducibility & recommended tweaks
- The script sets `set.seed(123)` — keep this for reproducible bootstrap CIs.  
- If you plan to run the script unattended (e.g., on a remote server), add explicit `ggsave()` calls to persist plots, and `write.csv()` for results.  
- Consider adding `check.packages <- function(pkgs) { ... }` helper to install missing packages programmatically.

---

## Notes about the study (short)
- The study is a cross-sectional survey of participants recruited from public primary schools in Rusafa 1 Educational directory in Iraq
- Key results relevant to this script include awareness levels across different contact sources (school, family/relatives, both, or none) and associations between awareness and sociodemographic factors such as gender, education level, social media exposure, colleagues, workshops, access to scientific resources, and personal experience.  

---

## License & citation
**License:** This repository is released under the **AGPL-3.0 License**.

**How to cite this code:**  

```
Al-Gburi G (2025). Analysis code for: Awareness of Autism Spectrum Disorder among Public Primary School Teachers in Iraq. Zenodo. https://doi.org/10.5281/zenodo.16919253
```

---

## Contact
- **Author:** Ghaith Al‑Gburi
- **Email:** ghaith.ali.khaleel@gmail.com 
- **GitHub:** `https://github.com/GhaithAl-Gburi`  
- **ORCID:** `0000-0001-7427-8310` 

---
