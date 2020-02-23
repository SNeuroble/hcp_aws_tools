# Overview

For preparing data from Yale bucket for averaging/copying.

1,3, and 4 take the config file in config/ as input.

1. get_data_from_bucket.sh <cfg.sh>
2. average_RL_LR.m or average_RL_LR__octave.m
3. prepare_remote_for_copy.sh <cfg.sh>
4. on local: copy_remote_to_local.sh <cfg.sh>
