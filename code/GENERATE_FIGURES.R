# R Script for Creating Figures from Phenotype Data and Bifactor Model Scores
# Manuscript: Modeling shared and specific variances of irritability, inattention, and hyperactivity yields novel insights into white matter perturbations 

# Author: Cameron C. McKay
# Date: 2023

# Table of Contents:
# - Install and load required packages
# - Load in and merge data
# - Figure 2: Validation of latent factors using independent symptom measures
# - Figure 3: Validation of latent factors using item-level correlations with independent symptom measures
# - Figure S10: Latent factor associations with impairment
# - Figure S11: Diagnostic group differences in latent factors
# - Figure S12: Latent factor associations with age
# - Figure S13: Sex differences in latent factors

#########################################################
### Install and load required packages
#########################################################
if (!require("tidyverse")) {
  install.packages("tidyverse", dependencies = TRUE)
  library(tidyverse)
}
if (!require("ggpubr")) {
  install.packages("ggpubr", dependencies = TRUE)
  library("ggpubr")
}
if (!require("psych")) {
  install.packages("psych", dependencies = TRUE)
  library("psych")
}
if (!require("circlize")) {
  install.packages("circlize", dependencies = TRUE)
  library("circlize")
}

#########################################################
### Load in and merge data
#########################################################

# Load and merge participants.tsv and phenotype.tsv
participants <- read.delim("participants.tsv")
phenotype <- read.delim("phenotype.tsv")

sample <- left_join(participants, phenotype, by = "participant_id")

# Load in and clean bifactor model results
bifactor_values <- read.table("BiFactor.MPlus.Pheno.Values.txt",header=F)
bifactor_values<-bifactor_values[,c(27,19,21,23,25)]
names(bifactor_values)[1:5] <- c("participant_id","Shared","Irritability","Inattention","Hyperactivity")
bifactor_values <-data.frame(bifactor_values)
bifactor_values$participant_id <- paste("sub-", as.character(bifactor_values$participant_id), sep="")

# Load and merge bifactor_values with sample and remove NAs
data <- left_join(sample, bifactor_values, by = "participant_id")
data <- data %>% dplyr::filter(!is.na(Shared))

# Get minimum and maximum latent factor values to set axis limits
min_factor = min(data$Shared, data$Irritability,
                 data$Inattention, data$Hyperactivity)
max_factor = max(data$Shared, data$Irritability,
                 data$Inattention, data$Hyperactivity)

#########################################################
### Figure 2: Validation of latent factors using independent symptom measures
#########################################################

## Latent factors with SCAR-H Impulsivity

# Remove NAs and convert variables to rank
validation_SCAR_H_impulsivity <- data %>% 
  dplyr::mutate(SCAR_H_IMPULSIVITY_MEAN = as.numeric(SCAR_H_IMPULSIVITY_MEAN)) %>%
  dplyr::filter(!is.na(SCAR_H_IMPULSIVITY_MEAN)) %>%
  dplyr::mutate(SCAR_H_IMPULSIVITY_MEAN = rank(SCAR_H_IMPULSIVITY_MEAN),
                Shared = rank(Shared),
                Irritability = rank(Irritability),
                Inattention = rank(Inattention),
                Hyperactivity = rank(Hyperactivity))

# Get number of participants to set axis limits
participants_SCAR_H_impulsivity <- length(validation_SCAR_H_impulsivity$SCAR_H_IMPULSIVITY_MEAN)

# Shared factor
ggscatter(validation_SCAR_H_impulsivity, x = "SCAR_H_IMPULSIVITY_MEAN", y = "Shared",
          xlab = "SCAR-H Impulsivity", ylab = "Shared Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#172CFB"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_impulsivity), 
                                  ylim = c(0, participants_SCAR_H_impulsivity)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Irritability-specific factor
ggscatter(validation_SCAR_H_impulsivity, x = "SCAR_H_IMPULSIVITY_MEAN", y = "Irritability",
          xlab = "SCAR-H Impulsivity", ylab = "Irritability-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#9C179E"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_impulsivity), 
                                  ylim = c(0, participants_SCAR_H_impulsivity)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Inattention-specific factor
ggscatter(validation_SCAR_H_impulsivity, x = "SCAR_H_IMPULSIVITY_MEAN", y = "Inattention",
          xlab = "SCAR-H Impulsivity", ylab = "Inattention-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#DD513A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_impulsivity), 
                                  ylim = c(0, participants_SCAR_H_impulsivity)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Hyperactivity-specific factor
ggscatter(validation_SCAR_H_impulsivity, x = "SCAR_H_IMPULSIVITY_MEAN", y = "Hyperactivity",
          xlab = "SCAR-H Impulsivity", ylab = "Hyperactivity-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#FCA50A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_impulsivity), 
                                  ylim = c(0, participants_SCAR_H_impulsivity)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

## Latent factors with SCAR-H Irritability

# Remove NAs and convert variables to rank
validation_SCAR_H_irritability <- data %>% 
  dplyr::mutate(SCAR_H_IRRITABILITY_MEAN = as.numeric(SCAR_H_IRRITABILITY_MEAN)) %>%
  dplyr::filter(!is.na(SCAR_H_IRRITABILITY_MEAN)) %>%
  dplyr::mutate(SCAR_H_IRRITABILITY_MEAN = rank(SCAR_H_IRRITABILITY_MEAN),
                Shared = rank(Shared),
                Irritability = rank(Irritability),
                Inattention = rank(Inattention),
                Hyperactivity = rank(Hyperactivity))

# Get number of participants to set axis limits
participants_SCAR_H_irritability <- length(validation_SCAR_H_irritability$SCAR_H_IRRITABILITY_MEAN)

# Shared factor
ggscatter(validation_SCAR_H_irritability, x = "SCAR_H_IRRITABILITY_MEAN", y = "Shared",
          xlab = "SCAR-H Irritability", ylab = "Shared Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#172CFB"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_irritability), 
                                  ylim = c(0, participants_SCAR_H_irritability)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Irritability-specific factor
ggscatter(validation_SCAR_H_irritability, x = "SCAR_H_IRRITABILITY_MEAN", y = "Irritability",
          xlab = "SCAR-H Irritability", ylab = "Irritability-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#9C179E"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_irritability), 
                                  ylim = c(0, participants_SCAR_H_irritability)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Inattention-specific factor
ggscatter(validation_SCAR_H_irritability, x = "SCAR_H_IRRITABILITY_MEAN", y = "Inattention",
          xlab = "SCAR-H Irritability", ylab = "Inattention-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#DD513A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_irritability), 
                                  ylim = c(0, participants_SCAR_H_irritability)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Hyperactivity-specific factor
ggscatter(validation_SCAR_H_irritability, x = "SCAR_H_IRRITABILITY_MEAN", y = "Hyperactivity",
          xlab = "SCAR-H Irritability", ylab = "Hyperactivity-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#FCA50A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_SCAR_H_irritability), 
                                  ylim = c(0, participants_SCAR_H_irritability)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

## Latent factors with KSADS Inattention

# Remove NAs and convert variables to rank
validation_KSADS_inatt <- data %>% 
  dplyr::mutate(KSADS_INATTENTION = as.numeric(KSADS_INATTENTION)) %>%
  dplyr::filter(!is.na(KSADS_INATTENTION)) %>%
  dplyr::mutate(KSADS_INATTENTION = rank(KSADS_INATTENTION),
                Shared = rank(Shared),
                Irritability = rank(Irritability),
                Inattention = rank(Inattention),
                Hyperactivity = rank(Hyperactivity))

# Get number of participants to set axis limits
participants_KSADS_inatt <- length(validation_KSADS_inatt$KSADS_INATTENTION)

# Shared factor
ggscatter(validation_KSADS_inatt, x = "KSADS_INATTENTION", y = "Shared",
          xlab = "KSADS Inattention", ylab = "Shared Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#172CFB"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_inatt), 
                                  ylim = c(0, participants_KSADS_inatt)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Irritability-specific factor
ggscatter(validation_KSADS_inatt, x = "KSADS_INATTENTION", y = "Irritability",
          xlab = "KSADS Inattention", ylab = "Irritability-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#9C179E"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_inatt), 
                                  ylim = c(0, participants_KSADS_inatt)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Inattention-specific factor
ggscatter(validation_KSADS_inatt, x = "KSADS_INATTENTION", y = "Inattention",
          xlab = "KSADS Inattention", ylab = "Inattention-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#DD513A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_inatt), 
                                  ylim = c(0, participants_KSADS_inatt)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Hyperactivity-specific factor
ggscatter(validation_KSADS_inatt, x = "KSADS_INATTENTION", y = "Hyperactivity",
          xlab = "KSADS Inattention", ylab = "Hyperactivity-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#FCA50A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_inatt), 
                                  ylim = c(0, participants_KSADS_inatt)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

## Latent factors with KSADS Hyperactivity

# Remove NAs and convert variables to rank
validation_KSADS_hyper <- data %>% 
  dplyr::mutate(KSADS_HYPERACTIVITY = as.numeric(KSADS_HYPERACTIVITY)) %>%
  dplyr::filter(!is.na(KSADS_HYPERACTIVITY)) %>%
  dplyr::mutate(KSADS_HYPERACTIVITY = rank(KSADS_HYPERACTIVITY),
                Shared = rank(Shared),
                Irritability = rank(Irritability),
                Inattention = rank(Inattention),
                Hyperactivity = rank(Hyperactivity))

# Get number of participants to set axis limits
participants_KSADS_hyper <- length(validation_KSADS_hyper$KSADS_HYPERACTIVITY)

# Shared factor
ggscatter(validation_KSADS_hyper, x = "KSADS_HYPERACTIVITY", y = "Shared",
          xlab = "KSADS Hyperactivity", ylab = "Shared Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#172CFB"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_hyper), 
                                  ylim = c(0, participants_KSADS_hyper)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Irritability-specific factor
ggscatter(validation_KSADS_hyper, x = "KSADS_HYPERACTIVITY", y = "Irritability",
          xlab = "KSADS Hyperactivity", ylab = "Irritability-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#9C179E"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_hyper), 
                                  ylim = c(0, participants_KSADS_hyper)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Inattention-specific factor
ggscatter(validation_KSADS_hyper, x = "KSADS_HYPERACTIVITY", y = "Inattention",
          xlab = "KSADS Hyperactivity", ylab = "Inattention-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#DD513A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_hyper), 
                                  ylim = c(0, participants_KSADS_hyper)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Hyperactivity-specific factor
ggscatter(validation_KSADS_hyper, x = "KSADS_HYPERACTIVITY", y = "Hyperactivity",
          xlab = "KSADS Hyperactivity", ylab = "Hyperactivity-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#FCA50A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_KSADS_hyper), 
                                  ylim = c(0, participants_KSADS_hyper)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

#########################################################
### Figure 3: Validation of latent factors using item-level 
### correlations with independent symptom measures
#########################################################

## Create data frames containing correlation values with latent factors

# SCAR-H Impulsivity
validation_SCAR_imp_items <- data %>%
  dplyr::select(SCAR_H_IMPULSIVITY_MEAN, Shared, Irritability, Inattention, 
                Hyperactivity, SCAR_H.23_TROUBLE_WAIT, SCAR_H.24_CONTROL_IMPULSE, 
                SCAR_H.25_SAY_MIND, SCAR_H.26_NOT_PLAN, SCAR_H.27_SPUR_MOMENT, 
                SCAR_H.28_TROUBLE_MAKE_MIND, SCAR_H.29_GIVE_UP_EASY, 
                SCAR_H.30_UNABLE_SEE_THROUGH) 

validation_SCAR_imp_items <- lapply(validation_SCAR_imp_items, as.numeric)

SCAR_imp_corrs <- corr.test(data.frame(validation_SCAR_imp_items), method = "spearman")
SCAR_imp_corrs_r <-SCAR_imp_corrs$r[c(19:26,32:39,45:52,58:65)]
SCAR_imp_corrs_p <-SCAR_imp_corrs$p[c(19:26,32:39,45:52,58:65)]
SCAR_imp_corrs.df <- data_frame(r = SCAR_imp_corrs_r,
                                p = SCAR_imp_corrs_p,
                                factor = rep(c("Shared", "Irritability", "Inattention", "Hyperactivity"), each = 8),
                                question = rep(c("SCAR_H_TROUBLE_WAIT", "SCAR_H_CONTROL_IMPULSE", "SCAR_H_SAY_MIND", "SCAR_H_NOT_PLAN",
                                                 "SCAR_H_SPUR_MOMENT", "SCAR_H_TROUBLE_MAKE_MIND", "SCAR_H_GIVE_UP_EASY", "SCAR_H_UNABLE_SEE_THROUGH"), times=4))

SCAR_imp_corrs.df$r <- signif(SCAR_imp_corrs.df$r, digits = 2)
SCAR_imp_corrs.df$factor <- factor(SCAR_imp_corrs.df$factor, 
                                   levels = c("Shared", "Irritability", 
                                              "Inattention", "Hyperactivity"))

# SCAR-H irritability
validation_SCAR_irrit_items <- data %>%
  dplyr::select(SCAR_H_IRRITABILITY_MEAN, Shared, Irritability, Inattention, 
                Hyperactivity, SCAR_H.11_BUG, SCAR_H.12_GROUCHY, SCAR_H.13_RUDE, 
                SCAR_H.14_ANNOYED)

validation_SCAR_irrit_items <- lapply(validation_SCAR_irrit_items, as.numeric)

SCAR_irrit_corrs <- corr.test(data.frame(validation_SCAR_irrit_items), method = "spearman")
SCAR_irrit_corrs_r <-SCAR_irrit_corrs$r[c(15:18,24:27,33:36,42:45)]
SCAR_irrit_corrs_p <-SCAR_irrit_corrs$p[c(15:18,24:27,33:36,42:45)]
SCAR_irrit_corrs.df <- data_frame(r = SCAR_irrit_corrs_r,
                                  p = SCAR_irrit_corrs_p,
                                  factor = rep(c("Shared", "Irritability", "Inattention", "Hyperactivity"), each = 4),
                                  question = rep(c("SCAR_H_BUG", "SCAR_H_GROUCHY", "SCAR_H_RUDE", "SCAR_H_ANNOYED"), times=4))

SCAR_irrit_corrs.df$r <- signif(SCAR_irrit_corrs.df$r, digits = 2)
SCAR_irrit_corrs.df$factor <- factor(SCAR_irrit_corrs.df$factor, 
                                     levels = c("Shared", "Irritability", 
                                                "Inattention", "Hyperactivity"))

# ARI-Parent
validation_ARI_p_items <- data %>%
  dplyr::select(ARI_P_TOTAL, Shared, Irritability, Inattention, Hyperactivity,
                ARI_P1_ANNOYED, ARI_P2_LOSE_TEMPER_OFTEN, ARI_P3_STAY_ANGRY,
                ARI_P4_ANGRY_MOST, ARI_P5_FREQ_ANGRY, ARI_P6_LOSE_TEMPER_EASY) 

validation_ARI_p_items <- lapply(validation_ARI_p_items, as.numeric)

ARI_p_corrs <- corr.test(data.frame(validation_ARI_p_items), method = "spearman")
ARI_p_corrs_r <-ARI_p_corrs$r[c(17:22,28:33,39:44,50:55)]
ARI_p_corrs_p <-ARI_p_corrs$p[c(17:22,28:33,39:44,50:55)]
ARI_p_corrs.df <- data_frame(r = ARI_p_corrs_r,
                             p = ARI_p_corrs_p,
                             factor = rep(c("Shared", "Irritability", "Inattention", "Hyperactivity"), each = 6),
                             question = rep(c("ARI.P1.Annoyed", "ARI.P2.LoseTemperOften", "ARI.P3.StayAngry",
                                              "ARI.P4.AngryMost", "ARI.P5.FreqAngry", "ARI.P6.LoseTemperEasy"), times=4))

ARI_p_corrs.df$r <- signif(ARI_p_corrs.df$r, digits = 2)
ARI_p_corrs.df$factor <- factor(ARI_p_corrs.df$factor, 
                                levels = c("Shared", "Irritability", 
                                           "Inattention", "Hyperactivity"))

# KSADS Inattention
validation_inatt_items <- data %>%
  dplyr::select(KSADS_INATTENTION, Shared, Irritability, Inattention, Hyperactivity,
                KSADS_SUSTAIN_ATTNTN, KSADS_DISTRACT_EASY, KSADS_CARELESS_MISTAKES,
                KSADS_DONT_LISTEN, KSADS_DIFF_FOL_DIRECTION, KSADS_DIFF_ORG_TASK, 
                KSADS_DISLIKE_ATTN_TASK, KSADS_LOSE_THINGS, KSADS_DAILY_FORGET) 

validation_inatt_items <- lapply(validation_inatt_items, as.numeric)

inatt_corrs <- corr.test(data.frame(validation_inatt_items), method = "spearman")
inatt_corrs_r <-inatt_corrs$r[c(20:28,34:42,48:56,62:70)]
inatt_corrs_p <-inatt_corrs$p[c(20:28,34:42,48:56,62:70)]
inatt_corrs.df <- data_frame(r = inatt_corrs_r,
                             p = inatt_corrs_p,
                             factor = rep(c("Shared", "Irritability", "Inattention", "Hyperactivity"), each = 9),
                             question = rep(c("SUSTAIN_ATTNTN", "DISTRACT_EASY", "CARELESS_MISTAKES",
                                              "DONT_LISTEN", "DIFF_FOL_DIRECTION", "DIFF_ORG_TASK",
                                              "DISLIKE_ATTN_TASK", "LOSE_THINGS", "DAILY_FORGET"), times=4))

inatt_corrs.df$r <- signif(inatt_corrs.df$r, digits = 2)
inatt_corrs.df$factor <- factor(inatt_corrs.df$factor, 
                                levels = c("Shared", "Irritability", 
                                           "Inattention", "Hyperactivity"))

# KSADS Hyperactivity
validation_hyper_items <- data %>%
  dplyr::select(KSADS_HYPERACTIVITY, Shared, Irritability, Inattention, Hyperactivity,
                KSADS_SEATED, KSADS_FIDGET, KSADS_RUN_EXCESSIVE, 
                KSADS_ON_THE_GO, KSADS_DIFF_QUIET_PLAY, KSADS_BLURT_OUT,
                KSADS_DIFF_WAIT_TURN, KSADS_INTERRUPT, KSADS_TALKATIVE) 

validation_hyper_items <- lapply(validation_hyper_items, as.numeric)

hyper_corrs <- corr.test(data.frame(validation_hyper_items), method = "spearman")
hyper_corrs_r <- hyper_corrs$r[c(20:28,34:42,48:56,62:70)]
hyper_corrs_p <- hyper_corrs$p[c(20:28,34:42,48:56,62:70)]
hyper_corrs.df <- data_frame(r = hyper_corrs_r,
                             p = hyper_corrs_p,
                             factor = rep(c("Shared", "Irritability", "Inattention", "Hyperactivity"), each = 9),
                             question = rep(c("SEATED", "FIDGET", "RUN_EXCESSIVE",
                                              "ON_THE_GO", "DIFF_QUIET_PLAY", "BLURT_OUT",
                                              "DIFF_WAIT_TURN", "INTERRUPT", "TALKATIVE"), times=4))

hyper_corrs.df$r <- signif(hyper_corrs.df$r, digits = 2)
hyper_corrs.df$factor <- factor(hyper_corrs.df$factor, 
                                levels = c("Shared", "Irritability", 
                                           "Inattention", "Hyperactivity"))

## Combine all measures into one data frame
corrs_combined <- rbind(SCAR_imp_corrs.df, SCAR_irrit_corrs.df,
                        ARI_p_corrs.df, inatt_corrs.df, hyper_corrs.df)

# Set levels
corrs_combined$question <- as.factor(corrs_combined$question)

q_levels = c("SCAR_H_CONTROL_IMPULSE", "SCAR_H_GIVE_UP_EASY", "SCAR_H_NOT_PLAN",
             "SCAR_H_SAY_MIND", "SCAR_H_SPUR_MOMENT", "SCAR_H_TROUBLE_MAKE_MIND",
             "SCAR_H_TROUBLE_WAIT", "SCAR_H_UNABLE_SEE_THROUGH", "SCAR_H_BUG",
             "SCAR_H_GROUCHY", "SCAR_H_RUDE", "SCAR_H_ANNOYED",
             "ARI.P1.Annoyed", "ARI.P2.LoseTemperOften", "ARI.P3.StayAngry",
             "ARI.P4.AngryMost", "ARI.P5.FreqAngry", "ARI.P6.LoseTemperEasy",
             "SUSTAIN_ATTNTN", "DISTRACT_EASY", "CARELESS_MISTAKES",
             "DONT_LISTEN", "DIFF_FOL_DIRECTION", "DIFF_ORG_TASK",
             "DISLIKE_ATTN_TASK", "LOSE_THINGS", "DAILY_FORGET",
             "SEATED", "FIDGET", "RUN_EXCESSIVE",
             "ON_THE_GO", "DIFF_QUIET_PLAY", "BLURT_OUT",
             "DIFF_WAIT_TURN", "INTERRUPT", "TALKATIVE")

corrs_combined$question <- factor(corrs_combined$question, levels = q_levels)

corrs_combined <- with(corrs_combined, corrs_combined[order(question),])


corrs_combined$question_label <- rep(c("Imp_1", "Imp_2", "Imp_3", "Imp_4", "Imp_5", "Imp_6", "Imp_7", "Imp_8",
                                       "Irrit_1", "Irrit_2", "Irrit_3", "Irrit_4",
                                       "Irrit_p_1", "Irrit_p_2", "Irrit_p_3", "Irrit_p_4", "Irrit_p_5", "Irrit_p_6",
                                       "Inatt_1", "Inatt_2", "Inatt_3", "Inatt_4", "Inatt_5", "Inatt_6", "Inatt_7", "Inatt_8", "Inatt_9",
                                       "Hyper_1", "Hyper_2", "Hyper_3", "Hyper_4", "Hyper_5", "Hyper_6", "Hyper_7", "Hyper_8", "Hyper_9"), each = 4)

corrs_combined$question_label <- factor(corrs_combined$question_label,
                                        levels = c("Imp_1", "Imp_2", "Imp_3", "Imp_4", "Imp_5", "Imp_6", "Imp_7", "Imp_8",
                                                   "Irrit_1", "Irrit_2", "Irrit_3", "Irrit_4",
                                                   "Irrit_p_1", "Irrit_p_2", "Irrit_p_3", "Irrit_p_4", "Irrit_p_5", "Irrit_p_6",
                                                   "Inatt_1", "Inatt_2", "Inatt_3", "Inatt_4", "Inatt_5", "Inatt_6", "Inatt_7", "Inatt_8", "Inatt_9",
                                                   "Hyper_1", "Hyper_2", "Hyper_3", "Hyper_4", "Hyper_5", "Hyper_6", "Hyper_7", "Hyper_8", "Hyper_9"))

corrs_combined <- with(corrs_combined, corrs_combined[order(question_label),])

# Convert dataframe to wide
corrs_combined_wide <- corrs_combined %>%
  dplyr::select(r, factor, question_label) %>%
  spread(factor, r) %>%
  dplyr::mutate(index = 1)

## Create ring of polar plots

# Set up color palette
factor_palette = c("#172CFB", "#9C179E", "#DD513A", "#FCA50A")

# Set parameters for each of the concentric plots
circos.par(cell.padding = c(0.02, 0, 0.02, 0),
           gap.after = rep(1, nrow(corrs_combined_wide)),
           #gap.after = c(rep(1, nrow(corrs_combined_wide)-1), 20),
           start.degree = 90,
           track.height = 0.2)

# Initialize circular layout
# At each level of the factor (in this case question_label) plot at index (x=1 for all questions)
circos.initialize(factors = corrs_combined_wide$question_label, 
                  x = corrs_combined_wide$index, 
                  xlim = c(0,2))


# Create "track" plotting region and add lines for with y values for Shared
circos.trackPlotRegion(factors = corrs_combined_wide$question_label, 
                       y = corrs_combined_wide$Shared, 
                       ylim = c(-0.3, 0.9),
                       bg.border = NA,
                       panel.fun = function(x, y) {
                         
                         name = get.cell.meta.data("sector.index")
                         i = get.cell.meta.data("sector.numeric.index")
                         xlim = get.cell.meta.data("xlim")
                         
                         #text direction (dd) and adjusmtents (aa)
                         theta = circlize(mean(xlim), 1.3)[1, 1] %% 360
                         dd <- ifelse(theta < 90 || theta > 270, "clockwise", "reverse.clockwise")
                         aa = c(1, 0.5)
                         if(theta < 90 || theta > 270)  aa = c(0, 0.5)
                         
                         #plot labels
                         circos.text(x=mean(xlim), y=1.2, labels=name, facing = dd, cex=0.6,  adj = aa)
                         
                         #plot main sector
                         circos.axis(labels=FALSE, major.tick=FALSE)
                         circos.yaxis(side = "left", at = seq(-0.3, 0.9, by = 0.3),
                                      sector.index = get.all.sector.index()[1], labels.cex = 0.4, labels.niceFacing = TRUE)
                         
                       })

# Add plots for first track (Shared factor)
circos.trackLines(factors = corrs_combined_wide$question_label, 
                  x = corrs_combined_wide$index, 
                  y = corrs_combined_wide$Shared, 
                  col = factor_palette[1],
                  type="h",
                  baseline = 0,
                  lwd = 6)


# Create "track" plotting region and add lines for with y values for Irritability
circos.trackPlotRegion(factors = corrs_combined_wide$question_label, 
                       y = corrs_combined_wide$Irritability, 
                       ylim = c(-0.3, 0.9),
                       bg.border = NA,
                       panel.fun = function(x, y) {
                         
                         circos.axis(labels=FALSE, major.tick=FALSE)
                         circos.yaxis(side = "left", at = seq(-0.3, 0.9, by = 0.3),
                                      sector.index = get.all.sector.index()[1], labels.cex = 0.4, labels.niceFacing = TRUE)
                         
                       })

# Add plots for second track (Irritability-specific factor)
circos.trackLines(factors = corrs_combined_wide$question_label, 
                  x = corrs_combined_wide$index, 
                  y = corrs_combined_wide$Irritability, 
                  pch=20, 
                  cex=2, 
                  col = factor_palette[2],
                  type="h", 
                  baseline = 0,
                  lwd = 6)

# Create "track" plotting region and add lines for with y values for Inattention
circos.trackPlotRegion(factors = corrs_combined_wide$question_label, 
                       y = corrs_combined_wide$Inattention, 
                       ylim = c(-0.3, 0.9),
                       bg.border = NA,
                       panel.fun = function(x, y) {
                         
                         circos.axis(labels=FALSE, major.tick=FALSE)
                         circos.yaxis(side = "left", at = seq(-0.3, 0.9, by = 0.3),
                                      sector.index = get.all.sector.index()[1], labels.cex = 0.4, labels.niceFacing = TRUE)
                         
                       })

# Add plots for third track (Inattention-specific factor)
circos.trackLines(factors = corrs_combined_wide$question_label, 
                  x = corrs_combined_wide$index, 
                  y = corrs_combined_wide$Inattention, 
                  pch=20, 
                  cex=2, 
                  col = factor_palette[3],
                  type="h", 
                  baseline = 0,
                  lwd = 5)

# Create "track" plotting region and add lines for with y values for Hyperactivity
circos.trackPlotRegion(factors = corrs_combined_wide$question_label, 
                       y = corrs_combined_wide$Hyperactivity, 
                       ylim = c(-0.3, 0.9),
                       bg.border = NA,
                       panel.fun = function(x, y) {
                         
                         circos.axis(labels=FALSE, major.tick=FALSE)
                         circos.yaxis(side = "left", at = seq(-0.3, 0.9, by = 0.3),
                                      sector.index = get.all.sector.index()[1], labels.cex = 0.4, labels.niceFacing = TRUE)
                         
                       })

# Add plots for fourth track (Hyperactivity-specific factor)
circos.trackLines(factors = corrs_combined_wide$question_label,
                  x = corrs_combined_wide$index,
                  y = corrs_combined_wide$Hyperactivity,
                  pch=20, 
                  cex=2, 
                  col = factor_palette[4],
                  type="h", 
                  baseline = 0,
                  lwd = 4)

# Reset circular layout parameters (if re-running above code)
circos.clear()

#########################################################
### Figure S10: Latent factor associations with impairment
#########################################################

# Invert CGAS score as measure of impairment
data$inverted_CGAS <- 100 - as.numeric(data$CGAS_CURRENT_SCORE)

# Remove NAs and convert variables to rank
validation_CGAS_plotting <- data %>% 
  dplyr::filter(!is.na(inverted_CGAS)) %>%
  dplyr::mutate(inverted_CGAS = rank(inverted_CGAS),
                Shared = rank(Shared),
                Irritability = rank(Irritability),
                Inattention = rank(Inattention),
                Hyperactivity = rank(Hyperactivity))

# Get number of participants to set axis limits
participants_CGAS = length(validation_CGAS_plotting$inverted_CGAS)

# Shared factor
ggscatter(validation_CGAS_plotting, x = "Shared", y = "inverted_CGAS",
          xlab = "Shared Factor", ylab = "Inverted CGAS Impairment", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#172CFB"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_CGAS), 
                                  ylim = c(0, participants_CGAS)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Irritability-specific factor
ggscatter(validation_CGAS_plotting, x = "Irritability", y = "inverted_CGAS",
          xlab = "Irritability-specific Factor", ylab = "", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#9C179E"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_CGAS), 
                                  ylim = c(0, participants_CGAS)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Inattention-specific factor
ggscatter(validation_CGAS_plotting, x = "Inattention", y = "inverted_CGAS",
          xlab = "Inattention-specific Factor", ylab = "", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#DD513A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_CGAS), 
                                  ylim = c(0, participants_CGAS)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Hyperactivity-specific factor
ggscatter(validation_CGAS_plotting, x = "Hyperactivity", y = "inverted_CGAS",
          xlab = "Hyperactivity-specific Factor", ylab = "", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#FCA50A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_CGAS), 
                                  ylim = c(0, participants_CGAS)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")


#########################################################
### Figure S11: Diagnostic group differences in latent factors
#########################################################

# Recode diagnostic groups
validation_DX_plotting <- data

# Recode DMDD+ADHD
validation_DX_plotting$DMDD.ADHD[validation_DX_plotting$DX.ADHD == 1 & 
                                   validation_DX_plotting$DX.DMDD == 1] <- 1
validation_DX_plotting$DMDD.ADHD[is.na(validation_DX_plotting$DMDD.ADHD)] <- -1

# Recode DMDD-only
validation_DX_plotting$DMDD.noADHD[validation_DX_plotting$DX.ADHD == -1 & 
                                     validation_DX_plotting$DX.DMDD == 1] <- 1
validation_DX_plotting$DMDD.noADHD[is.na(validation_DX_plotting$DMDD.noADHD)] <- -1

# Recode ADHD-only
validation_DX_plotting$ADHD.noDMDD[validation_DX_plotting$DX.ADHD == 1 & 
                                     validation_DX_plotting$DX.DMDD == -1] <- 1
validation_DX_plotting$ADHD.noDMDD[is.na(validation_DX_plotting$ADHD.noDMDD)] <- -1

# Create DX column
validation_DX_plotting$DX[validation_DX_plotting$DX.HV == 1] <- "HV"
validation_DX_plotting$DX[validation_DX_plotting$ADHD.noDMDD == 1] <- "ADHD"
validation_DX_plotting$DX[validation_DX_plotting$DMDD.noADHD == 1] <- "DMDD"
validation_DX_plotting$DX[validation_DX_plotting$DMDD.ADHD == 1] <- "DMDD+ADHD"
validation_DX_plotting$DX[validation_DX_plotting$ADHD == -1 & 
                            validation_DX_plotting$ANX == 1 & 
                            validation_DX_plotting$subDMDD == 1] <- "DMDD"

validation_DX_plotting$DX <- factor(validation_DX_plotting$DX, 
                                    levels = c("HV", "ADHD", "DMDD", "DMDD+ADHD"))

# Shared factor
ggviolin(validation_DX_plotting, x = "DX", y = "Shared", 
         fill = "DX", palette = c("#172CFB", "#172CFB", "#172CFB", "#172CFB"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c("HV", "ADHD", "DMDD", "DMDD+ADHD"),
         ylab = "Shared Factor", xlab = "Group", trim = TRUE, ggtheme = theme_pubr()) +
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

# Irritability-specific factor
ggviolin(validation_DX_plotting, x = "DX", y = "Irritability", 
         fill = "DX", palette = c("#9C179E", "#9C179E", "#9C179E", "#9C179E"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c("HV", "ADHD", "DMDD", "DMDD+ADHD"),
         ylab = "Irritability-specific Factor", xlab = "Group", trim = TRUE, ggtheme = theme_pubr()) +
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

# Inattention-specific factor
ggviolin(validation_DX_plotting, x = "DX", y = "Inattention", 
         fill = "DX", palette = c("#DD513A", "#DD513A", "#DD513A", "#DD513A"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c("HV", "ADHD", "DMDD", "DMDD+ADHD"),
         ylab = "Inattention-specific Factor", xlab = "Group", trim = TRUE, ggtheme = theme_pubr())+
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

# Hyperactivity-specific factor
ggviolin(validation_DX_plotting, x = "DX", y = "Hyperactivity", 
         fill = "DX", palette = c("#FCA50A", "#FCA50A", "#FCA50A", "#FCA50A"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c("HV", "ADHD", "DMDD", "DMDD+ADHD"),
         ylab = "Hyperactivity-specific Factor", xlab = "Group", trim = TRUE, ggtheme = theme_pubr())+
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

#########################################################
### Figure S12: Latent factor associations with age
#########################################################

# Convert variables to rank
validation_age_plotting <- data %>% 
  dplyr::mutate(age = rank(age),
                Shared = rank(Shared),
                Irritability = rank(Irritability),
                Inattention = rank(Inattention),
                Hyperactivity = rank(Hyperactivity))

# Get number of participants to set axis limits
participants_age = length(validation_age_plotting$age)

# Shared factor
ggscatter(validation_age_plotting, x = "age", y = "Shared",
          xlab = "Age (years)", ylab = "Shared Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#172CFB"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_age), 
                                  ylim = c(0, participants_age)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Irritability-specific factor
ggscatter(validation_age_plotting, x = "age", y = "Irritability",
          xlab = "Age (years)", ylab = "Irritability-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#9C179E"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_age), 
                                  ylim = c(0, participants_age)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Inattention-specific factor
ggscatter(validation_age_plotting, x = "age", y = "Inattention",
          xlab = "Age (years)", ylab = "Inattention-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#DD513A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_age), 
                                  ylim = c(0, participants_age)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")

# Hyperactivity-specific factor
ggscatter(validation_age_plotting, x = "age", y = "Hyperactivity", 
          xlab = "Age (years)", ylab = "Hyperactivity-specific Factor", color = "white", 
          add = "reg.line", add.params = list(color = "black", fill = "#FCA50A"), 
          conf.int = TRUE, ggtheme = theme_pubr()) +
  coord_fixed() + coord_cartesian(xlim = c(0, participants_age), 
                                  ylim = c(0, participants_age)) +
  theme(text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold")


#########################################################
### Figure S13: Sex differences in latent factors
#########################################################

# Shared factor
ggviolin(data, x = "sex", y = "Shared", 
         fill = "sex", palette = c("#172CFB", "#172CFB"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c(1, -1),
         ylab = "Shared Factor", xlab = "Sex", trim = TRUE, ggtheme = theme_pubr()) +
  scale_x_discrete(labels=c("1" = "Males", "-1" = "Females")) +
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

# Irritability-specific factor
ggviolin(data, x = "sex", y = "Irritability", 
         fill = "sex", palette = c("#9C179E", "#9C179E"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c(1, -1),
         ylab = "Irritability-specific Factor", xlab = "Sex", trim = TRUE, ggtheme = theme_pubr()) +
  scale_x_discrete(labels=c("1" = "Males", "-1" = "Females")) +
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

# Inattention-specific factor
ggviolin(data, x = "sex", y = "Inattention", 
         fill = "sex", palette = c("#DD513A", "#DD513A"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c(1, -1),
         ylab = "Inattention-specific Factor", xlab = "Sex", trim = TRUE, ggtheme = theme_pubr()) +
  scale_x_discrete(labels=c("1" = "Males", "-1" = "Females")) +
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

# Hyperactivity-specific factor
ggviolin(data, x = "sex", y = "Hyperactivity", 
         fill = "sex", palette = c("#FCA50A", "#FCA50A"),
         add = "boxplot", add.params = list(fill = "white"),
         order = c(1, -1),
         ylab = "Hyperactivity-specific Factor", xlab = "Sex", trim = TRUE, ggtheme = theme_pubr()) +
  scale_x_discrete(labels=c("1" = "Males", "-1" = "Females")) +
  coord_cartesian(ylim = c(min_factor, max_factor)) +
  theme(legend.position = "none", text = element_text(size = 22)) +
  font("ylab", size = 22, face = "bold") + font("xlab", size = 22, face = "bold") 

