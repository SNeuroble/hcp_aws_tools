#!/bin/bash
# copy data from bucket to local AWS instance

# scan info
task=('EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM')
#task=('EMOTION' 'GAMBLING' 'SOCIAL' 'RELATIONAL' 'MOTOR' 'WM' 'LANGUAGE')
search_str="_GSR_matrix"

# copy and/or zip?
copy=1;
zip=0;

# paths
username=$(echo $USER)
yale_bucket_key="/home/$username/.s3cmd_saved_configs/yale_bucket_access"
source_base_dir="s3://hcpoutput/S1200/Shen268"
target_base_dir="/home/$username/data/matrices"
archives_dir="$target_base_dir/archives/"

encoding=('LR' 'RL')

mkdir -p $archives_dir
for j in "${!encoding[@]}"; do

    for i in "${!task[@]}"; do

        this_scan="${task[$i]}_${encoding[$j]}"
        source_dir="${source_base_dir}/${this_scan}/"
        target_dir="${target_base_dir}/${this_scan}/"
        filenames="${target_base_dir}/${this_scan}_filenames.txt"
        subIDs_file="${target_base_dir}/${this_scan}_subIDs.txt"
	zip_file="${archives_dir}/${this_scan}_archive.zip"

        if (( $copy==1 )) ; then

            mkdir -p $target_dir

	    # record filenames to copy
            tmpfile=$(mktemp /tmp/tmp_names_${this_scan}.XXXXXX)
            s3cmd -c ${yale_bucket_key} ls ${source_dir} > $tmpfile
            grep ${search_str} $tmpfile > "${filenames}"
            sed -e "s#^20.*s3#s3#g" -i "${filenames}"

	    # copy files
            printf "Copying data from $source_dir to ${target_dir}.\n"
            while read -r line; do
                s3cmd -c ${yale_bucket_key} get $line "${target_dir}";
            done < "${filenames}"

	    # make subIDs file
	    cp $filenames $subIDs_file
	    sed -e "s#$source_dir##g" -i "$subIDs_file"
	    sed -e "s#_${this_scan}${search_str}.txt##g" -i "$subIDs_file"

    	fi

        if (( $zip==1 )) ; then
            zip -r -s 100m ${zip_file} ${target_dir}
        fi

    done
done
