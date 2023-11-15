%% DTI Analysis using PALM

% This MATLAB script performs analysis on DTI (Diffusion Tensor Imaging) data using PALM (Permutation Analysis of Linear Models), a tool for permutation-based statistical analysis. The commands below are used to analyze the microstructure of the white matter skeleton.

%% Setup: Add PALM to MATLAB path
addpath('/path/to/PALM')

%% Latent factors from bifactor model

% Latent factors from bifactor model with fractional anisotropy (FA); controlling for age and mean FA

palm -i all_FA_skeletonised.nii ... % output from TBSS
    -m mean_FA_skeleton_mask.nii ... % mask of FA skeleton
    -d design_shared_age_meanFA_N152.csv ... % three columns corresponding to shared factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_hyper_age_meanFA_N152.csv ... % three columns corresponding to hyperactivity-specific factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_inatt_age_meanFA_N152.csv ... % three columns corresponding to inattention-specific factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_irrit_age_meanFA_N152.csv ... % three columns corresponding to irritability-specific factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o Factors_whole_skel_negOnly_cxAge_cxFA % save outputs

% Shared factor clusters as masks with FA; controlling for age and mean FA, with either natal sex or psychotropic medication load

palm -i all_FA_skeletonised.nii ... % output from TBSS
    -m Shared_clust1.nii ... % significant cluster 1 as a mask
    -i all_FA_skeletonised.nii ... % output from TBSS
    -m Shared_clust2.nii ... % significant cluster 2 as a mask
    -i all_FA_skeletonised.nii ... % output from TBSS
    -m Shared_clust3.nii ... % significant cluster 3 as a mask
    -d design_shared_age_meanFA_sex_N152.csv ... % four columns corresponding to shared factor, age, average FA of the white matter skeleton, and natal sex
    -t contrast_negative_3covar.csv ... % contrast with four columns: -1,0,0,0
    -d design_shared_age_meanFA_med_N152.csv ... % four columns corresponding to shared factor, age, average FA of the white matter skeleton, and psychotropic medication load
    -t contrast_negative_3covar.csv ... % contrast with four columns: -1,0,0,0
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o Shared_clusters_cxAge_cxFA_moderators % save outputs

% Shared factor clusters as masks with axial diffusivity (AD); controlling for age and mean FA

palm i all_AD_skeletonised.nii ... % output from TBSS
    -m Shared_clust1.nii ... % significant cluster 1 as a mask
    -i all_AD_skeletonised.nii ... % output from TBSS
    -m Shared_clust2.nii ... % significant cluster 2 as a mask
    -i all_AD_skeletonised.nii ... % output from TBSS
    -m Shared_clust3.nii ... % significant cluster 3 as a mask
    -d design_shared_age_meanFA_N152.csv ... % three columns corresponding to shared factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o Shared_clusters_cxAge_cxFA_AD % save outputs

% Shared factor clusters as masks with radial diffusivity (RD); controlling for age and mean FA

palm i all_RD_skeletonised.nii ... % output from TBSS
    -m Shared_clust1.nii ... % significant cluster 1 as a mask
    -i all_RD_skeletonised.nii ... % output from TBSS
    -m Shared_clust2.nii ... % significant cluster 2 as a mask
    -i all_RD_skeletonised.nii ... % output from TBSS
    -m Shared_clust3.nii ... % significant cluster 3 as a mask
    -d design_shared_age_meanFA_N152.csv ... % three columns corresponding to shared factor, age, and average FA of the white matter skeleton
    -t contrast_positive_2covar.csv ... % contrast with three columns: 1,0,0
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o Shared_clusters_cxAge_cxFA_RD % save outputs


%% Latent factors from confirmatory factor analysis (CFA)

% Latent factors from CFA with FA; controlling for age and mean FA

palm -i all_FA_skeletonised.nii ... % output from TBSS
    -m mean_FA_skeleton_mask.nii ... % mask of FA skeleton
    -d design_CFA_hyper_age_meanFA_N152.csv ... % three columns corresponding to hyperactivity factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_CFA_inatt_age_meanFA_N152.csv ... % three columns corresponding to inattention factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_CFA_irrit_age_meanFA_N152.csv ... % three columns corresponding to irritability factor, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o CFA_whole_skel_negOnly_cxAge_cxFA % save outputs


%% Questionnaire scores: Affective Reactivity Index (ARI) and Conners Behavioral Rating Scale (CBRS)

% Questionnaire scores with FA; controlling for age and mean FA

palm -i all_FA_skeletonised.nii ... % output from TBSS
    -m mean_FA_skeleton_mask.nii ... % mask of FA skeleton
    -d design_ARI-P_age_meanFA_N152.csv ... % three columns corresponding to parent-ARI scores, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_ARI-Y_age_meanFA_N152.csv ... % three columns corresponding to youth-ARI scores, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_CBRS_Hyper_age_meanFA_N152.csv ... % three columns corresponding to CBRS Hyperactivity scores, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -d design_CBRS_Inatt_age_meanFA_N152.csv ... % three columns corresponding to CBRS Inattention scores, age, and average FA of the white matter skeleton
    -t contrast_negative_2covar.csv ... % contrast with three columns: -1,0,0
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o Questionnaires_whole_skel_negOnly_cxAge_cxFA % save outputs


%% Diagnostic group (DX) differences: Attention-Deficit/Hyperactivity Disorder (ADHD) and Disruptive Mood Dysregulation Disorder (DMDD) versus healthy volunteers (HV)

% DX differences in FA; controlling for age and mean FA

palm -i all_FA_skeletonised.nii ... % output from TBSS
    -m mean_FA_skeleton_mask.nii ... % mask of FA skeleton
    -d design_DX_ADHDvsHV_age_meanFA_N152.csv ... % four columns corresponding to ADHD status (1 or 0), HV status (1 or 0), age, and average FA of the white matter skeleton
    -t contrast_HVgtDX_2covar.csv ... % contrast with four columns: -1,1,0,0
    -d design_DX_DMDDvsHV_age_meanFA_N152.csv ... % four columns corresponding to DMDD status (1 or 0), HV status (1 or 0), age, and average FA of the white matter skeleton
    -t contrast_HVgtDX_2covar.csv ... % contrast with four columns: -1,1,0,0
    -eb EB_N152.csv ... % exchangeability blocks file containing four columns
    -T -tfce2D ... % enable TFCE for TBSS data
    -n 5000 ... % run 5000 permutations
    -approx tail ... % accelerated permutation inference
    -logp ... % save p-values as -log10(p)
    -demean ... % mean center data
    -cmcx -cmcp ... % ignore possibility of repeated rows and permutations
    -o DX_whole_skel_cxAge_cxFA % save outputs



