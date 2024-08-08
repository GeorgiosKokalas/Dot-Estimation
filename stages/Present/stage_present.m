function stage_idx = stage_present(visual_opt, game_opt, curr_opt)

    %% Present the option
    present_on_t1 = GetSecs();
    
    % Organize the position information
    curr_pos = [visual_opt.xCenter, visual_opt.yCenter];
    
    % set photodiode duration
    stage_idx = 1; % current stage
    substage_idx = 1;
    phd_duration =visual_opt.photoD_duration{stage_idx+1}(substage_idx);
    
    % Present option
    present_on_t =  GetSecs();
    photoD_on = true; % photodiode on
    present_opt(visual_opt, game_opt, curr_opt.strs, curr_pos, photoD_on);
    visual_opt=save_timing(visual_opt,present_on_t1,['dot on']); % to check photodiode timing
    
    % photodiode off
    while GetSecs()-present_on_t < phd_duration
    end
    photoD_on = false; % photodiode off
    present_opt(visual_opt, game_opt, curr_opt.strs, curr_pos, photoD_on);
    visual_opt=save_timing(visual_opt,present_on_t1,['phd_off']); % to check photodiode timing
    
    % Align time
    align_time(present_on_t, game_opt.stim_present, ...
        game_opt.t_resolution);
    visual_opt=save_timing(visual_opt,present_on_t1,['off']); % to check photodiode timing
   
    
    %% delay
    % set photodiode duration
    stage_idx = 1; % current stage
    substage_idx = 2;
    phd_duration =visual_opt.photoD_duration{stage_idx+1}(substage_idx);
        
    % photodiode on
    delay_on_t =  GetSecs();
    present_photodiode(visual_opt,phd_duration)
    
    % Align time
    align_time(delay_on_t, game_opt.delay, ...
        game_opt.t_resolution);
    
    % Stage update
    stage_idx = 2;
end

function visual_opt=save_timing(visual_opt,present_on_t1,name)
% to check photodiode timing
if visual_opt.verbose
    visual_opt.timing.present=[visual_opt.timing.present;...
        GetSecs()-present_on_t1];
    visual_opt.timing.present_name=[visual_opt.timing.present_name;...
        {name}];
    
    disp([name ': ' num2str(visual_opt.timing.present(end))]);
end

end