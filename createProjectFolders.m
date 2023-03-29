function [varargout] = createProjectFolders(varargin)
	% Create folders for a project

	% 

	% if there is no input, use the default folder setting by calling function defaultProjectFolders 
	% if input exists, validate the input
	if nargin == 0
		projSubFolders = defaultProjectFolders;
	elseif nargin == 1
		projSubFolders = varargin{1};
		if ~isstruct(projSubFolders)
			inputValid = false;
		else
			if ~isfield(projSubFolders,'level1') || ~isfield(projSubFolders,'level2')
				inputValid = false;
			end
		end
		if ~inputValid
			error('input must be a structure var containing fields "level1" and "levle2"');
		end
	else
		error('input number must be 0 or 1')
	end


	% Ask for the name of the project and use it to create the root folder
	prompt_projectName = 'Enter a name for the project [defult: Project]: ';
	projName = input(prompt_projectName,'s');
	if isempty(projName) % if the input is empty, use 'Project' as the folder name
		projName = 'Project'; 
	end



	% Display the project folder name
	fprintf('\nProject folder structure: \n')
	fprintf('- [%s]\n',projName); % print the project folder name


	% Display the subfolders in the project folder.
	confirmFolderStruct = 'N'; % showing the subfolders and ask user to confirm it until confirmFolderStruct is 'Y'
	while strcmpi(confirmFolderStruct,'N')
		level1_folders_num = numel(projSubFolders); % number of level folders 

		% Loop through the strings and assign them to the structure. Display the subfolders (level_1 and level_2)
		for i = 1:level1_folders_num
		    % projSubFolders(i).level1 = level1_folders{i};
		    fprintf('	- [%s]\n',projSubFolders(i).level1); % print the level_1 folder name

		    % Loop through the level_2 folders in the current level_1 folder and print them
		    level2_folders_num = numel(projSubFolders(i).level2);
		    for j = 1:level2_folders_num
		    	fprintf('		- [%s]\n',projSubFolders(i).level2{j});
		    end
		end

		% Ask to confirm the folder structure
		prompt_confirmFolderStruct = '\nUse the structure shown above Y/N(modify folders)/C(cancel) [Y]: ';
		confirmFolderStruct = input(prompt_confirmFolderStruct,'s');
		if isempty(confirmFolderStruct) % if the input is empty, assign the the default answer, Y
			confirmFolderStruct = 'Y'; 
		end

		% Modify the folders if confirmFolderStruct is 'N'/'n'
		if strcmpi(confirmFolderStruct,'Y')
			break
		elseif strcmpi(confirmFolderStruct,'N')
			modFolderStruct = true; 
			j = 1;
			while modFolderStruct
				if j <= level1_folders_num
					level1_folder = projSubFolders(j).level1;
					level2_folders = projSubFolders(j).level2;
				else
					level1_folder = '';
					level2_folders = {};
				end
				[level1_folder, level2_folders] = input_gui(level1_folder, level2_folders);
				if isempty(level1_folder)
					modFolderStruct = false;
				else
					if j <= level1_folders_num
						projSubFolders(j).level1 = level1_folder;
						projSubFolders(j).level2 = level2_folders;
					else
						newFolders.level1 = level1_folder;
						newFolders.level2 = level2_folders;
						projSubFolders = [projSubFolders;newFolders];
					end
					j = j+1;
				end
			end
		elseif strcmpi(confirmFolderStruct,'C')
			return
		end
	end



	% Ask to confirm the creation of the project folder
	prompt_confirmToCreat = '\nChoose a location to create a project folder with the structure shown above Y/N [Y]: ';
	confirmToCreate = input(prompt_confirmToCreat,'s');
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


	% Ask to save the projSubFolders so it can be used in the future
	prompt_saveVar = '\nSave the folder structures Y/N [Y]: ';
	saveVar = input(prompt_saveVar,'s');
	if isempty(saveVar) % if the input is empty, assign the the default answer, Y
		saveVar = 'Y'; 
	end
	if saveVar
		[filename,filepath] = uiputfile('*.*','Save projSubFolders','projSubFolders.mat');
		save(fullfile(filepath,filename),'projSubFolders');
	end

	varargout{1} = projSubFolders;
end