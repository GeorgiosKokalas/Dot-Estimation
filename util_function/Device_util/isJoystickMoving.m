function movement = isJoystickMoving
    global device_opt PC_OS;
    movement = 0;

    %% get current joystick position
	%    [x, y] = getJoystick;
    if ~(PC_OS)
        x = Gamepad('GetAxis',1,1);
        y = Gamepad('GetAxis',1,2);
    else
        [x, y] = getJoystick;
    end
    % check if there's any motion in the x or y directon, depending on the
    % set movement threshold
    if abs(x) > device_opt.joystickThreshold || abs(y) > device_opt.joystickThreshold
       movement = 1;
    end
end