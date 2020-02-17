#!/bin/bash

# from bucket to local AWS instance

yale_bucket_key='/home/ec2-user/.s3cmd_saved_configs/yale_bucket_access'
source_base_dir='s3://hcpoutput/S1200/Shen268'
target_base_dir='/home/ec2-user/data/matrices'
archives_dir="$target_base_dir/archives/"

# tasks and respective subdirectories
#tasks=('RELATIONAL')
tasks=('EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM')
#tasks=('EMOTION' 'GAMBLING' 'SOCIAL' 'RELATIONAL' 'MOTOR' 'WM' 'LANGUAGE')
#directions=('LR')
directions=('LR' 'RL')

# what sort of file do you want?
search_str="_GSR_matrix"

copy=0;
zip=1;

mkdir -p $archives_dir
for j in "${!directions[@]}"; do

    for i in "${!tasks[@]}"; do

        this_scan="${tasks[$i]}_${directions[$j]}"
        source_dir="${source_base_dir}/${this_scan}/"
        target_dir="${target_base_dir}/${this_scan}/"
        subnames_file="${target_base_dir}/${this_scan}_subnames.txt"
        zip_file="${archives_dir}/${this_scan}_archive.zip"

        if (( $copy==1 )) ; then

            mkdir -p $target_dir

            tmpfile=$(mktemp /tmp/tmp_names_${this_scan}.XXXXXX)
            s3cmd -c ${yale_bucket_key} ls ${source_dir} > $tmpfile
            grep ${search_str} $tmpfile > "${subnames_file}"
            sed -e "s/2019.*s3/s3/g" -i "${subnames_file}"

            printf "Copying data from $source_dir to ${target_dir}.\n"
            while read -r line; do
                s3cmd -c ${yale_bucket_key} get $line "${target_dir}";
            done < "${subnames_file}"
        fi

        if (( $zip==1 )) ; then
            zip -r -s 100m ${zip_file} ${target_dir}
        fi

    done
done
