function save_configs(visual_opt, device_opt, game_opt, path_opt)
    %% Current function saves all the configuration so that we can track.
    cd(path_opt.save_data);
    config_filename = sprintf('Configuration'); 
    config_vars.visual = visual_opt;
	config_vars.device = device_opt;
    config_vars.games  = game_opt;
    save(config_filename, 'config_vars');
	cd(path_opt.exc_path);
end