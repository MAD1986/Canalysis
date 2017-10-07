function [Spatial_correlation] = plot_tuning(Spatial_correlation,Place_cell)

%% Import data

tuned_ROI=Spatial_correlation.tunedROI;
sessions=Spatial_correlation.options.sessions;
order=Spatial_correlation.options.order;
sm=Spatial_correlation.options.ratemapsm;
criteria1=Spatial_correlation.options.tuned_criteria1;
criteria2=Spatial_correlation.options.tuned_criteria2; 
tuned_ses=Spatial_correlation.options.tuned_session;

for i = sessions
ordered_rate_map{i}=Place_cell{i}.Spatial_tuning_curve_sorted; 
rate_map{i}=Place_cell{i}.Spatial_tuning_curve;
ROI_rate_map{i}=Place_cell{i}.ROI_Spatial_tuning_sorted;
end

%Bug with missing last ROI
for i = sessions
nbROI(i)=size(rate_map{i},2);
nbROI(nbROI==0)=NaN;
maxROI=max(nbROI); %max nb of ROI for each session
%misROI{i}=setdiff(1:nbROI,ROI_rate_map{i});%find the missing ROI for each session
semisROI=nbROI<maxROI;
missingROI=min(nbROI)+1:maxROI;
while size(rate_map{i},2)<maxROI 
rate_map{i}=[rate_map{i} nan(size(rate_map{i},1),1)]; %replace missing last ROI with NaN
end
while size(ordered_rate_map{i},1)<maxROI 
ordered_rate_map{i}=[ordered_rate_map{i}; (nan(size(ordered_rate_map{i},2),1))'];
end    
while size(ROI_rate_map{i},1)<maxROI 
ROI_rate_map{i}=[ROI_rate_map{i}; nan];
end
end  



%% Order rate map for selected session
%remove nan
for i = sessions 
find_nan(i,:)=sum(isnan(rate_map{i}))>=1;
end
nan_ROI=find(sum(find_nan)>=1);
ROI_OR=ROI_rate_map{order};
ROI_OR_nan_idx=find(sum(ROI_OR==nan_ROI,2));
ROI_OR_nn=ROI_OR;
ROI_OR_nn(ROI_OR_nan_idx)=[];

%Find idx for tuned ROI
ROI_OR_tuned_idx=find(sum(ROI_OR_nn==tuned_ROI,2));

%order tuning curve
for ii = sessions 
for i = 1:size(ROI_OR_nn,1);
ordered_map{ii}(i,:)=rate_map{ii}(:,ROI_OR_nn(i));
end
end

% Smooth 
if sm>0
for i=sessions
for ii=1:size(ordered_map{i},1)
ordered_map_sm{i}(ii,:)=imgaussfilt(ordered_map{i}(ii,:),sm);
end
end
end

%% Plot tuning curve 
%Smooth 
%all ROI
if sm>0
figure
for i = sessions 
subplot(1, length(sessions),i)
imagesc(ordered_map_sm{i});
title([Spatial_correlation.options.name{i}, ' All ROI '])
end
%Tuned ROI
figure
for i = sessions 
subplot(1, length(sessions),i)
imagesc(ordered_map_sm{i}(ROI_OR_tuned_idx,:));
title([{Spatial_correlation.options.name{i}, ' tuned ROI', ['session ' num2str(tuned_ses)],[ criteria1 '  ' criteria2]}])
end
end

%No smooth 
%all ROI
if sm==0
figure
for i = sessions 
subplot(1, length(sessions),i)
imagesc(ordered_map{i});
title([Spatial_correlation.options.name{i}, ' All ROI '])
end
%Tuned ROI
figure
for i = sessions 
subplot(1, length(sessions),i)
imagesc(ordered_map{i}(ROI_OR_tuned_idx,:));
title([{Spatial_correlation.options.name{i}, ' tuned ROI', ['session ' num2str(tuned_ses)],[ criteria1 '  ' criteria2]}])
end
end

Spatial_correlation.ordered_map=ordered_map;

end

