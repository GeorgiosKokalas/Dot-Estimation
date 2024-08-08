function stage_idx = save_data(stims, keyProfile, times, ID, path_opt,device_opt)
   
    %% Current function is to save the file. 
    %   What to save?
    %       1) Stimuli information.
    %           a) presentation type, b) operation type, c) presentation
    %           sequence, d) presentation location
    %       2) All pressed keys and its time.
    %       3) Stage index: check whether it was valid trial or not. 
    
    %% Keep time if trials are aborted
    if strcmp(keyProfile.names(end), device_opt.abort)
        stage_idx = 21; % Terminate session
        times.exp_end_t = GetSecs( );
    else
        stage_idx = 0; % Determine option.
    end

    %% Define file relevant names
    %   Note) Need to add the function prevent override. 
    cd(path_opt.save_data);
    save_filename = sprintf('NumberEstimate_%s_%04d', ID, path_opt.curr_trial); 
    save_vars.stims = stims;
	save_vars.keys = keyProfile;
    save_vars.times = times;
    save(save_filename, 'save_vars');
	cd(path_opt.exc_path);

end