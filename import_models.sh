#!/bin/bash

MODELS_DIR="$(pwd)/assets/models"

for glb_file in "$MODELS_DIR"/*.glb; do
  model_file="${glb_file%.glb}.model"
  
  if [ ! -f "$model_file" ]; then
    echo "Importing: $(basename $glb_file)"
    dart run flutter_scene_importer:import \
      --input "$glb_file" \
      --output "$model_file"
  else
    echo "Skipping: $(basename $glb_file) (already imported)"
  fi
done

echo "Done."