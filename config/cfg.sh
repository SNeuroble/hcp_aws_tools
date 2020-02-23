## For getting and preparing data on remote

# scan info
task=('EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM' 'RELATIONAL')
#task=('REST' 'LANGUAGE' 'EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM' 'RELATIONAL')
encoding=('LR' 'RL')
search_str="_GSR_matrix"

# paths
username=$(echo $USER)
yale_bucket_key="/home/$username/.s3cmd_saved_configs/yale_bucket_access"
source_base_dir="s3://hcpoutput/S1200/Shen268"
remote_data_dir="/home/$username/data"
target_base_dir="$remote_data_dir/matrices"
archives_dir="$remote_data_dir/archives/"

encoding=('LR' 'RL')
subIDs_prefix='_subIDs.txt'

## For copying remote to local

# latest instance IP address
un="ubuntu"
ip="52.91.82.150"
key_file="/mridata2/home2/smn33/.ssh/MRCInstance1.pem"

# data folders
local_data_dir='/data15/mri_group/smn33_data/hcp_1200'

local_source_base_dir="$local_data_dir/mnt2"
mounted_source_dir=${target_base_dir}
mounted_archives_dir="${source_base_dir}/archives/"

local_target_archives_dir="$local_data_dir/archives/"
local_target_unzipped_dir="$local_data_dir/matrices/"

