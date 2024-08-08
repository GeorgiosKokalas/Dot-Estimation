function check_keypress_inplay( ) 

	global device_opt temporal_opt step_ind trial_onset
	
	%% Manual Keyboard Commands (make into subfunction and fix details)
	KbEventFlush( );
	[ keyPressed, ~, keyCode ] = KbCheck( );
	
	if (  keyPressed )
		if keyCode( device_opt.pause )
			pause( );
		elseif keyCode( device_opt.stopkey )
			trial_onset = false;
			step_ind    = 10;
			temporal_opt.endTime = GetSecs( );	% Remaining absolute time stamp.
			disp( 'Task Done!!!' );
		end
	end
end