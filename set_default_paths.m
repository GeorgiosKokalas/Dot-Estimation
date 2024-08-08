function set_default_paths()
    %% Current function is to set default paths used throughout.
    curr_path = fileparts(which(mfilename)); % Execution path.
	cd(curr_path); 
    
    % Set dir_lists you want to add on.
    dir_lists = {'util_function', 'stages', 'results'};
	add_directoryPath(curr_path, dir_lists);
end

function add_directoryPath(curr_path, dir_lists)
    %% Current function is to add subdirectories automatically. 
    n_lists = length(dir_lists);
    for iL = 1 : n_lists
        addpath(fullfile(curr_path, dir_lists{iL}));
    	addpath(genpath([curr_path, '/', dir_lists{iL}]));
    end
end
