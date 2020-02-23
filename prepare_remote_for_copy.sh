#!/bin/bash
# copy data from bucket to local AWS instance

# config file
source $1

mkdir -p $archives_dir

for i in "${!task[@]}"; do

	this_scan="${task[$i]}"
	target_dir="${target_base_dir}/${this_scan}/"
	subIDs_file="${target_base_dir}/${this_scan}${subIDs_prefix}"
	zip_file="${archives_dir}/${this_scan}_archive.zip"

	zip -r -s 100m ${zip_file} ${target_dir}
	cp ${subIDs_file} ${target_dir}

done
