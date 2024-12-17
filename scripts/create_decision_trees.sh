#!/bin/bash
set -euo pipefail

version="v2.0.1"
bash create_decision_tree.sh -o decision_tree_"${version}"_LX001.json -b LX001_v1.0.1.bed
bash create_decision_tree.sh -o decision_tree_"${version}"_LX002.json -b LX002_v1.0.1.bed
bash create_decision_tree.sh -o decision_tree_"${version}"_LX003.json -b LX003_v1.0.0.bed
bash create_decision_tree.sh -o decision_tree_"${version}"_LX004.json
