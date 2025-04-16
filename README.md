# Emotion and Development Branch Phenotyping and DTI (2012-2017)

Analysis files and meta-data to accompany the manuscript "[Modeling shared and specific variances of irritability, inattention, and hyperactivity yields novel insights into white matter perturbations](https://doi.org/10.1016/j.jaac.2024.02.010)" published in the *Journal of the American Academy of Child and Adolescent Psychiatry*[^1].

This repository contains analysis scripts (MPlus, bash, Matlab, R) used for preprocessing and analysis of the data found in our [OpenNeuro dataset](https://openneuro.org/datasets/ds004605). Although the code used to deface the anatomical scans (T1, T2) is not included in this repository, we de-identified these images using using v1.0.0 of the [DSST Defacing Pipeline](https://github.com/nih-fmrif/dsst-defacing-pipeline/).

## Factor Analysis

These files perform exploratory factor analysis (EFA), confirmatory factor analysis (CFA), bifactor model analysis, and cross-correlations in MPlus. Scripts should be run in order from Script1 to Script4.

Note: These MPlus input files assume that missing data are coded as `999`, but the phenotype.tsv file as shared on OpenNeuro contains `n/a` to indicate missingness.

#### Script1_EFA.MPlus.Pheno.inp

Performs EFA using items from the Conners (3rd edition) Comprehensive Behavioral Rating Scale (CBRS) for parents[^2].

#### Script2_CFA.MPlus.Pheno.inp & Script2_CFA.MPlus.DTI.inp

Performs CFA using the top six highest loading CBRS items from the three-factor EFA (Script1) for the irritability, inattention, and hyperactivity factors. This is done separately for the Phenotyping and DTI subsamples.

#### Script3_BiFactor.MPlus.Pheno.inp & Script3_BiFactor.MPlus.DTI.inp

Performs bifactor model analysis using the top six highest loading CBRS items from the three-factor EFA (Script1) for the irritability, inattention, and hyperactivity factors. This is done separately for the Phenotyping and DTI subsamples.

#### Script4_BiFactor.MPlus.Pheno.CrossVal.inp & Script4_BiFactor.MPlus.DTI.CrossVal.inp

Performs cross-validation of the latent variables from the bifactor model (by applying the loadings from the Phenotyping sample to the DTI sample and vice versa) and determining the correlations between the latent factor scores. 

## DTI Preprocessing and Analysis

#### Directory Structure for DTI Preprocessing

The following scripts assume the following directory structure:

```
data
├── BIDS
│   ├── sub-[participant-id]
│       └── ses-1
│           ├── anat
│           └── dwi
├── code
├── lists
├── PROC
│   ├── sub-[participant-id]
│       └── ses-1
│           ├── anat
│           └── dwi
├── slurm
└── TBSS_Tortoise
│   ├── AD
│   ├── FA
│   ├── origdata
│   ├── PALM
│   ├── RD
│   └── stats
```

### Preprocessing Scripts

Bash scripts that perform basic DTI preprocessing using common neuroimaging tools: [Analysis of Functional NeuroImages (AFNI)](https://afni.nimh.nih.gov)[^3], [Tolerably Obsessive registration and Tensor Optimization Indolent Software Ensemble (TORTOISE)](https://tortoise.nibib.nih.gov)[^4] [^5], and [Tract-Based Spatial Statistics (TBSS) in FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TBSS)[^6]. Scripts should be run in order from 01.Preproc to 06.TBSS.Proc.nonFA.

#### 01.Preproc
Create directories in the PROC directory where all outputs will be saved. Perform T2 skull stripping (using FSL's `bet` function). Axialize T2 images (using AFNI's `fat_proc_axialize_anat`). Set origin for DWI images to 0,0,0.

#### 02a.Select.Remove.Bad.DWIs
Loop through participants with bad DWI volumes and produce a file called `dwi_sel_AP` with the volumes to keep (using the AFNI's `fat_proc_select_vols`).

Loop through participants again. Convert DWIs to create new matrices including bvals and bvecs (using AFNI's `fat_proc_convert_dcm_dwis`). Filter out bad volumes from vols and b-matrices (using AFNI's `fat_proc_filter_dwis`). Save gradients and bvalues as row matrixes (using AFNI's `1dDW_Grad_o_Mat++`). 

#### 02b.Nothing.To.Remove
Loop through participants with no bad DWI volumes and produce a file called `dwi_sel_AP`.

#### 03a.DiffPrep.Directions.Removed
Loop through participants with bad DWI volumes. Unzip T2w NifTI files. Add `DIFFPREP` to swarm file. Run swarm.

#### 03b.DiffPrep.Nothing.Removed
Loop through participants with no bad DWI volumes. Unzip T2w NifTI files. Add `DIFFPREP` to swarm file. Run swarm.

#### 04.Estimate.Tensor
Loop through participants. Extract a single volume out of a 4D DWI image based on desired bvalue (using TORTOISE's `ExtractBValVolume`). Perform skull stripping on `AP_DMC_bval_0_1.nii` (using FSL's `bet` function). Unzip `b0_brain_mask.nii.gz`. Add `EstimateTensorNLLSRESTORE` and `ComputeAllTensorMaps.bash` from TORTOISE to swarm file to perform tensor fitting. Run swarm.

#### 05.TBSS.Proc.FA

Create TBSS directory if it does not already exist; populate with fractional anisotropy (FA) maps. Run basic TBSS preprocessing scripts: `tbss_1_preproc_NA`, `tbss_2_reg`, `tbss_3_postreg`, and `tbss_4_prestats`. Create PALM directory and copy skeleton and tracts into it. Unzip necessary .nii.gz files.

#### 06.TBSS.Proc.nonFA

Create create directories for the non-FA images of every participant: axial diffusivity (AD) and radial diffusivity (RD). Create RD maps using average of `AP_DMC_R1_DT_EV0001.nii.gz` and `AP_DMC_R1_DT_EV0002.nii.gz`. Copy and organize AD and RD maps. Run `tbss_non_FA` for AD and RD maps.
        
### DTI Directions Removed

The file `DTI_Directions.xlsx` contains information about the directions removed from the DTI data, which was used during the DTI preprocessing to create the lists `Bad.DWIs.txt` and `No.Bad.DWIs.txt`. The columns in this spreadsheet are as follows:

* `participant_id`: participant identifier
* `B0 to Remove`: index of B0 images to remove
* `B300 to Remove`: index of B300 images to remove
* `B1000 to Remove`: index of B1000 images to remove

* `Extra B0`: index of extra acquired B0 images
* `Extra B300`: index of extra acquired B300 images
* `Extra B1000`: index of extra acquired B1000 images

* `N B0`: total number of B0 images (10 - `B0 to Remove` + `Extra B0`)
* `N B300`: total number of B300 images (10 - `B300 to Remove` + `Extra B300`)
* `N B1000`: total number of B0 images (60 - `B1000 to Remove` + `Extra B1000`)

### Analyses in PALM

Analyses of the DTI data were conducted with [Permutation Analysis of Linear Models (PALM)](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM)[^7], using preprocessed TBSS data as inputs. Prior to running these analyses, the mask of the FA skeleton (`mean_FA_skeleton_mask.nii`) must be visually inspected and modified, if neccessary, to remove any voxels containing skull/dura, gray matter, etc.

#### PALM commands

`RUN_PALM.m` is a Matlab script that uses PALM to run analyses on the preprocessed TBSS data. Commands are shown for analyses, all controlling for age and mean FA of the white matter skeleton:

* Latent factors from bifactor model with FA
* Shared factor clusters as masks with FA, with either natal sex or psychotropic medication load as additional covariates
* Shared factor clusters as masks with AD
* Shared factor clusters as masks with RD
* Latent factors from CFA with FA
* Questionnaire scores (Affective Reactivity Index (ARI)[^8], CBRS) with FA
* Diagnostic group differences in FA

#### Exchangeability Blocks (EB)

The file `EB.csv` contains the [exchangability blocks](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/PALM/ExchangeabilityBlocks) for PALM[^9], which were used in the analysis for diagnostic group differences in FA, although the column headers must be removed before using with PALM. The columns in this spreadsheet are as follows:

* `participant_id`: participant identifier, which must be removed before running analyses in PALM
* `constant`: column containing -1 for all participants
* `has_rel`: 1 = no siblings in dataset; 2 = has sibling in dataset
* `pair_id`: 1 = no siblings in dataset; 2+ = unique identifier for each sibling pair
* `sub_id`: ascending numbers unique to each participant

There are 11 pairs of related participants:

* 7 HV-HV pairs (`pair_id` = 2, 7, 8, 9, 10, 11, 12)
* 1 DMDD-HV pair (`pair_id` = 3)
* 1 DMDD-ADHD pair (`pair_id` = 4)
* 1 DMDD+ADHD-ADHD pair (`pair_id` = 5)
* 1 ADHD-HV pair (`pair_id` = 6)

## Generating Figures

`GENERATE_FIGS.R` is an R script that load relevant packages and uses data from `phenotype.tsv` and the results of the bifactor model for the Phenotyping subsample to create:

* Figure 2: validation of latent factors
* Figure 3: validation of latent factors with item-level data
* Figure S10: association of latent factors with impairment 
* Figure S11: diagnostic group differences in latent factors
* Figure S12: association of latent factors with age
* Figure S13: sex differences in latent factors

## References

[^1]: McKay, C.C., Scheinberg, B., Xu, E.P., Kircanski, K., Pine, D.S., Brotman, M.A., Leibenluft, E., & Linke, J.O. (2024). Modeling shared and specific variances of irritability, inattention, and hyperactivity yields novel insights into white matter perturbations. *Journal of the American Academy of Child and Adolescent Psychiatry*, *63*(12), 1239-1250. doi: [10.1016/j.jaac.2024.02.010](https://doi.org/10.1016/j.jaac.2024.02.010)

[^2]: Conners, C. K., Pitkanen, J., & Rzepa, S. R. (2011). Conners 3rd Edition (Conners 3; Conners 2008). In J. S. Kreutzer, J. DeLuca, & B. Caplan (Eds.), Encyclopedia of Clinical Neuropsychology (pp. 675–678). Springer New York.

[^3]: Taylor, P. A., & Saad, Z. S. (2013). FATCAT: (an efficient) Functional and Tractographic Connectivity Analysis Toolbox. *Brain Connectivity*, *3*(5), 523–535. doi: [10.1089/brain.2013.0154](https://doi.org/10.1089/brain.2013.0154)

[^4]: Pierpaoli, C., Walker, L., Irfanoglu, M. O., Barnett, A., Basser, P., Chang, L-C., Koay, C., Pajevic, S., Rohde, G., Sarlls, J., Wu, M. (2010). TORTOISE: an integrated software package for processing of diffusion MRI data. ISMRM 18th annual meeting, Stockholm, Sweden, abstract #1597

[^5]: Irfanoglu, M. O., Nayak, A., Jenkins, J., Pierpaoli, C. TORTOISEv3:Improvements and New Features of the NIH Diffusion MRI Processing Pipeline. ISMRM 25th annual meeting, Honolulu, HI, abstract #3540

[^6]: Smith, S. M., Jenkinson, M., Johansen-Berg, H., Rueckert, D., Nichols, T. E., Mackay, C. E., Watkins, K. E., Ciccarelli, O., Cader, M. Z., Matthews, P. M., & Behrens, T. E. (2006). Tract-based spatial statistics: voxelwise analysis of multi-subject diffusion data. *NeuroImage*, *31*(4), 1487–1505. doi: [10.1016/j.neuroimage.2006.02.024](https://doi.org/10.1016/j.neuroimage.2006.02.024)

[^7]: Winkler, A. M., Ridgway, G. R., Webster, M. A., Smith, S. M., & Nichols, T. E. (2014). Permutation inference for the general linear model. *NeuroImage*, *92*(100), 381–397. doi: [10.1016/j.neuroimage.2014.01.060](https://doi.org/10.1016/j.neuroimage.2014.01.060)

[^8]: Stringaris, A., Goodman, R., Ferdinando, S., Razdan, V., Muhrer, E., Leibenluft, E., & Brotman, M. A. (2012). The Affective Reactivity Index: a concise irritability scale for clinical and research settings. *Journal of Child Psychology and Psychiatry*, *53*(11), 1109–1117. doi: [10.1111/j.1469-7610.2012.02561.x](https://doi.org/10.1111/j.1469-7610.2012.02561.x)

[^9]: Winkler, A. M., Webster, M. A., Vidaurre, D., Nichols, T. E., & Smith, S. M. (2015). Multi-level block permutation. *NeuroImage*, *123*, 253–268. doi: [10.1016/j.neuroimage.2015.05.092](https://doi.org/10.1016/j.neuroimage.2015.05.092)
