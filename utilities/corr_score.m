
function [Spatial_correlation] = corr_score(Spatial_correlation,Place_cell, plot_corr);

%% Import data / fix bug
sessions=Spatial_correlation.options.sessions;
tuned_ROI=Spatial_correlation.tunedROI;
name=Spatial_correlation.options.name;
multcomp=Spatial_correlation.options.multcomp;
for i = sessions
rate_map{i}=Place_cell{i}.Spatial_tuning_curve;
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
end

%% Population Vector correlation: 

% PV matrix 
for i = sessions
for ii= sessions
    %all roi
[PVmatrix{i}{ii}] = corr(rate_map{i}',rate_map{ii}', 'rows', 'complete');
matrixnb{i}{ii}=[i ii];
    %tuned ROI
[PVmatrix_tuned{i}{ii}] = corr(rate_map{i}(:,tuned_ROI)',rate_map{ii}(:,tuned_ROI)', 'rows', 'complete');
end
end 

% PV correlation
for i = sessions
for ii= sessions
for iii=1:size(rate_map{i},1)  
[PVcorr{i}{ii}(:,iii)] = corr(rate_map{i}(iii,:)',rate_map{ii}(iii,:)', 'rows', 'complete');
PVcorrind{i}{ii}=[i ii];
PVcorr_mean{i}{ii}= nanmean(PVcorr{i}{ii});
end
end
end

for i = sessions
for ii= sessions 
PVcorr_tuned{i}{ii}=PVcorr{i}{ii}(:,tuned_ROI);
PVcorr_tuned_mean{i}{ii}=nanmean(PVcorr_tuned{i}{ii});
end
end 

%Make structure
% Spatial_correlation.PV_correlation.AllROI.PV_matrix=PVmatrix;
% Spatial_correlation.PV_correlation.AllROI.PVcorr=PVcorr;
% Spatial_correlation.PV_correlation.AllROI.PVcorr_mean=PVcorr_mean;
% Spatial_correlation.PV_correlation.TunedROI.PV_matrix=PVmatrix_tuned;
% Spatial_correlation.PV_correlation.TunedROI.PVcorr_tuned=PVcorr_tuned;
% Spatial_correlation.PV_correlation.TunedROI.PVcorr_mean=PVcorr_tuned_mean;

%% Tuning Curve correlation
%All neurons
for i = sessions
for ii= sessions
 for iii=1:size(rate_map{i},2)  
[TCcorr{i}{ii}(iii)] = corr(rate_map{i}(:,iii),rate_map{ii}(:,iii), 'rows', 'complete');
TCcorrind{i}{ii}=[i ii];
end
end
end
%Tuned ROI
for i = sessions
for ii= sessions
TCcorr_tuned{i}{ii}=TCcorr{i}{ii}(:,tuned_ROI);
TCcorr_mean{i}{ii}= nanmean(TCcorr{i}{ii});
TCcorr_tuned_mean{i}{ii}= nanmean(TCcorr_tuned{i}{ii});
end
end 
%Make structure
%Spatial_correlation.TC_correlation.AllROI.TCcorr=TCcorr;
%Spatial_correlation.TC_correlation.AllROI.TCcorr_mean=TCcorr_mean;
%Spatial_correlation.TC_correlation.TunedROI.TCcorr=TCcorr_tuned;
%Spatial_correlation.TC_correlation.TunedROI.TCcorr_mean=TCcorr_tuned_mean;


%% Display figure

% Plot matrix
figure; 
for i=1:size(plot_corr,2)
    subplot(1,size(plot_corr,2),i)
imagesc(PVmatrix{plot_corr{i}(1)}{plot_corr{i}(end)});
colormap('Jet');
title({'All ROI', [Spatial_correlation.options.name{plot_corr{i}(1)}, ' VS ', Spatial_correlation.options.name{plot_corr{i}(end)} ]})
end

figure; 
for i=1:size(plot_corr,2)
    subplot(1,size(plot_corr,2),i)
imagesc(PVmatrix_tuned{plot_corr{i}(1)}{plot_corr{i}(end)});
colormap('Jet');
title({'Tuned ROI', [Spatial_correlation.options.name{plot_corr{i}(1)}, ' VS ', Spatial_correlation.options.name{plot_corr{i}(end)} ]})
end
for i=1:size(plot_corr,2)
PV_corr_test(:,i)=PVcorr{plot_corr{i}(1)}{plot_corr{i}(end)};
PV_corr_tuned_test(:,i)=PVcorr_tuned{plot_corr{i}(1)}{plot_corr{i}(end)};
PVmatrix_test=PVmatrix{plot_corr{i}(1)}{plot_corr{i}(end)};
PVmatrix_tuned_test=PVmatrix_tuned{plot_corr{i}(1)}{plot_corr{i}(end)};
TC_corr_test(:,i)=TCcorr{plot_corr{i}(1)}{plot_corr{i}(end)};
TC_corr_tuned_test(:,i)=TCcorr_tuned{plot_corr{i}(1)}{plot_corr{i}(end)};
end 


if multcomp==1
 for i=1:size(plot_corr,2)
ttl{i}=[name{plot_corr{i}(1)} ' VS '  name{plot_corr{i}(end)}];
end 
%anova PV corr
figure
[p_PV,tbl_PV,stats_PV] = anova1(PV_corr_test);
title({'PV correlation', ttl{1:size(PV_corr_test,2)}})
figure
c_PV = multcompare(stats_PV);
title({'PV correlation', ttl{1:size(PV_corr_test,2)}})

%anova TC corr all ROI
figure
[p_TC,tbl_TC,stats_TC] = anova1(TC_corr_test);
title({'TC correlation all ROI', ttl{1:size(TC_corr_test,2)}})
figure
c_TC = multcompare(stats_TC);
title({'TC correlation all ROI', ttl{1:size(TC_corr_test,2)}})

%anova TC corr all ROI
figure
[p_TC_t,tbl_TC_t,stats_TC_t] = anova1(TC_corr_tuned_test);
title({'TC correlation tuned ROI', ttl{1:size(TC_corr_tuned_test,2)}})
figure
c_TC_t = multcompare(stats_TC_t);
title({'TC correlation tuned ROI', ttl{1:size(TC_corr_tuned_test,2)}})
end 


%% Make structure 
Spatial_correlation.PV_correlation.AllROI.PV_matrix=PVmatrix_test;
Spatial_correlation.PV_correlation.AllROI.PVcorr=PV_corr_test;
Spatial_correlation.PV_correlation.TunedROI.PV_matrix=PVmatrix_tuned_test;
Spatial_correlation.PV_correlation.TunedROI.PVcorr_tuned=PV_corr_tuned_test;
Spatial_correlation.TC_correlation.AllROI.TCcorr=TC_corr_test;
Spatial_correlation.TC_correlation.TunedROI.TCcorr=TC_corr_tuned_test;
Spatial_correlation.TC_correlation.Index=ttl;
Spatial_correlation.PV_correlation.Index=ttl;

end


