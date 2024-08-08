function [curr_opt, stage_idx] = stage_ITI(game_opt)
    
    %% Perform operations that is required to be done during ITI.
    
    %% 1. Determine the option for the trial t. 
    curr_opt = determine_options(game_opt);

    stage_idx = 1; % Presentation step
end