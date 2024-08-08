function [visual_opt, device_opt, game_opt, path_opt] = stage_initialize(ID)

    %% This function is to setup options before the task starts.
    %   What to setup?
    %   1. Visual option (adaptively to the setup)
    %   2. Device option (joystick and keyboard)
    %   3. Save path directory

    visual_opt = set_visual();
    device_opt = set_device();
    game_opt = set_game(visual_opt);
    path_opt = save_paths(ID);
    save_configs(visual_opt, device_opt, game_opt, path_opt);
    disp('-------------------------------');
    disp('Complete setting options');
    disp('-------------------------------');
end