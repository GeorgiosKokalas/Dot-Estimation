function present_opt(visual_opt, game_opt, curr_str, curr_pos, phd_on)
    
    %% 0. Set time and text
    num2disp = curr_str;
    
    %% 1. Draw and present
    % get center of field
    field_center_x = curr_pos(1);
    field_center_y = curr_pos(2);
    
    % compute rect_matrix: note upper left is [0 0]
    rect_matrix=[field_center_x + curr_str.x(:)'-curr_str.r(:)';... % left
        field_center_y + curr_str.y(:)'-curr_str.r(:)';... % top
        field_center_x + curr_str.x(:)'+curr_str.r(:)';... % right
        field_center_y + curr_str.y(:)'+curr_str.r(:)']; % bottom
    
    rect_matrix=round(rect_matrix); % rounding for pixels
    
    try,Screen('FillOval',visual_opt.window,visual_opt.white,rect_matrix);
    catch,keyboard; % for debug
    end
    
    
    % photodiode
    if phd_on
        draw_photoD(visual_opt);
    end
    
    Screen('Flip', visual_opt.window);

end