
%% Analyze before/after for multiple sessions
%Analyse events and network properties  
%% Add scripts in path
addpath(genpath('/Users/martial/Documents/GitHub/Phoenix'));
addpath(genpath('/Users/martial/Documents/GitHub/Canalysis'));
%% Load files
% need mat files with 2 sessions ( before / after )
session={'CTRL', 'PSAM'}; %or other drug, days, context etc
folder_name = uigetdir %fgo to the folder
cd(folder_name);
listmat = dir('*.mat'); % look for all the mat files (alphabetical order)
for exp = 1:length(listmat)
matfiles{exp} = load((listmat(exp).name));
end

%% Make table with mean
[events_mean_cell,network_mean_cell, properties,network]= comb_mean(matfiles,session);
%% Plot all 
% Plot event properties
Results=[];
rows_sub=3; %rows for subplot
[Results] =plot_bef_aft(Results,rows_sub,properties,session,events_mean_cell);

% Plot network properties
%Analyse :
%Frequeny (1), AUC_rate (2), nb_corr_pairs (5),  
%nb HC_neurons (6), nb_synchronous_epochs (11).
netvar=[1,2,5,6,11];
netval=network(netvar(1:3)); %Plot only 1 to 3
rows_sub=1; %rows for subplot
[Results]=plot_bef_aft(Results,rows_sub,netval,session,network_mean_cell);



