#!/bin/bash
source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

wget "https://raw.githubusercontent.com/Open-Catalyst-Project/AdsorbML/b3e17d4e917e6e7d49dfa18df6b25f3039859d7b/README.md"

files_url=(
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/adsorbml/oc20_dense_data.tar.gz oc20_dense_data.tar.gz"
	"https://dl.fbaipublicfiles.com/opencatalystproject/data/adsorbml/oc20_dense_trajectories.tar.gz oc20_dense_trajectories.tar.gz")

git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
# Downloads should complete correctly but in multiprocesses the last git-annex
# step most likely fails on a BGFS with the error "rename: resource busy
# (Device or resource busy)"
! git-annex get --fast -J8
# Remove the last byte from each files to prevent the "download failed:
# ResponseBodyTooShort" error
ls -l $(list) | grep -oE "\.git/[^']*" | \
	cut -d'/' -f7 | xargs -n1 -- find .git/annex/tmp/ -name | \
	while read f
	do
		newfsize=$(($(stat -c '%s' "${f}") - 1))
		truncate -s $newfsize "${f}"
	done
# Retry incomplete downloads
git-annex get --fast --incomplete
git-annex migrate --fast -c annex.largefiles=anything *

# Verify dataset
if [[ -f md5sums ]]
then
	md5sum -c md5sums
fi
list -- --fast | while read f
do
	if [[ -z "$(echo "${f}" | grep -E "^bin/")" ]] &&
		[[ -z "$(grep -E " (\./)?${f//\./\\.}$" md5sums)" ]]
	then
		md5sum "${f}" >> md5sums
	fi
done
