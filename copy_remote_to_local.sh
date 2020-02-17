#!/bin/bash
# copying, mainly for HCP

#### Setup

# latest instance IP address
un="ec2-user"
ip="18.206.222.203"

# data folders
mounted_source_dir='/home/ec2-user/data/matrices/'
target_base_dir='/data15/mri_group/smn33_data/hcp_1200/archives/';
source_base_dir="${target_base_dir}mnt2"
source_archives_dir="${source_base_dir}/archives"
target_unzipped_dir='/data15/mri_group/smn33_data/hcp_1200/matrices/';
key_file="/mridata2/home2/smn33/.ssh/MRCInstance1.pem"

# tasks and respective subdirectories
#tasks=('LANGUAGE')
tasks=('REST' 'LANGUAGE')
#tasks=('EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM' 'LANGUAGE' 'REST')
#tasks=('EMOTION' 'GAMBLING' 'SOCIAL' 'RELATIONAL' 'MOTOR' 'WM' 'LANGUAGE')
directions=('LR')
#directions=('LR' 'RL')

#### Mount

if (( $(grep -c "$source_base_dir" /proc/mounts ) == 0 )); then
    sshfs -o "IdentityFile=$key_file" ${un}@${ip}:${mounted_source_dir} ${source_base_dir}
fi

#### Copy

for i in "${!tasks[@]}"; do
    for j in "${!directions[@]}"; do
        
        this_scan="${tasks[$i]}_${directions[$j]}"
        #printf "${this_scan}\n"
        #source_data_pattern="${source_archives_dir}/${this_scan}*.z*"
        subnames_file="${source_base_dir}/${this_scan}_subnames.txt"

        main_zipfile_prefix="${target_base_dir}/${this_scan}_archive"
        if [ ! -f "${main_zipfile_prefix}.zip" ]; then
            exit
            printf "Copying ${main_zipfile_prefix}* zipfiles.\n"
            cp ${source_archives_dir}/${this_scan}*.z* $target_base_dir
            cp $subnames_file $target_base_dir
        fi

        if [ ! -d "${target_base_dir}${mounted_source_dir}${this_scan}" ]; then
            printf "Combining ${main_zipfile_prefix}* zip multifile, unzipping, and moving to ${mounted_source_dir}$(this_scan).\n"
            zip -s 0 "${main_zipfile_prefix}.zip" --out "${main_zipfile_prefix}-unsplit.zip"
            unzip "${main_zipfile_prefix}-unsplit.zip"
        fi

        if [ ! -d "${target_unzipped_dir}${this_scan}" ]; then
            mv "${target_base_dir}${mounted_source_dir}${this_scan}" "${target_unzipped_dir}"
            mv "${target_base_dir}${this_scan}_subnames.txt" "${target_unzipped_dir}"
        fi
    
    done
done
