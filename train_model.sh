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
type4py vectorize --o dataset
type4py learns --o dataset --dt var
type4py learns --o dataset --dt param
type4py learns --o dataset --dt ret
type4py gen_type_clu --o dataset --dt var
type4py gen_type_clu --o dataset --dt param
type4py gen_type_clu --o dataset --dt ret
type4py reduce --o dataset --d 256
type4py to_onnx --o dataset
