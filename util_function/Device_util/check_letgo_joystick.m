function check_letgo_joystick( )

    global PC_OS device_opt visual_opt color_opt
    
    Screen( 'FillRect', visual_opt.window, color_opt.background );

    if ~( PC_OS )
        while ( abs ( Gamepad( 'GetAxis', 1, 1 ) )   > device_opt.joystickThreshold * 10000 ...
                || abs( Gamepad( 'GetAxis', 1, 2 ) ) > device_opt.joystickThreshold * 10000 )
            Screen( 'TextSize', visual_opt.window, 100 );
            Screen( 'DrawText', visual_opt.window, 'X', ...
                visual_opt.screenXpixels, visual_opt.screenYpixels, [255, 0, 0 ], color_opt.background);
            Screen( 'Flip', visual_opt.window );
        end
    else
        [ currX, currY ] = getJoystick;
        X_at_SCR = false;
        
        % If monkeys does not let go the joystick, then the currX and currY
        % might have large value. Thus, if it is keep getting large value,
        % then keep looping until the monkey let the joystick go. 
        while ( abs( currX ) > device_opt.joystickThreshold * 2000 ) || ( abs( currY ) > device_opt.joystickThreshold * 2000 )
            if ~( X_at_SCR )
                Screen( 'TextSize', visual_opt.window, 150 );
                Screen( 'DrawText', visual_opt.window, 'X', ...
                    visual_opt.xCenter, visual_opt.yCenter, [255, 0, 0 ], color_opt.background );
                Screen( 'Flip', visual_opt.window );
                X_at_SCR = true;
                [ currX, currY ] = getJoystick;
            else
                if ( abs( currX ) < 50 ) && ( abs( currY ) < 50 )
                    disp('Successfully let it go');
                    Screen( 'FillRect', visual_opt.window, color_opt.background );
                    Screen( 'Flip', visual_opt.window );
                    break;
                end
                [ currX, currY ] = getJoystick;
            end
        end
    end
end