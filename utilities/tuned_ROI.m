function [Spatial_correlation] = tuned_ROI(Spatial_correlation,Place_cell)

%% Import data
sessions=Spatial_correlation.options.tuned_session;
criteria1=Spatial_correlation.options.tuned_criteria1;
criteria2=Spatial_correlation.options.tuned_criteria2; 

%Bug with missing last ROI
tuned_ses=Spatial_correlation.options.tuned_session;
for i = sessions
rate_map{i}=Place_cell{i}.Spatial_tuning_curve;
end

for i = sessions
nbROI(i)=size(rate_map{i},2);
nbROI(nbROI==0)=NaN;
maxROI=max(nbROI); %max nb of ROI for each session
end

%% Find tuned ROI

% Define tuned - criteria 1 and 2
switch criteria1
    case 'info'
for i=sessions
idx_ROI(i,:)=Place_cell{i}.Spatial_Info.significant_ROI ;
end
    case 'tuning'
for i=sessions
idx_ROI(i,:)=Place_cell{i}.Tuning_Specificity.significant_ROI;
end
    case 'both'
idx_ROI=zeros(size(sessions,2),maxROI);   
for i=sessions
    idx_ROI(i, Place_cell{i}.Tuned_ROI)=1;
end
  otherwise
warning('Unexpected criteria. Use: info / tuning / both');
end

%select tuned ROI for the selected sessions
idx_ROI_ses=idx_ROI(tuned_ses,:);
switch criteria2
    case 'or'
tuned_ROI=find(sum(idx_ROI_ses,1)>=1);
    case 'and'
tuned_ROI=find(sum(idx_ROI_ses,1)>=length(tuned_ses));
  otherwise
warning('Unexpected criteria. Use: and/or');
end

Spatial_correlation.tunedROI=tuned_ROI;

end

