function [keysPressed,visual_opt] = check_keys(device_opt,varargin)

    % Loop until 'Enter' is pressed
    % varargin for photodiode off
    
%%

% init
exit_key = false;
keysPressed.names = [];
keysPressed.times = [];
id_first_touch = true;

% need for screen update
if ~isempty(varargin)
    t_flip=varargin{1};
    visual_opt=varargin{2};
    w=visual_opt.window;
    flag_flip=true;
end

% to deal with continous key press (save previous_keyCode)
[keyIsDown, secs, previous_keyCode] = KbCheck; % if 1 time, take a long time (700ms)

%% main
while ~exit_key
    [keyIsDown, secs, keyCode] = KbCheck;
    
    if keyIsDown
        % exit with Return(space)/Escape
        if any(keyCode(device_opt.confirm)) || ... % strcmp(keyName, device_opt.confirm) || ... % enter
                any(keyCode(device_opt.confirm2)) || ... % space
                keyCode(device_opt.abort) % strcmp(keyName, device_opt.abort)
            exit_key = true;
            break; % now not saving 'return'
        end
        
        % Store only the newly pressed key.
        keyCode_newPress = keyCode-previous_keyCode == 1;
        if any(keyCode_newPress)
            keysPressed.times = [keysPressed.times, secs];
            
            keyName = KbName(keyCode_newPress);
            keyName=remove_string(keyName); % remove extra string for number key presses
            keysPressed.names = [keysPressed.names, {keyName}];
            
            % photodiode for each touch for now
            %                 if id_first_touch
            visual_opt=present_photodiode(visual_opt,keysPressed.names);
            %                     id_first_touch = false;
            %                 end
        end
        
        % Small delay t==o avoid high-speed key register (now 50ms)
        WaitSecs(device_opt.key_interval);
    end % keyIsDown
    previous_keyCode = keyCode;
    
    % screen update if needed - photodiode off
    % this will happen one-time right at the beginning of choice period (stay for 100ms)
    if ~isempty(varargin)
        if flag_flip
            Screen('Flip', w, t_flip);
            visual_opt=save_timing(visual_opt, 'choice_phd_off' ); % to check photodiode timing
            flag_flip = false;
        end
    end
    
end

    % Re-enable keyboard output to MATLAB:
    ListenChar(0);
end

%% 
function visual_opt=present_photodiode(visual_opt,keyName)

    if iscell(keyName), keyName=cell2mat(keyName); end % deal with exception: convert to string
    response_pos = [visual_opt.xCenter, visual_opt.yCenter]; 

    % photodiode on
    photoD_on = true;
    present_without_flip(visual_opt,keyName,response_pos, photoD_on); % response
    t_phd_on = Screen('Flip', visual_opt.window);    
    
    visual_opt=save_timing(visual_opt,'press'); % to check photodiode timing
    
    % prepare for photodiode off
    photoD_on = false;
    stage_idx = 2; % current stage
    substage_idx = 2;
    phd_duration =visual_opt.photoD_duration{stage_idx+1}(substage_idx); % last index for response; 1st for '='
    t_phd_off = t_phd_on + phd_duration;
    present_without_flip(visual_opt,keyName,response_pos, photoD_on); % response
    Screen('Flip', visual_opt.window,t_phd_off);        

    visual_opt=save_timing(visual_opt,'press_phd_off'); % to check photodiode timing
    
end

%%

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

%%
function keyName=remove_string(keyName)
% remove extra string for number key presses
% deal with multiple key input

if iscell(keyName) % multiple key input (cell array)
    for i=1:length(keyName)
        keyName{i}=remove_string_from_number(keyName{i});
        keyName{i}=remove_extra_from_minus(keyName{i});
    end
else % only string
    keyName=remove_string_from_number(keyName);
    keyName=remove_extra_from_minus(keyName);
end

end

%%
function keyName=remove_string_from_number(keyName)

if ~isempty(regexp(keyName,'\d','ONCE'))
    % disp(regexp(keyName,'\d','ONCE')); % debug
%     try
        keyName=keyName(regexp(keyName,'\d','ONCE'));
%     catch
%         disp('check the code');
%     end
end
end


%%
function keyName=remove_extra_from_minus(keyName)

if ~isempty(regexp(keyName,'-','ONCE'))
    % disp(regexp(keyName,'\d','ONCE')); % debug
%     try
        keyName=keyName(regexp(keyName,'-','ONCE'));
%     catch
%         disp('check the code');
%     end
end
end