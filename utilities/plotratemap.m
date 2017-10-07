function [Spatial_correlation] = plotratemap(Spatial_correlation,Place_cell)
sessions=Spatial_correlation.options.sessions;
order=Spatial_correlation.options.order;
sm=Spatial_correlation.options.ratemapsm;
criteria1=Spatial_correlation.options.tuned_criteria1;
%% Plot all neurons
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

for i = 1:size(ROI_rate_map{order},1);
if isnan(ordered_rate_map{order}(i,:))
    ROI_rate_map{order}(i)=NaN;
ROI_rate_map_nonan=ROI_rate_map{order}(~any(isnan(ROI_rate_map{order}),2),:);
elseif isnan(ordered_rate_map{order}(i,:))==0
   ROI_rate_map_nonan=ROI_rate_map{order}(~any(isnan(ROI_rate_map{order}),2),:); 
end
end

if any(semisROI(order))==0
misind=find(ismember(ROI_rate_map_nonan,missingROI));
ROI_rate_map_nonan(misind)=NaN;
end
ROI_rate_map_nonan=ROI_rate_map_nonan(~any(isnan(ROI_rate_map_nonan),2),:);

for ii = sessions 
for i = 1:size(ROI_rate_map_nonan,1);
ordered_map{ii}(i,:)=rate_map{ii}(:,ROI_rate_map_nonan(i));
end
end

%IF Smooth 
if sm>0
for i=sessions
for ii=1:size(ordered_map{i},1)
ordered_map_sm{i}(ii,:)=imgaussfilt(ordered_map{i}(ii,:),sm);
%ordered_map_sm{i}(ii,:)=Smooth(ordered_map{i}(ii,:),sm);
end
end
end
%Plot figure
if sm>0
for i = sessions 
figure;
imagesc(ordered_map_sm{i});
title([Spatial_correlation.options.title{i}, ' tuned ROI ', criteria1])
end
end
%Plot figure no smooth
if sm<=0
for i = sessions
figure;
imagesc(ordered_map{i});
title(Spatial_correlation.options.title{i})
end
end
Spatial_correlation.ordered_map=ordered_map;



