function displayText(window, textString, position, textColor)
    % displayText Displays a string on a Psychtoolbox window
    %
    % Usage:
    %   displayText(window, textString, position, textColor)
    %
    % Parameters:
    %   window      : Psychtoolbox window pointer
    %   textString  : String to display
    %   position    : [x, y] coordinates for text placement
    %   textColor   : RGB color vector for the text

    % Set the text size, style, and color
    Screen('TextSize', window, 24);  % Set text size
    Screen('TextFont', window, 'Arial');  % Set text font
    Screen('TextStyle', window, 1);  % Make text bold

    % Draw the text at the specified position
    DrawFormattedText(window, textString, position(1), position(2), textColor);

    % Update the display
    Screen('Flip', window);

    % Optionally, you can add a delay or wait for a key press
    % KbWait;  % Uncomment this line if you want to wait for a key press
    % WaitSecs(2);  % Wait for 2 seconds before continuing
end