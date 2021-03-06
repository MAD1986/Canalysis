%%  MAD Ca2+ analysis
addpath(genpath('/Users/martial/Documents/GitHub/Canalysis'));

%% Import data (XML, MAT, CSV)
directory_name =  uigetdir  %folder with .mat .csv and .xml
%!!!! files are listed by alphabetical order !!!!
%!!!! Keep same name for mat and csv !!!!
type='expdff';    %type of calcium trace 'Cdf' ; 'expdff' or 'spikes' 
tic;
[C_df,CSV,XML]=combine_sessions(directory_name,type);
toc;
%Sessions to analyse
sessions=length(C_df); %ALL

%% Exclude ROI:
% mat file with ROI to exclude name is rm_ROI
ROI=1:size(C_df{1},2);
keep_ROI=setdiff(ROI, rm_ROI);
for i=1:sessions
C_df{i}=C_df{i}(:,keep_ROI);
end
%% Compute behavior output
% Set parameters
options.mindist=10; %min distance before counting a new lap (cm)
options.acqHz=10000; % behavior acquisition frequency (Hz)
options.textures=0; % 1= find RFID for each texture; 0 = no RFID for texture
options.dispfig=1; % Display figure (lap, RFID)
%IF find RFID for each texture
%voltage [min max] signal for each RFID
if options.textures==true
RFID{1}=[0.5 1]; 
RFID{2}=[2 2.5];
RFID{3}=[3 3.5];
RFID{4}=[1.5 2];
RFID{5}=[1 1.5];
options.RFID=RFID;
end
% Extract position / lap / textures
for i=1:sessions
Behavior{i} = behavior_lap(CSV{i},options);
end

% Using frame timestamps from associated xml file

% If calcium trace is only a part of the total
% imaging session: use only selected frames for behavior 
options.select_frames=0; %if restrict = 0
%total nb of frames acquired during the imaging session
if options.select_frames==true
for i=1:sessions
nb_fr(i)=length(XML{i}.PVScan.Sequence.Frame);
end
frames=[{1:10000} {nb_fr(2)-20000:nb_fr(2)-1}];
elseif options.select_frames==0
    for i=1:sessions
frames = 1:size(C_df{1},1);
    end
end

% Restrict calcium data to selected lap
options.restrict=0; % restrict trace to full lap
options.startlap= 'first'; %First = 1st complete lap or numbers
options.endlap='last'; %Last= last complete lap or numbers
options.dispfig=1; % Display figure 
if options.dispfig==true,
options.c2plot=2; % neuron to display
end
% Function
for i=1:sessions
[Imaging{i}, Behavior{i}]= lapselect(C_df{i}, Behavior{i}, XML{i}, options,frames);
end

clear CSV XML options frames;

%% Correct drifting baseline
% Info 
% https://www.mathworks.com/help/bioinfo/ref/msbackadj.html
options.msbackadj=0; % 1 or 0 
% Set parameters
options.windwith=250; %width for the shifting window (in frame)
options.dispfig=1; % Display figure 
if options.dispfig==true,
options.c2plot=12; % neuron to display
end
% Correct baseline of signal with peaks
for i=1:sessions
if options.msbackadj==true
[Imaging{i}]=baselinesub(Imaging{i}, options);
elseif options.msbackadj==false
Imaging{i}.options.msbackadj=0;
end
end
clear options;
%% Events detection
% Set parameters
options.restricted=0; %Event detection on restricted trace
options.iterations=3; %Nb of iterations %Danielson et al. used 3 iterations
options.SDOFF=0.5; %Threshold below x SD for OFFSET 
options.msbackadj=0; % Corrected baseline
% Test different threshold with histogram of error rate 
% Lovett-Barron et al. 2014
% Rajasethupathy et al. 2015
options.testSD=1;
if options.testSD==true
options.SD=[2, 2.5, 3, 3.5]; %Threshold above x SD for ONSET to test
% Show histogram: optional
for i=1:sessions
[Events{i}]=sigma_events(Imaging{i},options);
end
end

%Set parameters for event detection 
options.SDON=2.5; %Threshold above x SD for ONSET 
options.mindurevent=1; %Min duration of event to be considered Danielson et al. used > 1s
options.dispfig=1; % Display figure 
if options.dispfig==true,
options.c2plot=20; % neuron to display
end
% Detect events
for i=1:sessions
[Events{i}]=detect_events(Imaging{i},options);
end
clear options;

%% Running epochs
options.method='speed'; %'peak' or 'speed'
% threshold running epochs based on :
% min peak speed(Danielson et al. 2016a, b, 2016) 
% OR average speed (Cossart) 
options.moving_window=10; % window width for moving mean filter
options.minspeed=2; %minimum speed (cm/s)  -- only if 'speed'
options.minpeak=5;  % minimum peak speed (cm/s) -- only if 'peak'
options.mindur=1; %Minimum duration (s) for running epoch
options.merge=0.5; %Merge consecutive running epochs separated by less than (s)
options.dispfig=1; % Display figure 
if options.dispfig==true
options.c2plot=4; % neuron to display
end
%Function
for i=1:sessions
[Events{i}, Behavior{i}]=run_epoch(Events{i},Behavior{i},Imaging{i}, options);
end
clear options
%% Events analysis
% Events parameters
options.exclude=1; % Remove events when no peaks found 
options.mindist= 10; % Set minimun distance between peaks (frame)
options.STD_pro=2; % Set minimun prominence of peak ( X * STD noise)
% Network parameters
% synchronous epochs based on Rajasethupathy et al. 2015
options.Nshuffle=1000; % Nb of shuffle for synchronous activity 
options.pmin=0.05; % min p value to be considered as significant
options.minframes=3; %consecutive frames with activity above the significance threshold

%Function
for i=1:sessions
[Events{i}, Network{i}, Figure{i}]=event_analysis(Behavior{i}, Events{i}, Imaging{i}, options);
end 
clear options
%% Identification of spatially-tuned cells
% Set parameters
options.sigma_filter=3; % Sigma (in bin) of gaussian filter (Danielson et al. = 3 bins)
options.smooth_span=3; % span for moving average filter on dF/F (Dombeck = 3)
options.minevents=3; % Min nb of events during session
options.Nbin=[2;4;5;8;10;20;25;100]; % Number of bins to test ([2;4;5;8;10;20;25;100] Danielson et al. 2016)
options.bin_spatial_tuning=100; % Number of bins to compute spatial tuning curve (rate map) -value must be in options.Nbin
options.Nshuffle=10000; % Nb of shuffle to perform
options.pvalue=0.05; % Min p value to be considered as significant
options.dispfig=1; % Display figure 
 
%Function
for i=1:sessions
[Place_cell{i}]=spatial_info(Behavior{i}, Events{i}, Imaging{i},options);
[Place_cell{i}]=tuning_specificity(Place_cell{i},Behavior{i},Events{i},options);
[Place_cell{i}]=shuffle_place_cell(Place_cell{i},Behavior{i},Events{i},options);
end
%Plot tuned ROI (beta)
% for i=1:sessions
%     figure
% tuned_ROI_GUI(Place_cell{i},Imaging{i});
% end
clear options

%% Save
tic;
save('Result_dendrites_only', '-v7.3');
toc;



