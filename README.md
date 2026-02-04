# HMM Profiles for Carbonic Anhydrase Classification

A bioinformatics pipeline for classifying carbonic anhydrase (CA) enzymes into their eight convergently evolved families using profile Hidden Markov Models (HMMs).

## Overview

Carbonic anhydrases catalyze the reversible hydration of CO₂ and have evolved independently at least eight times, resulting in structurally distinct enzyme families (α, β, γ, δ, ζ, η, θ, ι). Traditional sequence alignment methods struggle with convergently evolved proteins because sequence similarity does not imply shared ancestry. This project builds family-specific HMM profiles to classify CAs based on learned sequence patterns rather than pairwise similarity.

**Key Results:**
- 8 family-specific HMM profiles trained on curated sequences (575 total sequences)
- 100% classification accuracy on held-out test sequences (n=119)
- Successfully classified ~148,000 UniProt CA sequences
- 94.8% of sequences assigned to a family; 5.2% returned as NO_HIT

## Repository Structure

```
├── README.md                      # This file
├── environment_config.sh          # Setup script for conda environment
│
├── class_eval.ipynb               # Sequence preprocessing and EDA
├── balanced_hmms_py.ipynb         # HMM construction and validation
├── hmm_eval.ipynb                 # Comprehensive model analysis
├── batch_hmm_classify.ipynb       # Batch classification of new sequences
│
├── input_sequences/               # [User input] Place FASTA files here for classification
├── new_classification_results/    # [Output] Classification results in CSV format
│
├── OG_Labels/                     # Original sequence labels (8 families)
├── new_labels/                    # Additional manually curated sequences
├── filtered_sets_per_class/       # Curated sequences per CA family for training
│
├── OUTPUT/                        # Main output directory (excluded from repo due to size)
│   ├── hmmer_lib/
│   │   └── all_classes.hmm        # Combined HMM library (all 8 families)
│   ├── results/
│   │   ├── uniprot_first_150000_labels_with_confidence.csv
│   │   ├── hmmscan_dirs_heldout.tbl
│   │   └── hmmscan_dirs_heldout.domtbl
│   ├── per_class_aligned/         # MSAs per family
│   └── train_aligned/             # Training set alignments
│
├── 8ca-1024.aln-fasta             # Reference multiple sequence alignment
└── uniprotkb_carbonic_anhydrase_2025_08_22.fasta  # UniProt CA sequences
```

## Installation & Setup

### Prerequisites
- **Conda** or Miniconda ([Installation guide](https://docs.conda.io/en/latest/miniconda.html))
- **HMMER3** (installed via conda in environment setup)
- **Jupyter** Notebook/Lab (installed via conda)

### Environment Setup

The provided bash script configures a conda environment with all required dependencies:

```bash
# Make the script executable
chmod +x environment_config.sh

# Source the script (do not execute directly)
source environment_config.sh
```

This creates the `HMMER_ENV` environment and installs:
- Python 3.x
- BioPython (sequence parsing)
- Pandas, NumPy (data processing)
- Matplotlib, Seaborn (visualization)
- HMMER3 tools (`hmmbuild`, `hmmscan`, `hmmpress`)
- Jupyter (notebook interface)
- scikit-learn (evaluation metrics)
- tqdm (progress bars)

### Manual Activation

If needed, manually activate the environment:
```bash
conda activate HMMER_ENV
```

### Verify Installation

Check that HMMER tools are available:
```bash
hmmscan --version
hmmbuild --version
```


## Quick Start: Classifying New Sequences

If you just want to classify new sequences using pre-built HMM profiles:

1. **Activate the environment:**
   ```bash
   conda activate HMMER_ENV
   ```

2. **Place your FASTA files** in the `input_sequences/` directory
   - Supported formats: `.fasta`, `.fa`, `.faa`, `.fas`, `.txt`

3. **Open the batch classification notebook:**
   ```bash
   jupyter notebook batch_hmm_classify.ipynb
   ```

4. **Run all cells** in the notebook

5. **Check results** in `new_classification_results/`:
   - Individual CSV files: `<filename>_classification.csv`
   - Combined results: `all_classifications_<timestamp>.csv`
   - Processing summary: `processing_summary_<timestamp>.csv`

### Output CSV Format

| Column | Description |
|--------|-------------|
| `seq_id` | Sequence identifier (first token of FASTA header) |
| `seq_description` | Full FASTA header |
| `seq_length` | Sequence length in amino acids |
| `predicted_class` | Predicted CA family (alpha, beta, gamma, delta, zeta, eta, theta, iota, or NO_HIT) |
| `predicted_model` | Full HMM model name (e.g., "8ca.alpha.45") |
| `bit_score` | HMMER bit score (higher = better match) |
| `evalue` | E-value (lower = more significant) |
| `source_file` | Original FASTA filename |

**Note:** Sequences labeled `NO_HIT` did not match any HMM profile above the significance threshold.

## Full Pipeline: Building HMMs from Scratch

If you want to reproduce the entire pipeline or build new HMM profiles:

### 1. `class_eval.ipynb` — Sequence Preprocessing & EDA

**Purpose:** Initial data processing and quality control

**Key Steps:**
- Load and parse FASTA sequences from multiple sources
- Exploratory data analysis of sequence lengths and compositions
- Filter sequences by length and quality criteria
- Remove duplicates and standardize sequence IDs
- Create training/test splits per family (80/20 split)
- Generate curated datasets for HMM training

**Inputs:**
- `OG_Labels/` — Original family labels
- `new_labels/` — Additional curated sequences
- Raw FASTA files

**Outputs:**
- `OUTPUT/OG_Labels_UPDATED/` — Merged and deduplicated sequences
- `OUTPUT/filtered_sets_per_class/` — Quality-controlled sequences per family

### 2. `balanced_hmms_py.ipynb` — HMM Construction

**Purpose:** Build family-specific HMM profiles

**Key Steps:**
- Create multiple sequence alignments (MSAs) using Clustal Omega
- Clean and trim alignments to remove excessive gaps
- Build HMM profiles for each family using `hmmbuild`
- Combine individual HMMs into a single library
- Press HMM database using `hmmpress`
- Perform initial validation on training and test sets

**Inputs:**
- `OUTPUT/filtered_sets_per_class/` — Curated sequences

**Outputs:**
- `OUTPUT/per_class_aligned/` — MSAs per family
- `OUTPUT/profiles/` — Individual HMM files
- `OUTPUT/hmmer_lib/all_classes.hmm` — Combined HMM library
- `OUTPUT/hmmer_lib/all_classes.hmm.h3*` — Pressed HMM database files

### 3. `hmm_eval.ipynb` — Model Analysis & Evaluation

**Purpose:** Comprehensive evaluation and large-scale classification

**Key Steps:**
- Parse and analyze HMM profiles (emission probabilities, lengths)
- Classify held-out test sequences (n=119)
- Generate confusion matrix and accuracy metrics
- Analyze bit score distributions per family
- Calculate information content and Shannon entropy
- Extract conserved motifs and positional preferences
- Visualize learned HMM features (emission heatmaps)
- Classify large-scale UniProt dataset (~148,000 sequences)

**Inputs:**
- `OUTPUT/hmmer_lib/all_classes.hmm` — HMM library
- Held-out test sequences
- `uniprotkb_carbonic_anhydrase_*.fasta` — UniProt sequences

**Outputs:**
- `OUTPUT/results/hmmscan_dirs_heldout.tbl` — Classification results
- `OUTPUT/results/hmmscan_dirs_heldout.domtbl` — Detailed domain hits
- `OUTPUT/results/uniprot_first_150000_labels_with_confidence.csv` — Large-scale classifications


## Data Files

| Directory/File | Description | Size |
|----------------|-------------|------|
| `OG_Labels/` | Original family labels from literature and databases | 8 files |
| `filtered_sets_per_class/` | Curated, quality-controlled sequences for HMM training | 8 families |
| `new_labels/` | Additional manually curated sequences | Variable |
| `8ca-1024.aln-fasta` | Reference multiple sequence alignment | ~1024 sequences |
| `uniprotkb_carbonic_anhydrase_*.fasta` | Raw UniProt carbonic anhydrase sequences | ~148k sequences |
| `OUTPUT/hmmer_lib/all_classes.hmm` | **Pre-built HMM profiles** (ready to use) | 8 families |
| `OUTPUT/results/uniprot_first_150000_labels_with_confidence.csv` | Classifications with E-values | ~148k rows |

## Technical Details

### HMM Construction

**Multiple Sequence Alignment:**
- Tool: Clustal Omega v1.2.4
- Parameters: Default protein alignment settings
- Post-processing: Gap cleaning, trimming of poorly aligned regions

**HMM Building:**
- Tool: HMMER v3.4 (`hmmbuild`)
- Training set: 80% of curated sequences per family
- Model architecture: Plan7 profile HMMs
- Position-specific emission and transition probabilities


## Citation

If you use this pipeline or the trained HMM profiles in your research, please cite:

```
TBD :)
```


## License

This project is released under the MIT License. See `LICENSE` file for details.

## Contact

**Samuel Kaplan**  
California Polytechnic State University, San Luis Obispo  
Computational and Molecular Sciences Research Lab  
BioInformatics Research Group  
sfkaplan@calpoly.edu  
Advisors: Dr. Anderson, Dr. Oza,  Dr. Davidson
---

**Acknowledgments:** This work was conducted at the Cal Poly Computational and Molecular Sciences Research Lab with support from the Computer Science and Biochemistry departments.

*Last updated: February 2025*