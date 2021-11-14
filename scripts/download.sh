#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

files_url=(
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_train_all.tar s2ef_train_all.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_train_20M.tar s2ef_train_20M.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_train_2M.tar s2ef_train_2M.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_train_200K.tar s2ef_train_200K.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_val_id.tar s2ef_val_id.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_val_ood_ads.tar s2ef_val_ood_ads.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_val_ood_cat.tar s2ef_val_ood_cat.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_val_ood_both.tar s2ef_val_ood_both.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/is2re_test_challenge_2021.tar.gz is2re_test_challenge_2021.tar.gz"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_test_lmdbs.tar.gz s2ef_test_lmdbs.tar.gz"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_rattled.tar s2ef_rattled.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/s2ef_md.tar s2ef_md.tar"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/is2res_train_val_test_lmdbs.tar.gz is2res_train_val_test_lmdbs.tar.gz")

# These urls require login cookies to download the file
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -J8
git-annex migrate --fast -c annex.largefiles=anything *

[[ -f md5sums ]] && md5sum -c md5sums
[[ -f md5sums ]] || md5sum $(list -- --fast) > md5sums
