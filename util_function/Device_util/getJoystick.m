function [ x, y ] = getJoystick
    
    %% This function generates output of joystick -- step1. 
    %   Step 2 (at chase step) is multiplying another number (controlled by experimenter).     
    
    global device_opt
    
    if strcmp( device_opt.os, 'Windows32')
        % joystick(1) is movement along the Y axis (ranges from -1.0019 to 1.0019), with
        %   negative as forward/upward motion and positive as backwards/downward motion
        % joystick(2) is movement along the X axis (ranges from -1.0019 to 1.0019), with
        %   negative as leftward motion and positive as rightward motion
        joystick = jst2; % mex file complied for 32-bits window.
    elseif strcmp( device_opt.os, 'Windows64')
        % You can download JoyMEX by goolging. 
        [A, ~] = JoyMEX( device_opt.joystick_id );
        joystick = A(1:2);
    end

    x = joystick(1)*( device_opt.Ymultiplicative_factor_joy );	
    y = joystick(2)*( device_opt.Xmultiplicative_factor_joy );
end