function align_time(start_time, set_time, t_resolution)

   %% Current function is to align the time.
    while GetSecs( ) - start_time < set_time 
        WaitSecs( t_resolution );
    end
end