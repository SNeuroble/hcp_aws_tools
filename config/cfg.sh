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
target_base_dir="/home/$username/data/matrices"
archives_dir="$local_target_archives_dir/archives/"

encoding=('LR' 'RL')
subIDs_prefix='_subIDs.txt'

## For copying remote to local

# latest instance IP address
un="ec2-user"
ip="18.206.222.203"
key_file="/mridata2/home2/smn33/.ssh/MRCInstance1.pem"

# data folders
mounted_source_dir=${target_base_dir}
mounted_archives_dir="${source_base_dir}/archives/"

local_source_base_dir="${local_target_archives_dir}mnt2"
local_target_archives_dir='/data15/mri_group/smn33_data/hcp_1200/archives/';
local_target_unzipped_dir='/data15/mri_group/smn33_data/hcp_1200/matrices/';


