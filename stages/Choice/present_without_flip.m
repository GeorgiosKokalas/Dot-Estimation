function present_without_flip(visual_opt, curr_str, curr_pos, phd_on,varargin)

% varargin: 1st for color [rgb], 2nd for text size

    % specificy color
    if isempty(varargin)
        textcolor = visual_opt.white;
        textSize = visual_opt.textSize;
    else
        if length(varargin)==1
            textcolor = varargin{1};
            textSize = visual_opt.textSize;
        elseif length(varargin)==2
            textcolor = varargin{1};
            textSize = varargin{2};
        end
    end

    %% 0. Set time and text
    num2disp = curr_str;
    
    %% 1. Draw and present
    Screen('TextSize', visual_opt.window, textSize);
    Screen('TextColor', visual_opt.window, textcolor);
    Screen('TextStyle', visual_opt.window, visual_opt.textStyle);
    DrawFormattedText(visual_opt.window, num2disp, ...
        curr_pos(1), curr_pos(2), textcolor);
    
    % photodiode
    if phd_on
        draw_photoD(visual_opt);
    end
    
end