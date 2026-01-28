# HMM Profiles for Carbonic Anhydrase Classification

A bioinformatics pipeline for classifying carbonic anhydrase (CA) enzymes into their eight convergently evolved families using profile Hidden Markov Models (HMMs).

## Overview

Carbonic anhydrases catalyze the reversible hydration of CO₂ and have evolved independently at least eight times, resulting in structurally distinct enzyme families (α, β, γ, δ, ζ, η, θ, ι). Traditional sequence alignment methods struggle with convergently evolved proteins because sequence similarity does not imply shared ancestry. This project builds family-specific HMM profiles to classify CAs based on learned sequence patterns rather than pairwise similarity.

**Key Results:**
- 8 family-specific HMM profiles trained on curated sequences
- 100% classification accuracy on held-out test sequences (n=119)
- Successfully classified ~148,000 UniProt CA sequences
- 94.8% of sequences assigned to a family; 5.2% returned as NO_HIT

## Repository Structure
```
├── environment_config.sh          # Setup script for conda environment
├── class_eval.ipynb               # Sequence preprocessing and EDA
├── balanced_hmms.py.ipynb         # HMM construction and initial validation
├── hmm_eval.ipynb                 # Comprehensive model analysis
├── 8ca-1024.aln-fasta             # Multiple sequence alignment file
├── uniprotkb_carbonic_anhydrase_2025_08_22.fasta  # UniProt CA sequences
├── OG_Labels/                     # Original sequence labels
├── filtered_sets_per_class/       # Curated sequences per CA family
├── new_labels/                    # Additional manually curated sequnces 
└── README.md
```

## Installation & Setup

### Prerequisites
- Conda or Miniconda
- HMMER3 (for HMM construction and searching)
- Jupyter Notebook/Lab

### Environment Setup

Run the provided bash script to configure the conda environment with all required dependencies:
```bash
chmod +x environment_config.sh
source environment_config.sh
```

This installs:
- Python 3.x
- BioPython
- Pandas, NumPy, Matplotlib, Seaborn
- HMMER3 tools
- Jupyter

### Activate Environment
Script should activate the Env however it can also be activated using
```bash
conda activate HMMER_ENV
```

## Usage

Run the Jupyter notebooks in the following order:

### 1. `class_eval.ipynb` — Sequence Preprocessing & EDA

This notebook handles initial data processing:
- Loading and parsing FASTA sequences from UniProt
- Exploratory data analysis of sequence lengths and compositions
- Filtering and trimming sequences
- Preparing training/held-out splits per family
- Quality control and validation of curated datasets

### 2. `balanced_hmms.py.ipynb` — HMM Construction

This notebook builds the classification models:
- Constructing multiple sequence alignments per family
- Building family-specific HMM profiles using `hmmbuild`
- Initial validation and parameter tuning
- Concatenating profiles into a single HMM library
- Preliminary classification tests

### 3. `hmm_eval.ipynb` — Model Analysis & Evaluation

This notebook performs comprehensive evaluation:
- Held-out sequence classification and accuracy assessment
- Confusion matrix analysis
- E-value and bit score distribution analysis
- Information content and Shannon entropy profiling
- Conserved motif extraction
- Visualization of learned HMM features
- Large-scale UniProt classification

## Data Files

| Directory/File | Description |
|----------------|-------------|
| `OG_Labels/` | Original family labels from literature and databases |
| `filtered_sets_per_class/` | Curated, quality-controlled sequences for each CA family used in HMM training |
| `new_labels/` | More labeled sequences for stronger profiles |
| `8ca-1024.aln-fasta` | Reference multiple sequence alignment |
| `uniprotkb_carbonic_anhydrase_*.fasta` | Raw UniProt carbonic anhydrase sequences |
| *Not Included* `OUTPUT/` | Location of all plots and subsequent CSVs. Excluded from repo due to size constraints |


## Output

After running the pipeline, `OUTPUT/` will contain:
- `results/uniprot_first_150000_labels_with_confidence.csv` — Classifications with E-values and confidence scores
- `06_dirs_heldout_predictions.csv` — Held-out evaluation results
- `06_dirs_confusion_matrix.csv` — Classification confusion matrix

## Citation

If you use this pipeline or the trained HMM profiles, please cite:
```
TBD :)
```

## Contact

Samuel Kaplan  
Cal Poly Computational and Molecular Sciences Research Lab  
sfkaplan@calpoly.edu
