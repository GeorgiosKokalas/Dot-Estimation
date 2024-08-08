function device_opt = set_device()

    %% Current function sets device options.
    %   Input arguments are required.
    %   Output: 
    %       device_opts: struct. variables related to joystick and
    %       keyboards.
	
    %%	1. KEYBOARD INPUTS 
    %   make sure the correct keys are being used (Mac vs. Windows)
    KbName('UnifyKeyNames');
    stopkey	= KbName('x');
    pause	= KbName('LeftArrow');
    gokey	= KbName('RightArrow');
    confirm  = KbName('Return');
    confirm2  = KbName('space');
    abort	= KbName('ESCAPE');
    
    one = KbName('1!');
    two = KbName('2@');
    three = KbName('3#');
    four = KbName('4$');
    five = KbName('5%');
    six = KbName('6^');
    seven = KbName('7&');
    eight = KbName('8*');
    nine = KbName('9(');
    zero = KbName('0)');
    
    minus = KbName('-_');
    plus = KbName('=+');
    
    key_interval = 1/20; % 50ms; Small delay to avoid high-speed key register

	%%	2. JOYSTICK INPUTS
    % Note from SBMY) George, we need to fix this
    
    %% make structure
    device_opt = v2struct;
end