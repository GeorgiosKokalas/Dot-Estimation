function main(varargin)
	
    %%	Number Estimation.
% - Each trial, the computer select a number {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15} and present the dot stimuli for 1500ms.
% - Subjects type a number using keyboard and press enter/space to get either
%   “correct” or “incorrect” feedback (500ms), ITI of 500 ms
% - time course of a trial [ms]: 1500 dot, 500 delay, response (prompted by "="), 500 feedback, 500 ITI (with fixation mark)
    
    %% TODO
    % for George
    %  1. blackrock strobe / event-msg?
    %  2. Connect eye-tracker
    % for Hansem
    % - separate fixation/memory delay stage
    
    %% notes for discussion
    
%%
    % Create an event that we started
    eventLog = {'Experiment Start', GetSecs()};
    
    close all; clc;
    set_default_paths();
    [ExpEnv, ID] = check_inputs(varargin);

    % Adjust for experimental environment
    switch ExpEnv
        case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
            try
                [EMUnum,ID] = getNextLogEntry(); % not exist
                saveFileName = sprintf('EMU-%0.4d_subj-%s_Arithmetic-Task', EMUnum, ID);
                onlineNSP = TaskComment('start', saveFileName);
            catch ME
                disp(ME)
                ID = 'EMUtest';
            end
    end


    %% Initialize
    % autoclear(); % not exist
    verbose = false; % true; % false; % Mostly for debugging
    [visual_opt,device_opt, game_opt, path_opt] = stage_initialize(ID);
    
    %% Task starts
    if verbose
        session_onset=true;
    else
        disp('Right Arrow to start | Escape to Exit');
        [session_onset, times.key_press_t] = ...
            start_session(visual_opt, device_opt, game_opt);
    end
    
    %% Main while loop running controlling the experiment
    stage_idx = 0;
    times.exp_start_t = GetSecs();
    save_duration=0;
    while(session_onset)
        switch stage_idx
            
            case -1 
                %% Saving stage (Part 1 of ITI)
                % Generate a Log
                times.save_start_t = GetSecs();
                logMsg = sprintf('Trial %d Save Start', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 16777060, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end

                % Conduct ITI
                present_ITI(visual_opt); % only photodiode
                stage_idx = save_data(curr_opt, keyProfile, times, ID, path_opt,device_opt);
		
                % Generate an end log
                logMsg = sprintf('Trial %d Save End', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 16777060, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
                save_duration = GetSecs()-times.save_start_t; % saving time
                
            case 0 
                %% Preparing next trials (Part 2 of ITI)
                % Generate a start log
                times.ITI_start_t = GetSecs();
                logMsg = sprintf('Trial %d ITI Start', path_opt.curr_trial + 1);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 16777215, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end

                % Add number of trials.
                path_opt.curr_trial	= path_opt.curr_trial + 1;
                stopExp = false;
                if path_opt.curr_trial > game_opt.sess_trs           
                    stopExp = true; % Session ends
                end
                disp('--------------------------------');
                fprintf( 'Trial: %4.0d \n', path_opt.curr_trial);
    
                % Preparing next trials
                [curr_opt, stage_idx] = stage_ITI(game_opt);
                
                if stopExp; stage_idx = 21; end
    
                % Time control.
                align_time(times.ITI_start_t, ...
                    game_opt.ITI_duration-save_duration, ...
                    game_opt.t_resolution)
                
		% Generate an end log
                logMsg = sprintf('Trial %d ITI End', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 16777215, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
                times.ITI_end_t = GetSecs();
                times.ITI_len = times.ITI_end_t-times.ITI_start_t;
    
                if verbose
                    if times.ITI_len > game_opt.ITI_duration + visual_opt.refresh_rate
                        fprintf( 'ITI time: %4.2d \n', times.ITI_len);
                    end
                end
                
            case 1 
                %% Presentation step
                % Generate a start log
                times.present_start_t = GetSecs();
                logMsg = sprintf('Trial %d Presentation Start', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 65535, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
		
                stage_idx = stage_present(visual_opt, game_opt, curr_opt);

   		% Generate an end log
                logMsg = sprintf('Trial %d Presentation End', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 65535, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
    		
                % Time control.
                times.present_end_t = GetSecs();
                times.present_len = times.present_end_t - times.present_start_t;
    
                if verbose
                    if times.present_len > game_opt.stim_present_total + visual_opt.refresh_rate
                        fprintf( 'presentation time: %4.2d \n', times.present_len);
                    end
                end
            
            case 2 
                %% Choice step
                % Generate a start log
                times.choice_start_t = GetSecs();
                logMsg = sprintf('Trial %d Choice Start', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 9830655, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
		
                [times.RT, keyProfile, stage_idx] = stage_choice(...
                    visual_opt, game_opt, device_opt, curr_opt);
                
		% Generate an end log
                logMsg = sprintf('Trial %d Choice End', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 9830655, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
                times.choice_end_t = GetSecs();
                
            case 3
                %% feedback
                % Generate a Start Log
                times.feedback_start_t = GetSecs();
                logMsg = sprintf('Trial %d Feedback Start', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 16750080, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
		
                [curr_opt, game_opt, stage_idx] = stage_feedback(...
                    visual_opt, game_opt, device_opt, curr_opt,keyProfile);
                
                % Generate an end log 
                logMsg = sprintf('Trial %d Feedback End', path_opt.curr_trial);
                eventLog = [eventLog; {logMsg, GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         for i=1:numel(onlineNSP); cbmex('comment', 16750080, 0, logMsg,'instance',onlineNSP(i)-1); end
                        catch ME;   disp(ME);
                        end
                end
                times.feedback_end_t = GetSecs();
                
            case 21 
                %% Either abort or end
                times.exp_end_t = GetSecs( );
                if isequal(keyProfile.names{end}, device_opt.abort)
                    end_str = 'Trials aborted!';
                    commentType = 'kill';
                else
                    end_str = 'Thank you!';
                    commentType = 'stop';
                end
                displayText(visual_opt.window, end_str, ...
                    [visual_opt.xCenter, visual_opt.yCenter], ...
                    visual_opt.white);
                times.exp_dur = times.exp_end_t - times.exp_start_t;
                fprintf( 'experiment duration: %4.2d \n', times.exp_dur);
                disp( '------------------------' );

  		% Generate ending events
                eventLog = [eventLog;{['Experiment ', commentType], GetSecs()}];
                switch ExpEnv
                    case 'emu'     % If we set the EMU as the exprimental environment, get the EMU number
                        try         TaskComment(commentType, saveFileName);
                        catch ME;   disp(ME);
                        end
                end
  
                session_onset = false; %#ok<NASGU>
                break;
        end
    end

    save(fullfile(path_opt.save_data, 'events.mat'), "eventLog");
    
    %% Clear the screen and reset
	sca;
	Priority(0);
end


%% change log
% Hansem @ 2024/8/5
%     - 1st version
