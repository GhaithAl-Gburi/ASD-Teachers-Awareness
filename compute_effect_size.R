# Settings

## Clear working environment
rm(list = ls())

## Set a random seed
set.seed(123)

## Required packages
packages <- c("rcompanion","ggplot2","FSA","boot")

for (package in packages) {
  
  if (!requireNamespace(package, quietly = TRUE))
    install.packages(package)
  
  suppressPackageStartupMessages(library(package, character.only = TRUE))
  
}

## Import and inspect data attributes

#load data and set seed
df <- read.csv("teacher_awareness_dataset.csv")

attributes(df)[names(attributes(df)) != "row.names"]

# Teacher awareness across grouping variables

## Define Variables, result objects, and helper functions

# Store the outcome and grouping variables
y_var          <- "awareness"
binary_groups  <- c("gender_male","bachelor_or_above","social_media", "colleagues", 
                    "scientific_resources", "workshops", "personal_experience")
multi_groups   <- c("contact")

# Prepare an empty frame for Man-Whitney U test results
results_binary <- data.frame(group       = character(),
                             U_stat      = numeric(),
                             p_value     = numeric(),
                             r_value  =    numeric(),
                             CI_lower_95 = numeric(),
                             CI_upper_95 = numeric(),
                             stringsAsFactors = FALSE
                             )

# Prepare an empty data frame for Krustkal-Wallis test results
results_multi <- data.frame(group        = character(),
                            H_value      = numeric(),
                            df           = integer(),
                            p_value      = numeric(),
                            eps_sq       = numeric(),
                            CI_lower_95  = numeric(),
                            CI_upper_95  = numeric(),
                            stringsAsFactors = FALSE
                            )

# Prepare an empty data frame for Dunn's test pairwise analysis
results_pair <- data.frame(group_1     = character(),
                           group_2     = character(),
                           p_value     = numeric(),
                           p_adjusted  = numeric(),
                           r_value     = numeric(),
                           CI_lower_95 = numeric(),
                           CI_upper_95 = numeric(),
                           stringsAsFactors = FALSE
)

# Define a helper function to perform bootstrapping
boot_fn <- function(data, indices) {
  dBoot <- data[indices, ]
  
  # Recompute ranks of y within the bootstrap sample
  dBoot$rank_y <- rank(dBoot$y)
  
  dt <- dunnTest(y ~ g, data = dBoot, method = "none")$res
  row_i <- dt[dt$Comparison == comparison, ]
  if (nrow(row_i) == 0) {
    return(NA_real_)
  }
  Z_boot <- row_i$Z
  
  # Compute mean‐rank difference in this bootstrap replicate
  mean_rank_1_boot <- mean(dBoot$rank_y[dBoot$g == group_1], na.rm = TRUE)
  mean_rank_2_boot <- mean(dBoot$rank_y[dBoot$g == group_2], na.rm = TRUE)
  mean_rank_diff_boot <- mean_rank_2_boot - mean_rank_1_boot
  
  r_boot <- (abs(Z_boot) / sqrt(nrow(dBoot))) * sign(mean_rank_diff_boot)
  return(r_boot)
}

## Wilixicon R effect size for binary grouping variables

# Loop over binary grouping variables
for (g in binary_groups) {
  
  # Subset and clean the data
  sub <- df[, c(y_var, g)]
  names(sub) <- c("y","g")
  sub <- na.omit(sub)
  sub$g <- factor(sub$g, levels = c("No","Yes"))
  
  # Mann–Whitney test
  wt <- wilcox.test(y ~ g, data = sub, exact = FALSE)
  
  # R-values effect size
  set.seed(123)
  r <- -1*wilcoxonR(x          = sub$y,
                    g          = sub$g,
                    ci         = TRUE,
                    conf.level = 0.95,
                    type       = "bca",
                    R          = 10000
  )
  r[c(2, 3)] <- r[c(3, 2)]
  
  # Jitter and median crossbar plots
  p <- ggplot(sub, aes(x = g, y = y)) +
    geom_jitter(width = 0.2, alpha = 0.6) +
    stat_summary(fun = median,
                 geom = "crossbar",
                 width = 0.5,
                 color = "blue",
                 linewidth = 0.6
    ) +
    labs(title    = paste0("Scatter of ", y_var, " by ", g),
         subtitle = paste0("r = ", round(r, 3)),
         x        = g,
         y        = y_var
    ) +
    theme_minimal(base_size = 14)
  
  print(p)
  
  # Append result
  results_binary <- rbind(results_binary,
                          data.frame(group       = g,
                                     U_stat      = as.numeric(wt$statistic),
                                     p_value     = wt$p.value,
                                     r_value     = r,
                                     stringsAsFactors = FALSE
                          )
  )
}

# Print results
print(results_binary)

## Epsilon-squared effect size for multi-level grouping variables

# Subset and clean the data
sub        <- df[, c(y_var, "contact")]
names(sub) <- c("y", "g")
sub        <- na.omit(sub)
sub$y      <- as.numeric(sub$y)
sub$g      <- factor(sub$g, levels = c("No contact", "From school", 
                                       "From family/relatives", "Both"))

# Kruskal–Wallis test
kw <- kruskal.test(y ~ g, data = sub)

# Epsilon-squared effect size
set.seed(123)
eps <- epsilonSquared(x           = sub$y,
                      g           = sub$g,
                      ci          = TRUE,
                      conf.level  = 0.95,
                      type        = "bca",
                      R           = 10000
)

# Jitter and median crossbar plots
p <- ggplot(sub, aes(x = g, y = y)) +
  geom_jitter(width = 0.2, alpha = 0.6) +
  stat_summary(fun = median,
               geom = "crossbar",
               width = 0.5,
               color = "blue",
               linewidth = 0.6
  ) +
  labs(title    = paste0("Scatter of ", y_var, " by contact"),
       subtitle = paste0("epsilon-squared = ", round(eps, 3)),
       x        = "contact",
       y        = y_var
  ) +
  theme_minimal(base_size = 14)

print(p)

# Store results
results_multi <- rbind(results_multi,
                       data.frame(group   = "contact",
                                  H_value = as.numeric(kw$statistic),
                                  f      = kw$parameter,
                                  p_value = kw$p.value,
                                  eps_sq  = eps,
                                  stringsAsFactors = FALSE
                       )
)

# Print results
print(results_multi)

## Pairwise Effect Sizes (r) Following Dunn’s Test

# Subset and clean the data
sub <- na.omit(df[, c(y_var, multi_groups)])
names(sub) <- c("y", "g")
sub$g <- factor(sub$g)
N <- nrow(sub)

# Precompute overall ranks of y for the observed data
sub$rank_y <- rank(sub$y)

# Dunn’s test
dunn_result <- dunnTest(y ~ g, data = sub, method = "bonferroni")
dunn_table  <- dunn_result$res

# Loop over each pairwise comparison
for (i in seq_len(nrow(dunn_table))) {
  
  # Extract the two group names, raw p‐value, adjusted p, and Z
  comparison <- dunn_table$Comparison[i]
  groups     <- strsplit(comparison, " - ")[[1]]
  group_1    <- groups[1]
  group_2    <- groups[2]
  
  p_raw <- dunn_table$P.unadj[i]
  p_adj <- dunn_table$P.adj[i]
  Z_obs <- dunn_table$Z[i]
  
  # Mean rank difference
  mean_rank_1 <- mean(sub$rank_y[sub$g == group_1], na.rm = TRUE)
  mean_rank_2 <- mean(sub$rank_y[sub$g == group_2], na.rm = TRUE)
  mean_rank_diff <- mean_rank_2 - mean_rank_1
  
  # R-values effect size
  r_obs <- (abs(Z_obs) / sqrt(N)) * sign(mean_rank_diff)
  
  # Bootstrapping with 10,000 samples
  set.seed(123)
  boot_out <- boot(data = sub, statistic = boot_fn, R = 10000)
  
  # 95% BCa interval for R-values
  ci_obj <- tryCatch(boot.ci(boot_out, type = "bca"),
                     error = function(e) NULL
  )
  if (!is.null(ci_obj) && !is.null(ci_obj$bca)) {
    ci_lower <- ci_obj$bca[4]  # 2.5% endpoint
    ci_upper <- ci_obj$bca[5]  # 97.5% endpoint
    
  } else {
    ci_lower <- NA_real_
    ci_upper <- NA_real_
  }
  
  # Append results
  results_pair <- rbind(results_pair,
                        data.frame(group_1     = group_1,
                                   group_2     = group_2,
                                   p_value     = p_raw,
                                   p_adjusted  = p_adj,
                                   r_value     = r_obs,
                                   CI_lower_95 = ci_lower,
                                   CI_upper_95 = ci_upper,
                                   stringsAsFactors = FALSE
                        )
  )
}

# Print results
print(results_pair)
