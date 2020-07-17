function average_RL_LR(data_dir,tasks,scan_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Combines RL and LR data; designed for HCP
% e.g., average_RL_LR('/data15/mri_group/smn33_data/hcp_1200/matrices/',{'REST' 'LANGUAGE'},'_GSR_matrix.txt')
%tasks=('EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM' 'LANGUAGE' 'REST')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

for this_task=tasks

    %% Compare IDs (thanks https://www.mathworks.com/matlabcentral/answers/358722-how-to-compare-words-from-two-text-files-and-get-output-as-number-of-matching-words)
    
    % get IDs
    RL_scan=[this_task,'_RL'];
    LR_scan=[this_task,'_LR'];

    RL_subIDs_file=[data_dir,RL_scan,'_subIDs.txt'];
    LR_subIDs_file=[data_dir,LR_scan,'_subIDs.txt'];

    RL_subIDs=fileread(RL_subIDs_file);
    LR_subIDs=fileread(LR_subIDs_file);

    RL_subIDs=strsplit(RL_subIDs,newline);
    LR_subIDs=strsplit(LR_subIDs,newline);

    % compare RL and LR
    fprintf(['Comparing subject IDs from from RL (',RL_subIDs_file,') with IDs from LR (',LR_subIDs_file,').\n']);
    [subIDs_intersect,~,~]=intersect(RL_subIDs,LR_subIDs);
    subIDs_intersect=subIDs_intersect(2:end); % bc the first find is empty - TODO add a check here first
    n_subs=length(subIDs_intersect);

    %% Average data

    fprintf('Averaging data for %d subjects. Progress:\n',n_subs);
    mkdir([data_dir,this_task])

    % for i = 1:n_subs
    for i = 1:2
        this_file_RL = [data_dir,RL_scan,'/',subIDs_intersect{i},'_',RL_scan,scan_type];
        this_file_LR = [data_dir,LR_scan,'/',subIDs_intersect{i},'_',LR_scan,scan_type];
        data_RL = importdata(this_file_RL);
        data_LR = importdata(this_file_LR);
        data_avg=(data_RL+data_LR)/2;

        this_file_avg = [data_dir,this_task,'/',subIDs_intersect{i},'_',this_task,'_GSR_matrix.txt'];
        writematrix(this_file_avg, data_avg)

        % print every 50 subs (->loaded 50 x 2 encoding dirs)
        if mod(i,50)==0; fprintf('%d/%d  (x2 LRs)\n',i,n_subs); end
        end
    end
end

