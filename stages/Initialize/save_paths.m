function path_opt = save_paths(ID)
    %% Current function generates saving path and save data.    
	%   Visit Data folders to save/count trial numbers.
    %   This also retrieves the last trial number and re-start from there. 
	curr_dir = fileparts(which(mfilename));
    path_opt.exc_path = curr_dir; % ['../../', curr_dir]; % Execution path.
    exp_dates = datetime('today');
	path_opt.save_data = fullfile(path_opt.exc_path,'../../', ...
        'results/', ID, '/', string(exp_dates));
	if ~exist(path_opt.save_data, 'dir') 
        % If the saving path does not exist.
		mkdir(path_opt.save_data);
        path_opt.curr_trial = 0;
    else
        % Count the number of total trials for the day  
        cd(path_opt.save_data);
        run_files = dir('*NumberEstimate*');
        path_opt.curr_trial = length(run_files);        
	end
    cd(path_opt.exc_path); 
end