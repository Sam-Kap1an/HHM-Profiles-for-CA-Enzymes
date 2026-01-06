#!/bin/bash
# This script MUST be sourced, not executed
# Usage: source setup_hmmer_env.sh

# Check if script is being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: This script must be sourced, not executed"
    echo "Usage: source ${0}"
    exit 1
fi

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo -e "${RED}Error: conda is not installed or not in PATH${NC}"
    echo "Please install Miniconda or Anaconda first"
    return 1
fi

echo -e "${GREEN}✓ Conda found${NC}"

# Initialize conda for bash shell
eval "$(conda shell.bash hook)"

# Check if HMMER_ENV exists
ENV_NAME="HMMER_ENV"
if conda env list | grep -q "^${ENV_NAME} "; then
    echo -e "${GREEN}✓ Environment '${ENV_NAME}' found${NC}"
    echo "Activating environment..."
    conda activate ${ENV_NAME}
    echo -e "${GREEN}✓ Environment activated${NC}"
else
    echo -e "${YELLOW}Environment '${ENV_NAME}' not found${NC}"
    echo "Creating new environment with required packages..."
    
    # Create environment with all required packages
    conda create -n ${ENV_NAME} -c conda-forge -c bioconda \
        python \
        pandas \
        clustalo \
        hmmer \
        biopython \
        jupyter \
        notebook \
        ipykernel \
        -y
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Environment created successfully${NC}"
        conda activate ${ENV_NAME}
        echo -e "${GREEN}✓ Environment activated${NC}"
    else
        echo -e "${RED}Error: Failed to create environment${NC}"
        return 1
    fi
fi

echo -e "\n${GREEN}Current environment: $(conda info --envs | grep '*' | awk '{print $1}')${NC}"