%% Correlation analysis

addpath(genpath('/Users/martial/Documents/GitHub/Canalysis'));


%% Define tuned ROI
%   tuned for session
Spatial_correlation.options.tuned_session=[5]; % If multitple use [X,Y]
%   cristeria1:
%'both' = tuning specificity + spatial information
%'tuning' = tuning specificclearity
%'info'= spatial information
Spatial_correlation.options.tuned_criteria1='both';       
%   criteria2:
%or = tuned ROI in one of the selected session 
%and= tuned ROI in all of the selected sessions
Spatial_correlation.options.tuned_criteria2='and'; 

Spatial_correlation=tuned_ROI(Spatial_correlation, Place_cell);
% Plot tuned ROI
sessions=4:6; % X:Y plot session X to Y
plot_tuned=1; 
if plot_tuned==1
sessions_tuned_ROI_GUI(Place_cell,Imaging,Behavior,Spatial_correlation, sessions);
end
%% Plot rate map ordered
Spatial_correlation.options.sessions=1:6; % X:Y plot session X to Y
Spatial_correlation.options.order=5; %order rate map for session # (1 to 3)
Spatial_correlation.options.ratemapsm=3; %smooth rate map (cosmetic) (0 = no smooth)
% Spatial_correlation.options.name=[{'STD1'}, {'MIS'}, {'STD2'}]; % name of sessions
Spatial_correlation.options.name=[{'D1'}, {'D2'}, {'D3'} {'D4'}, {'D5 1'}, {'D5 2'}]; % name of sessions
Spatial_correlation.options.bw_cmap=1; %use custom B%W colormap
Spatial_correlation.options.cmap='jet'; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html
% 'jet' 'hot' 'parula'


[Spatial_correlation] = plot_tuning(Spatial_correlation,Place_cell);

%% Population vector correlation & Tuning vector correlation 
%For all and only tuned neurons 
%PV correlation = 
%TC correlation =
Spatial_correlation.options.sessions=1:6; %sessions to compare
Spatial_correlation.options.bw_cmap=1; %use custom B%W colormap
Spatial_correlation.options.cmap='jet'; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html
% 'jet' 'hot' 'parula'



%plot_corr(1)={[x;y],[x;z], ...}: plot correlation session X vs Y and X vs Z
 plot_corr={ [1;2], [2;3], [3;4], [4;5], [5;6] } ; 
%plot_corr={ [1;2], [2,3], [1,3] } ; 

%perform multiple comparison analysis
Spatial_correlation.options.multcomp=0;


[Spatial_correlation] = corr_score(Spatial_correlation,Place_cell, plot_corr);


 %% Cues analysis
 
 
 
%% Save
% save('Correlation.mat', 'Spatial_correlation')
% clear


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
