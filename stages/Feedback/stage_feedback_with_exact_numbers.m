function [id_correct, stage_idx] = stage_feedback(...
                            visual_opt, game_opt, device_opt, curr_opt,keyProfile)
                        
    visual_opt.feedback_t1 = GetSecs();
    
    %% decide correct vs incorrect
    %   get correct answer
    target_num_str=num2str(curr_opt.target_num);
    fprintf('target number is: %3.1d \n', curr_opt.target_num);
    
    % use string match to decide correctness
    % note: this can be useful when subjects accidentally press a wrong key
    % (correct as long as subject put a correct digits in a sequence e.g., '312' or '123' for target 12)
    response_str = cell2mat(keyProfile.names);
    disp(['response number is : ' response_str]);
    if ~isempty(response_str)
        id_correct = regexp(response_str,target_num_str,'ONCE');
    else
        id_correct = false;
    end
    
    if isempty(id_correct)
        id_correct = false; 
    else
        id_correct = true; 
    end
    
    % set up color
    if id_correct
        textcolor = [0,255,0]; 
    else
        textcolor = [255,0,0];
    end
                     
    %% present "=" at the screen center (correct: green, incorrect: red)
    % =
    curr_str='=';
    curr_pos = [visual_opt.xCenter, visual_opt.yCenter];
    photoD_on = true;
    present_without_flip(visual_opt,curr_str,curr_pos,photoD_on, textcolor);
    % response
    response_pos = [visual_opt.xCenter+game_opt.feedback_offset, visual_opt.yCenter]; %  show subjects' response on the right
    present_without_flip(visual_opt,response_str,response_pos,photoD_on, textcolor); 
    % target number
    target_pos = [visual_opt.xCenter-game_opt.feedback_offset, visual_opt.yCenter]; % with target number on the left
    present_without_flip(visual_opt,target_num_str,target_pos,photoD_on, textcolor);
    t_present=Screen('Flip', visual_opt.window);
   
    Screen('Flip', visual_opt.window,0); % 0 for when
    visual_opt=save_timing(visual_opt,'feedback'); % to check photodiode timing
    
    % photodiode off
    photoD_on = false;
    stage_idx = 3; % current stage
    phd_duration =visual_opt.photoD_duration{stage_idx+1};
    t_phd_off = t_present + phd_duration;
    
    present_without_flip(visual_opt,curr_str,curr_pos,photoD_on, textcolor); % =
    present_without_flip(visual_opt,response_str,response_pos,photoD_on, textcolor); % response
    present_without_flip(visual_opt,target_num_str,target_pos,photoD_on, textcolor); % target
    
    Screen('Flip', visual_opt.window, t_phd_off);
    visual_opt=save_timing(visual_opt,'feedback_phd_off'); % to check photodiode timing
    
    % aligntime
    align_time(t_present, game_opt.feedback_duration, ...
        game_opt.t_resolution);
    
   visual_opt=save_timing(visual_opt,'feedback_done'); % to check photodiode timing
   
    %% Stage change
    stage_idx = -1; % To saving stage
end

function visual_opt=save_timing(visual_opt,name)
% to check photodiode timing
if visual_opt.verbose
    visual_opt.timing.feedback=[visual_opt.timing.feedback;...
        GetSecs()-visual_opt.feedback_t1];
    visual_opt.timing.feedback_name=[visual_opt.timing.feedback_name;...
        {name}];
    
    disp([name ': ' num2str(visual_opt.timing.feedback(end))]);
end

end