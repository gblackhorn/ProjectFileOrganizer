function [varargout] = createProjectFolders(varargin)
	% Create folders for a project


	% Example:
	%	
	%		

	% Defaults
	% Names of folders in the 'Project' folder. These are the 'level_1' folder
	level1_folders = {'Data','Analysis','Presentations','Publications','License_n_approval'};
	level2_folders = {{'Confocal','Calcium_imaging','Immunohistochemistry','Behavior'},... % level_2 folders in 'Data'
		{'Confocal','Calcium_imaging','Immunohistochemistry','Behavior'},... 			   % level_2 folders in 'Analysis'
		{'Talks','Posters','LabReports'},...											   % level_2 folders in 'Presentations'
		{},...																			   % level_2 folders in 'Publications'
		{'Animal_experiment','Narcotic_license'}};										   % level_2 folders in 'License_n_approval'



	% Ask for the name of the project and use it to create the root folder
	prompt_projectName = 'Enter a name for the project [defult: Project]: ';
	projName = input(prompt_projectName,'s');
	if isempty(projName) % if the input is empty, use 'Project' as the folder name
		projName = 'Project'; 
	end



	% Display the project folder structure (From project to level_2 folders)
	fprintf('\nProject folder structure: \n')
	fprintf('- [%s]\n',projName); % print the project folder name



	% Initialize the folders structure
	level1_folders_num = numel(level1_folders); % number of level folders 
	projSubFolders = empty_content_struct({'level1','level2'},level1_folders_num);

	% Loop through the strings and assign them to the structure. Display the subfolders (level_1 and level_2)
	for i = 1:level1_folders_num
	    projSubFolders(i).level1 = level1_folders{i};
	    fprintf('	- [%s]\n',projSubFolders(i).level1); % print the level_1 folder name

	    % Assign the level_2 folders to the current level_1 folder
	    projSubFolders(i).level2 = level2_folders{i};

	    % Loop through the level_2 folders in the current level_1 folder and print them
	    level2_folders_num = numel(projSubFolders(i).level2);
	    for j = 1:level2_folders_num
	    	fprintf('		- [%s]\n',projSubFolders(i).level2{j});
	    end
	end



	% Ask to confirm the folder structure
	prompt_confirm_folder_struct = '\nChoose a location to create a project folder with the structure shown above Y/N [Y]: ';
	confirmToCreate = input(prompt_confirm_folder_struct,'s');
	if isempty(confirmToCreate) % if the input is empty, assign the the default answer, Y
		confirmToCreate = 'Y'; 
	end



	% Create Project folder
	if strcmpi(confirmToCreate,'Y')
		parentFolder = uigetdir(matlabroot,'Choose a place to create the project folder');

		if parentFolder ~= 0 % if parentFolder is chosen
			% Get the path of project folder 
			projFolder = fullfile(parentFolder,projName);

			% Check if the folder already exists
			if exist(projFolder, 'dir')
				fprintf('\nFolder "%s" already exists. Creation is aborted.\n',projFolder);
			    % disp(['Folder "', projFolder, '" already exists.'])
			    return
			else
			    % Create the folder
			    mkdir(projFolder); % Create the project folder
			end

			% Create level_1 and level_2 folders
			for i = 1:level1_folders_num
				% Get the path of a level_1 folder and create it
				level1_folder = fullfile(projFolder,projSubFolders(i).level1);
				mkdir(level1_folder);

				% Loop through the level_2 folders in the current level_1 folder and create them
				level2_folders_num = numel(projSubFolders(i).level2);
				for j = 1:level2_folders_num
					level2_folder = fullfile(level1_folder,projSubFolders(i).level2{j});
					mkdir(level2_folder);
				end
			end 
			fprintf('\nproject [%s] has been successfully created in: \n	%s\n',projName,projFolder);
		else
			fprintf('Folder not chosen. Project [%s] folder creation is aborted\n',projName);
			return
		end
	end
end