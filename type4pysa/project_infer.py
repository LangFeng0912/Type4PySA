from argparse import ArgumentParser
from typing import List
from libsa4py.exceptions import ParseError

import pandas as pd
from type4py.deploy.infer import PretrainedType4Py, type_annotate_file
from libsa4py.utils import list_files, find_repos_list
from type4py import logger

from pathlib import Path
import json
import os

def find_test_list(project_dir, dataset_split):
    if os.path.exists(dataset_split):
        repos_list: List[dict] = []

        test_df = pd.read_csv(dataset_split)
        for index, row in test_df.iterrows():
            project = row['project']
            author = project.split('/')[0]
            repo = project.split('/')[1]
            project_path = os.path.join(project_dir, author, repo)
            if os.path.isdir(project_path):
                repos_list.append({"author": author, "repo": repo})
        return repos_list

    else:
        print("test_repo.csv does not exist!")

def infer(repo, model, project_dir, tar_dir):
    project_author = repo["author"]
    project_name = repo["repo"]
    project_path = os.path.join(project_dir, project_author, project_name)
    id_tuple = (project_author, project_name)
    project_id = "/".join(id_tuple)
    project_analyzed_files: dict = {project_id: {"src_files": {}, "type_annot_cove": 0.0}}
    print(f'Running pipeline for project {project_path}')

    print(f'Extracting for {project_path}...')
    project_files = list_files(project_path)
    print(f"{project_path} has {len(project_files)} files")

    project_files = [(f, str(Path(f).relative_to(Path(project_path).parent))) for f in project_files]

    if len(project_files) != 0:
        for filename, f_relative in project_files:
            try:
                ext_type_hints = type_annotate_file(model, None, filename)
                project_analyzed_files[project_id]["src_files"][filename] = \
                    ext_type_hints
            except ParseError as err:
                print("project: %s |file: %s |Exception: %s" % (project_id, filename, err))
            except UnicodeDecodeError:
                print(f"Could not read file {filename}")
            except Exception as err:
                print("project: %s |file: %s |Exception: %s" % (project_id, filename, err))

    if len(project_analyzed_files[project_id]["src_files"].keys()) != 0:
        project_analyzed_files[project_id]["type_annot_cove"] = \
            round(sum([project_analyzed_files[project_id]["src_files"][s]["type_annot_cove"] for s in
                       project_analyzed_files[project_id]["src_files"].keys()]) / len(
                project_analyzed_files[project_id]["src_files"].keys()), 2)

    processed_file = os.path.join(tar_dir, f"{project_author}{project_name}_mlInfer.json")
    with open(processed_file, 'w') as json_f:
        json.dump(project_analyzed_files, json_f, indent=4)

def infer_projects(model, pro_path, tar_path, splitfile):
    test_repos_list = find_test_list(pro_path, splitfile)
    print(f'Totally find {len(test_repos_list)} projects in test set')
    i = 0
    for repo in test_repos_list:
        # infer project
        infer(repo, model, pro_path, tar_path)
        i = i + 1
        print(f'{i} projects have been inferred... ')


def infer_main(project_path,model_path, tar_path, splitfile):

    t4py_pretrained_m = PretrainedType4Py(model_path, "gpu", pre_read_type_cluster=False, use_pca=True)
    t4py_pretrained_m.load_pretrained_model()

    infer_projects(t4py_pretrained_m, project_path, tar_path, splitfile)

