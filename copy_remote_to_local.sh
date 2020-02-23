#!/bin/bash
# copying, mainly for HCP

#### Setup
source $1

#### Mount

if (( $(grep -c "$local_source_base_dir" /proc/mounts ) == 0 )); then
    sshfs -o "IdentityFile=$key_file" ${un}@${ip}:${mounted_source_dir}/ ${local_source_base_dir}
fi

#### Copy

for i in "${!task[@]}"; do
    #for j in "${!encodings[@]}"; do
        
        this_scan="${task[$i]}"
        #this_scan="${task[$i]}_${encodings[$j]}"
        #printf "${this_scan}\n"
        #source_data_pattern="${mounted_archives_dir}/${this_scan}*.z*"
        subIDs_file="${local_source_base_dir}/${this_scan}${subIDs_prefix}"

        main_zipfile_prefix="${local_target_archives_dir}/${this_scan}_archive"
        if [ ! -f "${main_zipfile_prefix}.zip" ]; then
            printf "Copying ${main_zipfile_prefix}* zipfiles.\n"
            cp ${mounted_archives_dir}/${this_scan}*.z* $local_target_archives_dir
            cp $subIDs_file $local_target_data_dir
        fi

        local_unzipped_dir="${local_target_archives_dir}${target_base_dir}/"
        if [ ! -d "${local_unzipped_dir}" ]; then
            printf "Combining ${main_zipfile_prefix}* zip multifile, unzipping, and moving to ${local_unzipped_task_dir}.\n"
            zip -s 0 "${main_zipfile_prefix}.zip" --out "${main_zipfile_prefix}-unsplit.zip"
            unzip "${main_zipfile_prefix}-unsplit.zip" -d "${local_target_archives_dir}/"
        fi

        if [ ! -d "${local_target_task_dir}" ]; then
            mv "${local_unzipped_dir}/" "${local_target_data_dir}"
            #mv "${local_target_archives_dir}/${this_scan}${subIDs_prefix}" "${local_target_data_dir}/"
        fi
    
    #done
done
