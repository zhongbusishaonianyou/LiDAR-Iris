function [Iris, GTposes] = Load_Data(dim,GTpose_dir,Max_range)
%%
global data_path;
data_save_path = fullfile('./data/'); 
%%
if ~exist(data_save_path,'dir')
    % make 
    [Iris, GTposes] = Initialize_data(data_path,GTpose_dir,dim,Max_range);    
    mkdir(data_save_path);

    Iris_file = strcat(data_save_path, 'Iris', '.mat');
    save(Iris_file, 'Iris');

    GTpose_file = strcat(data_save_path, 'GTposes', '.mat');
    save(GTpose_file, 'GTposes');

else
    Iris_file = strcat(data_save_path, 'Iris',  '.mat');
    load(Iris_file);
    
    GTpose_file = strcat(data_save_path, 'GTposes', '.mat');
    load(GTpose_file);
    
    disp('- successfully loaded.');
end
end

