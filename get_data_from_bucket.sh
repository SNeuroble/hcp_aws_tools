#!/bin/bash
# copy data from bucket to local server

# config file
source $1

for j in "${!encoding[@]}"; do

    for i in "${!task[@]}"; do

        this_scan="${task[$i]}_${encoding[$j]}"
        source_dir="${source_base_dir}/${this_scan}/"
        target_dir="${target_base_dir}/${this_scan}/"
        filenames="${target_base_dir}/${this_scan}_filenames.txt"
        subIDs_file="${target_base_dir}/${this_scan}${subIDs_prefix}"


            mkdir -p $target_dir

            # record filenames to copy
            tmpfile=$(mktemp /tmp/tmp_names_${this_scan}.XXXXXX)
            $s3cmd -c ${bucket_key} ls ${source_dir} > $tmpfile
            grep ${search_str} $tmpfile > "${filenames}"
            sed -e "s#^20.*s3#s3#g" -i "${filenames}"

            # copy files
            printf "Copying data from $source_dir to ${target_dir}.\n"
            while read -r line; do
                s3cmd -c ${bucket_key} get --skip-existing $line "${target_dir}";
            done < "${filenames}"
        
            # make subIDs file
            cp $filenames $subIDs_file
            sed -e "s#$source_dir##g" -i "$subIDs_file"
            sed -e "s#_${this_scan}${search_str}.txt##g" -i "$subIDs_file"


    done
done
