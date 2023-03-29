function [projSubFolders] = defaultProjectFolders()
	% default project folder structure

	% For every entry in projSubFolders, the contents in projSubFolders(i).level2 
	% are the subfolders of projSubFolders(1).level1


	% % Names of folders in the 'Project' folder. These are the 'level_1' folder
	% level1_folders = {'Data','Analysis','Presentations','Publications','License_n_approval'};
	% level2_folders = {{'Confocal','Calcium_imaging','Immunohistochemistry','Behavior'},... % level_2 folders in 'Data'
	% 	{'Confocal','Calcium_imaging','Immunohistochemistry','Behavior'},... 			   % level_2 folders in 'Analysis'
	% 	{'Talks','Posters','LabReports'},...											   % level_2 folders in 'Presentations'
	% 	{},...																			   % level_2 folders in 'Publications'
	% 	{'Animal_experiment','Narcotic_license'}};										   % level_2 folders in 'License_n_approval'
 

	% initiate structure var, projSubFolders	
	projSubFolders = empty_content_struct({'level1','level2'},5);

	projSubFolders(1).level1 = 'Data';
	projSubFolders(1).level2 = {'Confocal','Calcium_imaging','Immunohistochemistry','Behavior'};

	projSubFolders(2).level1 = 'Analysis';
	projSubFolders(2).level2 = {'Confocal','Calcium_imaging','Immunohistochemistry','Behavior'};

	projSubFolders(3).level1 = 'Presentations';
	projSubFolders(3).level2 = {'Talks','Posters','LabReports'};

	projSubFolders(4).level1 = 'Publications';
	projSubFolders(4).level2 = {};

	projSubFolders(5).level1 = 'License_n_approval';
	projSubFolders(5).level2 = {'Animal_experiment','Narcotic_license'};

end