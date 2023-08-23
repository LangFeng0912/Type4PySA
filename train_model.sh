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

buildmt build --p raw_projects --l $LIM
echo "Projects download and preprocess finished, start libSA4Py process"

buildmt split --p raw_projects
echo "Projects split ..."

libsa4py process --p raw_projects --o results --s dataset_split.csv --pyre --j 8
echo "Projects processed finished"

type4py preprocess --o results --l $LIM
type4py vectorize --o results
type4py learns --o results --dt var
type4py learns --o results --dt param
type4py learns --o results --dt ret
type4py gen_type_clu --o results --dt var
type4py gen_type_clu --o results --dt param
type4py gen_type_clu --o results --dt ret
type4py reduce --o results --d 256
type4py to_onnx --o results
type4py infer_project --m results --p raw_projects --o results --a t4py
type4py infer_project --m results --p raw_projects --o results --a t4pyre


