#!/usr/bin/env bash

# Update README.md 
# expecting tekton-catalog repository folder to be a sibling of this repository clone folder

python3 ../tekton-catalog/.ci/generate_pipeline_doc.py \
  --file "$(pwd)/.deploy_rolling_satellite_pipeline/*.yaml" \
  --file "$(pwd)/../tekton-catalog/git/*.yaml" \
  --file "$(pwd)/../tekton-catalog/container-registry/*.yaml" \
  --file "$(pwd)/../tekton-catalog/kubernetes-service/*.yaml" \
  --file "$(pwd)/../tekton-catalog/toolchain/*.yaml" \
  --file "(pwd)/../tekton-catalog/linter/*.yaml" \
  --file "(pwd)/../tekton-catalog/tester/*.yaml" \
  --file "(pwd)/../tekton-catalog/utils/*.yaml" \
  --output "$(pwd)/README.md" \
  --anchor-output "#### Satellite Deployment - Tekton Pipelines"

python3 "../tekton-catalog/.ci/update_readme.py" \
  --output "$(pwd)/README.md" \
  --summary-anchor-output "#### Satellite Deployment - Tekton Task(s)" \
  --details-anchor-output "#### Satellite Deployment - Tekton Task(s)" \
  --file "$(pwd)/.deploy_rolling_satellite_pipeline/*.yaml"
