function [device_opt] = setup_variables( )

    %% DEAD CODE.
	global game_opt visual_opt temporal_opt color_opt
	
	% Screen Options - Screen profiles
    %   Turn off the warnings
    Screen('Preference', 'SuppressAllWarnings', 1);
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'Verbosity', 0);       % Hides Psychtoolbox Warnings
	screens             = Screen( 'Screens' );  % Initialize the Screen
	visual_opt.screen   = min( screens );       % select what screen to use (not needed when using Eyelink)

    [ visual_opt.window, visual_opt.windowRect ]            = Screen( 'OpenWindow', visual_opt.screen, [50, 50, 50], [0, 0, 400, 400], [], [], [], 1 );
    [ visual_opt.screenXpixels, visual_opt.screenYpixels ]  = Screen( 'WindowSize', visual_opt.window );
	[ visual_opt.xCenter, visual_opt.yCenter ]              = RectCenter( visual_opt.windowRect );
    
	%% Device options
	%	1. KEYBOARD INPUTS ( make sure the correct names for keys are being used (Mac vs. Windows) )
    KbName( 'UnifyKeyNames' );
    device_opt.stopkey	= KbName('ESCAPE');
    device_opt.pause	= KbName('LeftArrow');
    device_opt.juicem	= KbName('r');
    device_opt.abort	= KbName('x');
    device_opt.gokey	= KbName( 'RightArrow' );
    device_opt.nokey	= KbName( 'ESCAPE' );
    device_opt.fixation_remove_key = KbName( 'LEFTARROW' );
    
	%	2. JOYSTICK INPUTS
    device_opt.os = 'mac';
    if strcmp(device_opt.os, 'Windows64' )
        device_opt.joystick_id = 0;
        JoyMEX('init',device_opt.joystick_id);
    end
	device_opt.joystickThreshold = 0.05; %threshold for determining when the joystick has moved
	device_opt.max_val = 1.0009;
	device_opt.Xmultiplicative_factor_joy = visual_opt.screenXpixels/device_opt.max_val;
	device_opt.Ymultiplicative_factor_joy = visual_opt.screenYpixels/device_opt.max_val;
	
	%	3. DEVICE TIMING RELATED VALUES
    device_opt.buffer_time  = 1/30;
    device_opt.one_frame    = 1/58; % slight gap (otherwise, it prints out too many message and slows down).
    
	%% Temporal parameters
    temporal_opt.ITI	 = 1.5; % Length of ITI
    temporal_opt.timeout = 20;	% trial times out after this much time has passed with no movement
    game_opt.stairopt	 = 3;	% How many time-outs causes stair changes)( if setting as 1, every wrong time-out causes stair changes )
	
	%% game_opt deals with independent variable that we can change within the task
    % static variables; should remain the same across trials (at least within session) shared game parameters
	% -- Task 1 (one prey)
	game_opt.dist_criteria		= 400; % Initial minimum distance between subject and all agents (in pixel units)
    game_opt.preyValue          = round( [ .35, .45, .55 .65, .75 ].*(3/5) , 2 ); % Reward duration
	game_opt.predatorValue      = [ 2, 4, 6, 8, 10 ]; % Time out punishment 
	game_opt.reward_steps       = numel( game_opt.preyValue );
	
	% Parameters that decide number of prey and predator
	game_opt.numPlayer = 1;

	%% Color_opt for agents and the walls
    color_opt.black     = [0, 0, 0];
    color_opt.grey      = [255, 255, 255]/2;
	color_opt.time_bar  = [255, 255, 255];
	
	color_opt.background = [ 50, 50, 50 ];
	color_opt.player	 = [ 255 248 10 ];  % player color
    color_opt.prey		 = [ 255, 125, 0;  0, 0, 255; 0, 255, 0; 255, 0, 255; 0, 255, 255 ]; % Remove Yellow 
    color_opt.predator	 = [ 255, 255, 255;  216, 200, 135;  120, 206, 158; 185, 83, 15; 255, 0, 0 ];
    color_opt.zoneWall	 = color_opt.black; % wall color
    
    %% VISUAL VARIABLES
	visual_opt.num_vert		 = 64;
    visual_opt.playerWidth	 = 30;                      % player width (radius)
    visual_opt.playerHeight  = visual_opt.playerWidth;  % player height (radius)
    visual_opt.npcWidth		 = visual_opt.playerWidth;  % npc width (half the vertice)
    visual_opt.npcHeight	 = visual_opt.npcWidth;     % npc height
    visual_opt.NPC_unit_size = 1;
	visual_opt.spare_size	 = 5;
 	game_opt.NPC_size        = visual_opt.npcWidth + visual_opt.spare_size;
	game_opt.overlap_cri     = game_opt.NPC_size;   
    
    % Visual Options - time_bar appearance when he get caught
    visual_opt.bar_height	 = 200;
    visual_opt.max_bar_width = visual_opt.screenXpixels;
    
    % Visual Options - corners saved for movement checks
    visual_opt.wallThickness = 10; % Wall thickness
    visual_opt.corners = [ visual_opt.windowRect(1) + visual_opt.wallThickness + visual_opt.npcWidth, visual_opt.windowRect(2) + visual_opt.wallThickness + visual_opt.npcWidth; ...
		visual_opt.windowRect(1) + visual_opt.wallThickness + visual_opt.npcWidth, visual_opt.windowRect(4) - visual_opt.wallThickness - visual_opt.npcWidth; ...
		visual_opt.windowRect(3) - visual_opt.wallThickness - visual_opt.npcWidth, visual_opt.windowRect(2) + visual_opt.wallThickness + visual_opt.npcWidth; ...
		visual_opt.windowRect(3) - visual_opt.wallThickness - visual_opt.npcWidth, visual_opt.windowRect(4) - visual_opt.wallThickness - visual_opt.npcWidth ];
	visual_opt.limit = visual_opt.playerWidth + visual_opt.wallThickness;
	
	visual_opt.virtual_corners = [ visual_opt.windowRect(3)/4, visual_opt.windowRect(4)/4 ; ...
		visual_opt.windowRect(3)/4, visual_opt.windowRect(4)*(3/4);...
		visual_opt.windowRect(3)*(3/4), visual_opt.windowRect(4)/4;...
		visual_opt.windowRect(3)*(3/4), visual_opt.windowRect(4)*(3/4)]; 

	visual_opt.x_ref1	 = visual_opt.windowRect(1)  + visual_opt.wallThickness + 2*game_opt.NPC_size;
	visual_opt.x_ref2	 = visual_opt.windowRect(3)  - visual_opt.wallThickness - 2*game_opt.NPC_size;
	visual_opt.y_ref1	 = visual_opt.windowRect(2)  + visual_opt.wallThickness + 2*game_opt.NPC_size;
	visual_opt.y_ref2	 = visual_opt.windowRect(4)  - visual_opt.wallThickness - 2*game_opt.NPC_size;	

    % Basic Arena Configuration
    visual_opt.northWall	= [ visual_opt.windowRect(1), visual_opt.windowRect(2), visual_opt.windowRect(3), visual_opt.windowRect(2) + visual_opt.wallThickness  ];
    visual_opt.southWall	= [ visual_opt.windowRect(1), visual_opt.windowRect(4) - visual_opt.wallThickness , visual_opt.windowRect(3), visual_opt.windowRect(4) ];
    visual_opt.westWall		= [ visual_opt.windowRect(1), visual_opt.windowRect(2), visual_opt.windowRect(1) + visual_opt.wallThickness , visual_opt.windowRect(4) ];
    visual_opt.eastWall		= [ visual_opt.windowRect(3) - visual_opt.wallThickness , visual_opt.windowRect(2), visual_opt.windowRect(3), visual_opt.windowRect(4) ];

    % storing all the walls above in one array for easier drawing
    visual_opt.boundaries = [ visual_opt.northWall; visual_opt.southWall; visual_opt.eastWall; visual_opt.westWall];
end