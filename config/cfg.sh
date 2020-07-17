## For getting and preparing data on remote

# scan info
task=('REST' 'LANGUAGE' 'EMOTION') # Options: ('REST' 'REST2' 'LANGUAGE' 'EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM' 'RELATIONAL')
encoding=('LR' 'RL') # Options: ('LR' 'RL')
search_str="_GSR_matrix"

# paths
bucket_key="/mridata2/home2/smn33/scripts/hcp_aws_tools/aws_config_files/s3cmd_saved_configs/yale_bucket_access"
s3cmd="/mridata2/home2/smn33/scripts/s3cmd-2.0.2/s3cmd"
source_base_dir="s3://hcpoutput/S1200/Shen268"
target_base_dir="/data15/mri_group/smn33_data/hcp_1200/matrices"

# misc
subIDs_prefix='_subIDs.txt'
