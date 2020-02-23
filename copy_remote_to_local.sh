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
    subIDs_file="${local_source_base_dir}/${this_scan}${subIDs_prefix}"

    if [ ! -f "${local_target_data_dir}/${this_scan}" ]; then
        main_zipfile_prefix="${local_target_archives_dir}/${this_scan}_archive"
        if [ ! -f "${main_zipfile_prefix}.zip" ]; then
            printf "Copying ${main_zipfile_prefix}* zipfiles.\n"
            cp ${mounted_archives_dir}/${this_scan}*.z* $local_target_archives_dir
            cp $subIDs_file $local_target_data_dir
        fi

        local_unzipped_dir="${local_target_archives_dir}${target_base_dir}/${this_scan}"
        if [ ! -d "${local_unzipped_dir}" ]; then
            printf "Combining ${main_zipfile_prefix}* zip multifile and unzipping in ${local_unzipped_dir}.\n"
            zip -s 0 "${main_zipfile_prefix}.zip" --out "${main_zipfile_prefix}-unsplit.zip"
            unzip "${main_zipfile_prefix}-unsplit.zip" -d "${local_target_archives_dir}/"
        fi

        if [ ! -d "${local_target_task_dir}" ]; then
            
            printf "Moving data to ${local_target_data_dir}.\n"
            mv "${local_unzipped_dir}/" "${local_target_data_dir}"
        fi
    else
        printf "Data already copied to "${local_target_data_dir}/${this_scan}".\n"
    fi
    
done
