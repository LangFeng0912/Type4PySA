#!/bin/bash
# train_model.sh

export LIM="256" # Set default project numbers as 256

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -l|--level)
      export LIM="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      # Unknown option
      shift
      ;;
  esac
done

echo "Model is training on : $LIM projects"

cd /..
cd MTV0.8/
type4py preprocess --o dataset --l $LIM