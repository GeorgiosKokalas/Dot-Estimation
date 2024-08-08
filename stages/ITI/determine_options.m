function curr_opt = determine_options(game_opt)

    %% determin options for current trial
    % Each trial, Computer randomly selectsa number from {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
    
    %% 1. Determine numbers
    curr_nums=randi([game_opt.min_num game_opt.max_num], 1, 1);
    curr_opt.curr_nums = curr_nums;
    
    % correct answer
            curr_opt.target_num = curr_nums;
        
    %% 2. formats 
    curr_opt.curr_format = game_opt.format{randi(game_opt.num_format,1)};

    %% 3. Determine the presentation location.
    % select positions for all numbers and operation
    id_location = randperm(game_opt.n_grid,1); % linear index: e.g., 9 1 3
    grid_size = [game_opt.n_grid_y game_opt.n_grid_x]; % note vertical(row) for y, horizontal(column) for x
    [curr_opt.pos_y_idx,curr_opt.pos_x_idx]=ind2sub(grid_size,id_location);
    
    %% 4. Finalize the presentation options
    switch curr_opt.curr_format
        case 'dot'
            % generate dot here during ITI to save resource
            number_range = [game_opt.min_num game_opt.max_num];
            curr_opt.dot(1)=generate_dots(curr_nums(1),number_range,game_opt.radius_range,game_opt.field_range); % structure has x y z for each dot
            curr_opt.strs = curr_opt.dot(1);
    end
end