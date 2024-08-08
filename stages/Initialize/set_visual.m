function visual_opt = set_visual()

	%% Current function sets up visual variables (inherit from screen option)
    %   No input arguments.
    %   Output arguments:
    %       1. visual_opts: struct. (depends on v2struct.m)

    %% 0. Color options.
    black = [0, 0, 0];
    grey  = [255, 255, 255]/2;
    white = [255, 255, 255];
	background = [50, 50, 50, 255];		

    %% 1.  Screen Options - Screen profiles
    Screen('Preference', 'SuppressAllWarnings', 1); % Turn off the warnings
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'SkipSyncTests', 1);
    Screen('Preference', 'Verbosity', 0); % Hides Psychtoolbox Warnings
	screen = max( Screen('Screens') );  % select what screen to use 

    [window, windowRect] ...
        = Screen('OpenWindow', screen, 0); % default is black
    refresh_rate = Screen('FrameRate', window);
    [screenXpixels, screenYpixels] ...
        = Screen('WindowSize', window);
	[xCenter, yCenter] ...
        = RectCenter(windowRect);

    %% 3. Screen update timing
    % slight gap (otherwise, frequent message cause frame drops).
    buffer_time  = 1/30;
    one_frame    = 1/59; 

    %% 4. Presentation.
    textSize = 70; % 40
    textStyle = 1; % bold
    fixation_size = 30;
    
    %% misc stimulus positions
    % positions (to be commensurate with set_game)
    n_grid_x = 4; % horizontal
    n_grid_y = 3; % vertical

    pre_x_units = screenXpixels/(n_grid_x+2);
    pre_y_units = screenYpixels/(n_grid_y+2);
    
    feedback_offset = pre_x_units/2; % from center
    
    %% photodiode
    % to code for task stages in photodiode, decrement duration of photodiode stimulus across task stages
    % decrement is intended because cue presentations duration is long and fixed but response epoches are not
    % task stages:
    %     6.feedback (1/30 sec); 
    %     5.response (2/30 sec); 
    %     4."=" (3/30 sec); 
    %     3.delay(4/30 sec); 
    %     2.cue(5/30 sec); 
    %     1.ITI(6/30 sec); 
    
    % spatial for photodiode
    grid_nCols = 12;
    grid_nRows = 6;
    
    x_grid_sel = 1;
    y_grid_sel = 1;
    
    phd_duration_unit = one_frame*2; % 1/30 is unit
    
    % photoD_id_stage will be indexed by stage_idx
    photoD_id_stage = {6;... % 1.ITI(6/30ms)
        [5;4];... % 2/3.cue/delay([5;4]/30ms);
        [3;2];... % 4/5."="/response ([3;2]/30ms);
        1}; % 6.feedback (1/30ms);
    photoD_duration = cellfun(@(x)(x*phd_duration_unit),...
        photoD_id_stage,'UniformOutput',false);
    
    verbose = false; % true; % to check photodiode timing
    timing = struct('present',[],...
        'present_name',[],...
        'choice',[],...
        'choice_name',[],...
        'feedback',[],...
        'feedback_name',[]);
    
    %% make structure
    visual_opt = v2struct;

end