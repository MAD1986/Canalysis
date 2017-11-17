%% Export ROI for imageJ as .txt
% Use in Fiji : File > Import > XY coordinates

%% Import only tuned ROI
%If using Canalysis script, just open Result
%Need C_df, ROI, and rm_ROI (the ROI to remove from) 
ROInb=1:size(C_df{1},2);
keep_ROI=setdiff(ROI, rm_ROI);
for s=1:size(C_df,2)
for i=1:numel(Place_cell{s}.Tuned_ROI)
tunedNB{s}(i)=keep_ROI(Place_cell{s}.Tuned_ROI(i));
end
tuningSpeROI{s}=find(Place_cell{s}.Tuning_Specificity.significant_ROI==1); 
for i=1:numel(tuningSpeROI{s})
tuningSpeNB{s}(i)=keep_ROI(tuningSpeROI{s}(i));
end
end

%% Open mat files with ROI
%FOR RZ you need to have multiple .mat files 
%(1_sessionA_ROI.mat, 2_sessionB_ROI.mat,...)
%   NEED:
%   A2,Cn,Cn_max,Coor,b2,center,f2,keep
listmat = dir('*.mat'); %will look for all the mat files
for i = 1:length(listmat)
ROI_files{i} = load((listmat(i).name));
end

%% Export as .txt

export_tuned=1; %Tuned ROI (tuning spe + spatial)
export_tuning=1; %Tuning Spe ROI

mkdir('ROI_Coord');
cd('ROI_Coord');


if export_tuned==1;
mkdir('Tuned_ROI')
cd('Tuned_ROI');
for s=1:size(ROI_files,2)
mkdir(['session_' num2str(s)])
cd(['session_' num2str(s)]);
for i=1:numel(tunedNB{s})
coord{s}{i}=ROI_files{s}.Coor{i}';
dlmwrite(['ROI' num2str(i)],[coord{s}{tunedNB{s}(i)}(:,2) coord{s}{tunedNB{s}(i)}(:,1)])
end
cd ..
end
cd ..
end


if export_tuning==1;
mkdir('Tuning_Spe_ROI')
cd('Tuning_Spe_ROI')
for s=1:size(ROI_files,2)
mkdir(['session_' num2str(s)])
cd(['session_' num2str(s)]);
for i=1:numel(tuningSpeNB{s})
coord{s}{i}=ROI_files{s}.Coor{i}';
dlmwrite(['ROI' num2str(i)],[coord{s}{tuningSpeNB{s}(i)}(:,2) coord{s}{tuningSpeNB{s}(i)}(:,1)])
end
cd ..
end
cd ..
end



