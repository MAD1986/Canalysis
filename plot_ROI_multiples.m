%% Plot ROI

% need mat file with ROI :
% A2, Cn_max, keep, options from CNMF

% mat file with :
% expDffMedZeroed or C_df from CNMF


%% Add scripts in path
addpath(genpath('/Users/martial/Documents/GitHub/Phoenix'));
addpath(genpath('/Users/martial/Documents/GitHub/Canalysis'));
%% Open mat files with ROI
%FOR RZ you need to have multiple .mat files 
%(1_sessionA_ROI.mat, 2_sessionB_ROI.mat,...)
%   NEED:
%   A2,Cn,Cn_max,Coor,b2,center,f2,keep

listmat = dir('*.mat'); %will look for all the mat files
for i = 1:length(listmat)
ROI{i} = load((listmat(i).name));
end

%% Open mat files with cdf
%FOR RZ you need to have multiple .mat files 
%(1_sessionA_Cdf.mat, 2_sessionB_Cdf.mat,...)
%   NEED:
%   A2,Cn,Cn_max,Coor,b2,center,f2,keep

listmat = dir('*.mat'); %will look for all the mat files
for i = 1:length(listmat)
cdf{i} = load((listmat(i).name));
%to change the type of signal to import:
%Replace: expDffMedZeroed with C_df / C_dec / F_dff / S ..
C_df{i}=cdf{i}.expDffMedZeroed; 
C_df{i}=(full(C_df{i})');
end
%% Options
% Plot only keep ROI:
plot_keep=0; % 0 or 1
corr_scor_min=0.85; %min correlation score for ROI between session 
% Plot only tuned ROI:
plot_tuned=0; % 0 or 1
if plot_tuned==true;
for i=1:length(Place_cell)
tunedROI{i}=Place_cell{i}.Tuned_ROI;  
keep=unique(cell2mat(tunedROI));
end
end

%% plot contour
FOV=length(ROI{1}.Cn_max);
if plot_keep==true; % 0 or 1
    if length(ROI)==3
keep_all=intersect(find(ROI{1}.keep==1), intersect(find(ROI{2}.keep==1), find(ROI{3}.keep==1)));
elseif length(ROI)==2
keep_all=intersect(find(ROI{1}.keep==1),find(ROI{2}.keep==1));
elseif length(ROI)==1
    keep_all=ROI.keep;
    end
elseif plot_keep==false;
    keep_all=1:size(C_df{1},2);
end
if plot_tuned==true; % 0 or 1
keep_all=keep;
end


figure
for i=1:length(ROI)
A2_keep{i}=ROI{i}.A2(:,keep_all);
ROI_sh{i}=reshape(full(A2_keep{i}),FOV,FOV,size(A2_keep{i},2));
All_ROI{i}=sum(ROI_sh{i},3);
subplot(length(ROI),1,i)
imagesc(All_ROI{i})
end
for i=1:length(ROI)
figure
plot_contours(A2_keep{i},ROI{i}.Cn_max,ROI{i}.options,1); 
legend(['ROI session ' num2str(i)]);
title(['session ' num2str(i)]);
end
%% Show components on image + dF for all sessions

% Fix bug not same nb ROI:
for i=1:size(C_df,2)
sizeROI(i)=size(C_df{i},2);
end
minROI=min(sizeROI);

%Get coordinates 
for i=1:size(C_df,2)
for r=1:minROI
[B{i}{r},L{i}{r}] = bwboundaries(ROI_sh{i}(:,:,r));
ROI_shape{i}{r}=(ROI_sh{i}(:,:,r));
%ROI_shape{i}{r}( ~any(ROI_shape{i}{r},2), : ) = [];  %rows
%ROI_shape{i}{r}( :, ~any(ROI_shape{i}{r},1) ) = [];  %columns
for k = 1:length(B{i}{r})
coord{i}{r}=B{i}{r}{1};
end
end
end
for i = 1:size(C_df,2)
for ii= 1:size(C_df,2)
for r=1:minROI
[corr_ROI{i}(ii,r)] = corr2(ROI_shape{i}{r},ROI_shape{ii}{r});
rem_ROI{i}=find(corr_ROI{i}(ii,:)<=corr_scor_min);
end
end 
end
rm_ROI=unique(cell2mat(rem_ROI));

%set color of contour for sessions
%all colors : https://www.mathworks.com/help/matlab/ref/colorspec.html
color=[{'g'} {'m'} {'b'} {'r'} {'k'} {'c'}];
%Plot all session 
%ROI_trace_GUI(ROI,C_df, ROI_sh,coord,color);
%OR
[rem_ROI]=ROI_trace_GUI_2(ROI,C_df, ROI_sh,coord,color,rem_ROI);
%Plot only choosen session 
% %for i=1:3
% %ROI_trace_GUI_session(ROI{i},C_df{i}, ROI_sh{i},coord{i});
% %end


