function [curr_opt, game_opt, stage_idx] = stage_feedback(...
                            visual_opt, game_opt, device_opt, curr_opt,keyProfile)
                        
    visual_opt.feedback_t1 = GetSecs();
    form = curr_opt.curr_format;
    
    %% decide correct vs incorrect
    %   get correct answer
    target_num_str=num2str(curr_opt.target_num);
    target_num = str2num(target_num_str);
    fprintf('target number is: %3.1d \n', curr_opt.target_num);
    
    % process response
    response_str = cell2mat(keyProfile.names);
    disp(['response number is : ' response_str]);
    response_num = str2num(response_str);
    
    % decide correct vs incorrect
    error = abs(target_num-response_num);
    if error <= game_opt.(['correct_range_' form])
        id_correct =true;
    else
        id_correct = false;
    end
        
    % update error threshold staircase
    if id_correct
        game_opt.(['correct_range_' form]) = ...
            game_opt.(['correct_range_' form]) - game_opt.(['down_correct_' form]);
    else
        game_opt.(['correct_range_' form]) = ...
            game_opt.(['correct_range_' form]) + game_opt.(['up_error_' form]);
    end
        
    % set up color
    if id_correct
        textcolor = [0,255,0]; 
    else
        textcolor = [255,0,0];
    end
    
    % save in game_opt for staircase
    curr_opt.id_correct = id_correct;
    game_opt.(['n_correct_' form]) = game_opt.(['n_correct_' form]) + id_correct;
    game_opt.(['n_' form]) = game_opt.(['n_' form]) + id_correct;
                     
    %% turn response into green if correct, red if incorrect
    photoD_on = true;
    response_pos = [visual_opt.xCenter, visual_opt.yCenter]; %  show subjects' response 
    present_without_flip(visual_opt,response_str,response_pos,photoD_on, textcolor); 
    t_present=Screen('Flip', visual_opt.window);
    visual_opt=save_timing(visual_opt,'feedback'); % to check photodiode timing
    
    % photodiode off
    photoD_on = false;
    stage_idx = 3; % current stage
    phd_duration =visual_opt.photoD_duration{stage_idx+1};
    t_phd_off = t_present + phd_duration;
    present_without_flip(visual_opt,response_str,response_pos,photoD_on, textcolor); % response
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