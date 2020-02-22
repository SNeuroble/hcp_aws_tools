function average_RL_LR(data_dir,task_list,scan_type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Combines RL and LR data; designed for HCP - modified slightly for octave
% e.g., average_RL_LR('/data15/mri_group/smn33_data/hcp_1200/matrices/',{'REST' 'LANGUAGE'},'_GSR_matrix.txt')
%tasks=('EMOTION' 'GAMBLING' 'SOCIAL' 'MOTOR' 'WM' 'LANGUAGE' 'REST')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%pkg load io % for cell2csv, or use attached function from Sylvain Fiedler
page_screen_output (0); % print
subIDs_suffix='_subIDs.txt';

for j=1:length(task_list)

    %% Compare IDs (thanks https://www.mathworks.com/matlabcentral/answers/358722-how-to-compare-words-from-two-text-files-and-get-output-as-number-of-matching-words)
   
    task=task_list{j};
    fprintf('\n* Averaging task %s *\n',task);

    % get IDs
    RL_scan=[task,'_RL'];
    LR_scan=[task,'_RL'];

    RL_subIDs_file=[data_dir,RL_scan,subIDs_suffix]
    LR_subIDs_file=[data_dir,LR_scan,subIDs_suffix];

    RL_subIDs=fileread(RL_subIDs_file);
    LR_subIDs=fileread(LR_subIDs_file);

    RL_subIDs=strsplit(RL_subIDs,'\n');
    LR_subIDs=strsplit(LR_subIDs,'\n');

    % compare RL and LR
    fprintf(['Comparing subject IDs from from RL (',RL_subIDs_file,') with IDs from LR (',LR_subIDs_file,').\n']);
    [subIDs_intersect,~,~]=intersect(RL_subIDs,LR_subIDs);
    if strcmp(subIDs_intersect(1),'');
    subIDs_intersect=subIDs_intersect(2:end); % bc the first find is empty - TODO add a check here first
    end
    cell2csv([data_dir,task,subIDs_suffix],subIDs_intersect'); 
    
    %% Average data
    
    n_subs=length(subIDs_intersect);
    fprintf('Averaging data for %d subjects. Progress:\n',n_subs);
    mkdir([data_dir,task]);

    for i = 1:n_subs
        this_file_RL = [data_dir,RL_scan,'/',subIDs_intersect{i},'_',RL_scan,scan_type];
        this_file_LR = [data_dir,LR_scan,'/',subIDs_intersect{i},'_',LR_scan,scan_type];
        data_RL = importdata(this_file_RL);
        data_LR = importdata(this_file_LR);
        data_avg=(data_RL+data_LR)/2;

        % data has whitespace at the end that is sometimes read as NAN, so remove those nans
        if all(isnan(data_RL(:,end)))
            data_RL(:,end)=[];
        end
        if all(isnan(data_LR(:,end)))
            data_LR(:,end)=[];
        end

        data_avg=(data_RL+data_LR)/2;

        this_file_avg = [data_dir,task,'/',subIDs_intersect{i},'_',task,'_GSR_matrix.txt'];
        dlmwrite(this_file_avg, data_avg,'\t',"precision",6)

        % print every 50 subs (->loaded 50 x 2 encoding dirs)
        if mod(i,50)==0; fprintf('%d/%d  (x2 LRs)\n',i,n_subs); end
        end
    end
end

