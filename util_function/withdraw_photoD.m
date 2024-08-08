function withdraw_photoD(visual_opt)

    % same as draw_photoD but trick is to use same color as background
    % with this, we don't have to re-draw the stimuli only for photodiode
    % (using dontclear option in Sceen Flip)

    % Parameters:
    %   visual_opt.screenXpixels - Screen width in pixels
    %   visual_opt.screenYpixels - Screen height in pixels
    %   visual_opt.gridRow       - The row in the grid to place the rectangle (1-based index)
    %   visual_opt.gridColumn    - The column in the grid to place the rectangle (1-based index)

    % Calculate cell size
    cellWidth = visual_opt.screenXpixels / visual_opt.grid_nCols;
    cellHeight = visual_opt.screenYpixels / visual_opt.grid_nRows;

    % Calculate rectangle position (bottom left grid cell)
    offsetX = cellWidth * visual_opt.x_grid_sel; % Leftmost column
    offsetY = cellHeight * visual_opt.y_grid_sel; % Bottom row

    % Draw the rectangle at calculated position
    rectPosition = [0,visual_opt.screenYpixels-offsetY, offsetX, visual_opt.screenYpixels];
    Screen('FillRect', visual_opt.window, visual_opt.black, rectPosition);
end