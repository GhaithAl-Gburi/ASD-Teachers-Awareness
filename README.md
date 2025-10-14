# README — Awareness of Autism Spectrum Disorder among Public Primary School Teachers in Iraq (R)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.16919253.svg)](https://doi.org/10.5281/zenodo.16919253)

**Repository author:** Ghaith Al‑Gburi

**Study DOI / citation:** Saeed MA, Jaber OA, Lami F, Jasim SM, Nayeri ND, Sabet MS, Al-Gburi G. Awareness of Autism Spectrum Disorder among Public Primary School Teachers in Iraq. BMC Psychology. 2025. DOI: 10.1186/s40359-025-03218-6.

## Quick view
Click to view the full analysis results and visualizations:
[Open rendered report — result.html](https://rawcdn.githack.com/GhaithAl-Gburi/ASD-Teachers-Awareness/main/result.html)

---

## Purpose
This repository contains `Analysis_code.R` — an R script used to analyse factors associated with public primary school teachers' awareness of autism spectrum disorder (ASD) in Iraq. The script performs non-parametric group comparisons (Mann–Whitney/Wilcoxon and Kruskal–Wallis), pairwise Dunn tests, and computes effect-size measures (Wilcoxon *r*, ε²) with bootstrap confidence intervals. The analyses reflect the variables and design reported in the published study.

> **Data privacy:** this repository does **not** include participant‑level identifiable data.

---

## Files in this repo
- `Analysis_code.R` — the main analysis script.  
- `Analysis_code.Rmd` — R Markdown source (script + narrative + plots).  
- `result.html` — rendered report (clickable summary of results & plots).  
- `input.csv` — the dataset expected by the script (see *Expected data format*).
- `data collection tool/` — a directory containing the arabic and english version of the research survey.
- `README.md` — this file.
- `LICENSE` — MIT License (reuse and citation conditions).

---

- R (>= 4.0 recommended)  
- Required packages (used in `Analysis_code.R`):  
  - `rcompanion` (ε², Wilcoxon *r*, bootstrap helpers)  
  - `ggplot2` (plots)  
  - `scales` (percent formatting)  
  - `FSA` (Dunn test)  
  - `boot` (bootstrap confidence intervals)

Install packages in R with:

```r
install.packages(c("rcompanion","ggplot2","scales","FSA","boot"))
```

`kruskal.test` and `wilcox.test` are base R functions (stats package).

---
## Expected Data Format

The script `Analysis_code.R` expects a CSV file (`input.csv`) with the following columns:

### Continuous outcome variable
- `awareness`

### Binary grouping variables (expected values: `No` / `Yes`)
- `gender_male`  
- `bachelor_or_above`  
- `social_media`  
- `colleagues`  
- `scientific_resources`  
- `workshops`  
- `personal_experience`  

### Multi-level grouping variables
- `contact` — levels used in the script:  
  - `No contact`  
  - `From school`  
  - `From family/relatives`  
  - `Both`

Notes / expectations:
- Missing rows (`NA`) are removed before each test.  
- Binary variables must be coded exactly as `No` / `Yes`.  
- Multi-level factors should follow the level ordering specified above.

---

## What the script does (high-level)
1. **Reads** the `input.csv` dataset.  
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
source("Analysis_code.R")
```

From the command line:

```bash
Rscript Analysis_code.R
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

- **Note:** `Analysis_code.R` prints objects and plots but does **not** automatically save CSVs or figure files. To save outputs, add lines such as:

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
- Key results relevant to this script include awareness levels across different contact sources (school, family/relatives, both, or none) and associations between awareness and personal factors such as gender, education level, social media exposure, colleagues, workshops, access to scientific resources, and personal experience.  

---

## License & citation
**License:** This repository is released under the **MIT License**.

**How to cite the study using this code:**  

```
Saeed MA, Jaber OA, Lami F, Jasim SM, Nayeri ND, Sabet MS, Al-Gburi G. Awareness of Autism Spectrum Disorder among Public Primary School Teachers in Iraq. BMC Psychology. 2025. DOI: 10.1186/s40359-025-03218-6.
```

**How to cite this code:**  

```
Al-Gburi G. Analysis code for: Awareness of Autism Spectrum Disorder among Public Primary School Teachers in Iraq. Zenodo. 2025. DOI: 10.5281/zenodo.16919253
```

---

## Contact
- **Author:** Ghaith Al‑Gburi
- **Email:** ghaith.ali.khaleel@gmail.com 
- **GitHub:** `https://github.com/GhaithAl-Gburi`  
- **ORCID:** `0000-0001-7427-8310` 


---
