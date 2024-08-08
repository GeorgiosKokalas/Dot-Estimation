function go_sign = check_key( go_sign )

	global device_opt
    
	while( go_sign == 0 )
		[ keyIsDown,~,keyCode ] = KbCheck( );
		if keyCode( device_opt.gokey )
			go_sign = 1;
		elseif keyCode( device_opt.stopkey )
			go_sign = -1;
		end
	end

	while keyIsDown
		[ keyIsDown,~,~ ] = KbCheck;
	end
end