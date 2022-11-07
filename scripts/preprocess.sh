#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

_DATA_DIR="${PWD}"
_TMP_DIR="${PWD}/.tmp"

(init_venv --name condamerge --prefix "${_TMP_DIR}/" && \
	python3 -m pip install conda-merge && \
	conda-merge ocp/env.common.yml ocp/env.gpu.yml | grep -v "^name: " > "${_TMP_DIR}/"/env.yml)

(init_conda_env --name . --prefix "${_TMP_DIR}/" && \
	conda env update -p "${CONDA_PREFIX}" --file "${_TMP_DIR}/"env.yml)

# prepare preprocessed dirs
mkdir -p is2re/ s2ef/
ln -sft "${_TMP_DIR}/" "${_DATA_DIR}/"is2re/ "${_DATA_DIR}/"s2ef/
 
if [[ -z "${_NUM_CPUS}" ]]
then
	_NUM_CPUS=8
fi

pushd ocp/ >/dev/null
(init_conda_env --name . --prefix "${_TMP_DIR}/" && \
	python3 -m pip install -e . && \
	python3 scripts/download_data.py --task is2re \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split val_id --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split val_id --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split val_ood_ads --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split val_ood_cat --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split val_ood_both --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split 20M --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS && \
	python3 scripts/download_data.py --task s2ef \
		--split all --get-edges --ref-energy \
		--input-path "${_DATA_DIR}/" --data-path "${_TMP_DIR}/" --num-workers $_NUM_CPUS)
popd >/dev/null

git-annex add is2re/ s2ef/

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- is2re/ s2ef/ --fast) > md5sums
