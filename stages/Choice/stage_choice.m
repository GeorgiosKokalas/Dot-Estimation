function [resp_time, keysPressed, stage_idx] = stage_choice(...
                            visual_opt, game_opt, device_opt, curr_opt)
    
    visual_opt.choice_t1 = GetSecs();
                        
    %% present "=" at the screen center 
    curr_str='='; 
    curr_pos = [visual_opt.xCenter, visual_opt.yCenter];
        
    % photodiode on
    photoD_on = true;
    present_without_flip(visual_opt,curr_str,curr_pos, photoD_on);
    t_phd_on = Screen('Flip', visual_opt.window);        
    visual_opt=save_timing(visual_opt, 'choice' ); % to check photodiode timing
    
    % prepare for photodiode off
    photoD_on = false;
    stage_idx = 2; % current stage
    substage_idx = 1;
    phd_duration =visual_opt.photoD_duration{stage_idx+1}(substage_idx); % last index for '='
    t_phd_off = t_phd_on + phd_duration;
    present_without_flip(visual_opt,curr_str,curr_pos, photoD_on);

    %% Check whether enter key is pushed
    % with photodiode off prepared
    [keysPressed,visual_opt] = check_keys(device_opt, t_phd_off,visual_opt);

    %% Record response profiles once they press the Return key
    response_str = cell2mat(keysPressed.names);
    response_pos = [visual_opt.xCenter, visual_opt.yCenter];    
    resp_time = keysPressed.times-t_phd_on;
    %     disp('--------------------------------');
    %     disp(['Subject pressed: ', response_str]); % Display which key was pressed
    fprintf( 'Response t: %4.2d \n', resp_time);
    %     disp('--------------------------------');
    
    %% Stage change
    stage_idx = 3; % feedback
end

function visual_opt=save_timing(visual_opt,name)
% to check photodiode timing
if visual_opt.verbose
    visual_opt.timing.choice=[visual_opt.timing.choice;...
        GetSecs()-visual_opt.choice_t1];
    visual_opt.timing.choice_name=[visual_opt.timing.choice_name;...
        {name}];
    
    disp([name ': ' num2str(visual_opt.timing.choice(end))]);
end

end