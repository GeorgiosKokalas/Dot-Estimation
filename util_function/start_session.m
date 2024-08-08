function [session_onset, onset_time] = start_session(visual_opt, device_opt, ...
    game_opt)
    % waitForRightArrow Waits for the 'RightArrow' key press to start the session
    %
    % Usage:
    %   session_onset = waitForRightArrow(window)
    %
    % Parameters:
    %   window: Psychtoolbox window pointer
    %
    % Returns:
    %   session_onset: Time of the session onset, triggered by RightArrow key
    
    % Initialize KbCheck and variables
    keyIsDown = 0;
    
    % Display waiting message (optional)
    DrawFormattedText(visual_opt.window, 'Press the Right Arrow to begin.', ...
        'center', 'center', visual_opt.white);
    Screen('Flip', visual_opt.window);
    
    % Wait for Right Arrow key press
    while ~keyIsDown
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown
            if keyCode(device_opt.gokey)
                session_onset = true;  % Record the time of the Right Arrow key press
                onset_time = secs;
                break;  % Exit the loop
            else
                keyIsDown = 0;  % Reset if other key was pressed
            end
        end
    end
    
    % Confirm the session start (optional)
    DrawFormattedText(visual_opt.window, 'Session started.', ...
        'center', 'center', visual_opt.white);
    Screen('Flip', visual_opt.window);
    WaitSecs(game_opt.t_start_text);  % Display confirmation for 2 seconds
end