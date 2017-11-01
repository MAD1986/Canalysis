%% Correlation analysis
addpath(genpath('/Users/martial/Documents/GitHub/Canalysis'));
%% Define tuned ROI
%  Define tuned for session:
Spatial_correlation.options.tuned_session=[1]; % If multitple use [X,Y]

            %   cristeria1:
Spatial_correlation.options.tuned_criteria1='both';
%'both' = tuning specificity + spatial information
%'tuning' = tuning specificity
%'info'= spatial information

            %   criteria2:
Spatial_correlation.options.tuned_criteria2='or'; 
%or = tuned ROI in one of the selected session 
%and= tuned ROI in all of the selected sessions

            % Pie chart 
Spatial_correlation.options.pie_sessions=[1,2]; %Pie chart between 2 sessions ([X, Y])

             %function
Spatial_correlation=tuned_ROI(Spatial_correlation, Place_cell);


% GUI tuned ROI
sessions=1:3; % X:Y plot session X to Y
GUI_tuned=0; 
if GUI_tuned==1
sessions_tuned_ROI_GUI(Place_cell,Imaging,Behavior,Spatial_correlation, sessions);
end
%% Plot rate map ordered
Spatial_correlation.options.sessions=1:2; % X:Y plot session X to Y
Spatial_correlation.options.order=1; %order rate map for session # (1 to 3)
Spatial_correlation.options.ratemapsm=1; %smooth rate map (cosmetic) (0 = no smooth)
%Spatial_correlation.options.name=[{'STD'}, {'MIS'}, {'STD1'}, {'STD2'} ]; % name of sessions
 Spatial_correlation.options.name=[{'D1'}, {'D2'}, {'D3'} {'D6'}, {'D7'}, {'D5 2'}]; % name of sessions
Spatial_correlation.options.bw_cmap=0; %use custom B%W colormap
Spatial_correlation.options.cmap='jet'; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html
% 'jet' 'hot' 'parula'
[Spatial_correlation] = plot_tuning(Spatial_correlation,Place_cell);

%% Population vector correlation & Tuning vector correlation 
%For all and only tuned neurons 
%PV correlation =  Population correlation
%TC correlation =  Tuning curve correlation
Spatial_correlation.options.sessions=1:2; %sessions to compare
Spatial_correlation.options.bw_cmap=0; %use custom B%W colormap
Spatial_correlation.options.cmap='jet'; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html
% 'jet' 'hot' 'parula'
%plot_corr={[x;y],[x;z], ...}: plot correlation session X vs Y and X vs Z
% plot_corr={ [1;2], [2;3], [3;4], [4;5], [5;6] } ; 
plot_corr={[1,2]} ; 
%perform multiple comparison analysis (ANOVA)
Spatial_correlation.options.multcomp=0;
%Function
[Spatial_correlation] = corr_score(Spatial_correlation,Place_cell, plot_corr);
%% Textures 
%only between 2 sessions (STD vs MIS)
Spatial_correlation.options.sessions=1:2;  % Find textures for sessions [X:Y] X to Y
Spatial_correlation.options.textures.bin_before_RFID=5; % how many bins before RFID signal considered as same texture
Spatial_correlation.options.textures.bin_after_RFID=5; % how many bins after RFID signal considered as same texture
Spatial_correlation.options.textures.min_change=10;    %rotated texture= change > X bins
Spatial_correlation.options.cmap='jet'; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html
%Function
[Spatial_correlation] = textures(Behavior,Place_cell,Spatial_correlation);

%% Save
 save('M6_Correlation_tuned_STD1_or_MIS2.mat', 'Spatial_correlation')
 clear 
%% Repeated analysis (different mouse)
% Load files
folder_name = uigetdir %fgo to the folder
cd(folder_name);
listmat = dir('*.mat'); % look for all the mat files (alphabetical order)
for exp = 1:length(listmat)
matfiles{exp} = load((listmat(exp).name));
end
%Get PV and TC correlation 
for exp = 1:length(listmat)
PV_Corr_all(:,exp)=matfiles{exp}.Spatial_correlation.PV_correlation.AllROI.PVcorr   ;
PV_Corr_Tuned(:,exp)=matfiles{exp}.Spatial_correlation.PV_correlation.TunedROI.PVcorr_tuned ;
TC_Corr_Tuned{exp}=matfiles{exp}.Spatial_correlation.TC_correlation.TunedROI.TCcorr  ;
end
Re_PV_Corr_all=reshape(PV_Corr_all,[],1);
Re_PV_Corr_Tuned=reshape(PV_Corr_Tuned,[],1);
Re_TC_Corr_Tuned=cat(1, TC_Corr_Tuned{:});

Corr_Score.All.PV_Corr=PV_Corr_all;
Corr_Score.All.PV_Corr_Col=Re_PV_Corr_all;
Corr_Score.Tuned.PV_Corr=PV_Corr_Tuned;
Corr_Score.Tuned.PV_Corr_Col=Re_PV_Corr_Tuned;
Corr_Score.Tuned.TC_Corr=TC_Corr_Tuned;
Corr_Score.Tuned.TC_Corr_Col=Re_TC_Corr_Tuned;

save('All_Corr_Tuned_STD1_or_MIS2.mat', 'Corr_Score')
clear

%% old
% 
% 
% %% Rotation analysis
% Spatial_correlation.options.sessions=1:3; %sessions to compare -all
% Spatial_correlation.options.STDsessions=[1 3]; %STD sessions to analyse 
% Spatial_correlation.options.MISsessions=[2]; %MIS sessions to analyse 
% 
% Spatial_correlation.options.tuned_criteria1='both'; %Inclusion criteria
% Spatial_correlation.options.rotation_criteria='and'; %always and for now
% Spatial_correlation.options.rotation_figure=1 ; %plot figure (0 or 1)
% Spatial_correlation.options.rotation_binbefore=5;
% Spatial_correlation.options.rotation_binafter=5;
% Spatial_correlation.options.rotation_smooth=3;
% 
% 
% [Spatial_correlation] = rotation_V4(Spatial_correlation,Spatialinfo,TunedCells,TuningSpecificity);
% [Spatial_correlation] = rotation_events_V1(Spatial_correlation,Spatialinfo,TunedCells,TuningSpecificity, Events, Behavior);
% 
% %% Plot 
% %[x;y]: plot each correlation between session X vs session Y
% plot_session{1}=[1;3]; %STD1
% plot_session{2}=[1;2]; %MIS1
% plot_session{3}=[2;3]; %MIS1
% %plot_session{4}=[3;5]; %STD
% %plot_session{5}=[3;4]; %MIS2
% %plot_session{6}=[4;5]; %MIS2
% color='jet'; % colormap
% 
% %Plot PV Correlation
% [Spatial_correlation]=plotPVcorr_V2(Spatial_correlation,color, plot_session);
% %Plot TC Correlation
% [Spatial_correlation]=plotTCcorr(Spatial_correlation,color, plot_session);
% %Plot Overlap
% [Spatial_correlation] = plotrateoverlap(Spatial_correlation,color, plot_session);
% 
% 
