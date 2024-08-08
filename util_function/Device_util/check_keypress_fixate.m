function check_keypress_fixate(  )

	global device_opt game_opt visual_opt color_opt STROBE_ON 
	global step_ind onset

	KbEventFlush( );
	monkey_sleep        = false; 
	[ keyPressed, ~, keyCode ] = KbCheck( );

	if ( keyPressed )
		if keyCode( device_opt.fixation_remove_key )
			Screen( 'FillRect', visual_opt.window, color_opt.background ); %Set into background screen without fixation dot
			Screen( 'Flip',visual_opt.window );
			monkey_sleep = true;
		elseif keyCode( device_opt.stopkey )
			if game_opt.inLab
				give_reward_pulse( 0.25 ); % 0.05 sec with 0 sec reward duration.
			end
			
			if STROBE_ON
				NewStrobe( 24999 );    % Insert Strobe to check end of the trial ( # 24999 )
			end
			
			% Disconnect the current MATLAB with Omniplexon.
			PL_DOReleaseDevices();
			
			onset       = false;
			step_ind    = 10;
		elseif keyCode( device_opt.pause )
			% Implement pause in here so that whenever we can pause.
			Screen( 'FillRect', visual_opt.window, color_opt.background );
			Screen( 'Flip',visual_opt.window );
			[ ~, ~, keyCode ] = KbCheck;
			
			% Let fixation dot re - appear
			if keyCode( device_opt.gokey ) == 1
				Screen( 'FillRect', visual_opt.window, color_opt.background );
				Screen( 'FillOval', visual_opt.window, color_opt.white, visual_opt.Fixation_rect ); % ADD FIXATION DOTS
				Screen( 'Flip',visual_opt.window );
			end
			
			onset = true;
		end
		
		if ( monkey_sleep )
			while monkey_sleep
				[ ~, ~, keyCode ] = KbCheck;
				if keyCode( device_opt.gokey ) == 1
					Screen( 'FillRect', visual_opt.window, color_opt.background );
					Screen( 'FillOval', visual_opt.window, color_opt.white, visual_opt.Fixation_rect ); % ADD FIXATION DOTS
					Screen( 'Flip',visual_opt.window );
					break;
				end
			end
		end
	end
end