function [level1_folder, level2_folders] = input_gui(level1_input, level2_input)

    % check number of inputs
    if nargin < 1
        level1_input = '';
    end
    
    if nargin < 2
        level2_input = {};
    end
    
    % create figure and introduction
    fig = uifigure('Position', [500 500 400 300], 'Name', 'Input GUI');
    intro_label = uilabel(fig, 'Position', [50 250 300 22], 'Text', 'Input a name for the level1 folder and multiple names for its subfolders (level2 folder)');
    
    % creat label and edit box for level 1 folder
    level1_label = uilabel(fig, 'Position', [50 210 100 22], 'Text', 'Level 1 folder:');
    level1_box = uieditfield(fig, 'text', 'Position', [50 170 300 30], 'Value', level1_input);

    % create label and edit box for level 2 folders
    level2_label = uilabel(fig, 'Position', [50 120 100 22], 'Text', 'Level 2 folders:');
    level2_input_str = strjoin(level2_input, '; ');
    level2_box = uieditfield(fig, 'text', 'Position', [50 80 300 30], 'Value', level2_input_str);

    % create done and close buttons
    done_button = uibutton(fig, 'Position', [100 20 100 30], 'Text', 'Done', 'ButtonPushedFcn', @done_callback);
    close_button = uibutton(fig, 'Position', [200 20 100 30], 'Text', 'Close', 'ButtonPushedFcn', @close_callback);


    function done_callback(~, ~)
        % get input from level 1 folder edit box
        level1_str = get(level1_box, 'Value');
        level1_str_trimmed = strtrim(level1_str); % remove leading/trailing white space
        if ~isempty(level1_str_trimmed)
            level1_folder = level1_str_trimmed;
        else
            level1_folder = '';
            error('level1 folder must not be empty')
        end


        % get input from level 2 folders edit box
        level2_str = get(level2_box, 'Value');
        level2_str_trimmed = strtrim(level2_str); % remove leading/trailing white space
        if ~isempty(level2_str_trimmed)
            level2_folders = strsplit(level2_str_trimmed, ';');
            level2_folders_trimmed = strtrim(level2_folders); % remove leading/trailing white space
            level2_folders = level2_folders_trimmed(~cellfun('isempty',level2_folders_trimmed)); % remove empty cells
        else
            level2_folders = {};
        end

        delete(fig);
    end

    function close_callback(~, ~)
        level1_folder = '';
        level2_folders = {};
        delete(fig);
    end

    uiwait(fig);
end
