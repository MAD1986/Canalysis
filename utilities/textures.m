
function [Spatial_correlation] = textures(Behavior,Place_cell,Spatial_correlation);
%% Import data
sessions=Spatial_correlation.options.sessions; 
binbefore=Spatial_correlation.options.textures.bin_before_RFID; % how many bins before RFID signal considered as same texture
binafter=Spatial_correlation.options.textures.bin_after_RFID; % how many bins after RFID signal considered as same texture
name= Spatial_correlation.options.name;
Nbin=Place_cell{1, 1}.options.bin_spatial_tuning  ;
tuned_ROI=Spatial_correlation.tunedROI;
for i = sessions
rate_map{i}=Place_cell{i}.Spatial_tuning_curve;
event_map{i}=Place_cell{i}.Spatial_Info.event_map{8}  ;
mean_df_map{i}=Place_cell{i}.Spatial_Info.mean_dF_map{8};
occupancy_map{i}=Place_cell{i}.Spatial_Info.occupancy_map{8}  ;
%df map = normalized mean dF / occupancy (s)
df_map_non_norm{i}=Place_cell{i}.Spatial_Info.mean_dF_map_smooth{8}./Place_cell{i}.Spatial_Info.occupancy_map{8}';
end
for i = sessions
for n=1:size(df_map_non_norm{i},2)
df_map{i}(:,n)=(df_map_non_norm{i}(:,n)-min(df_map_non_norm{i}(:,n)))/(max(df_map_non_norm{i}(:,n))-min(df_map_non_norm{i}(:,n)));
end
end


%% Textures location

for s=sessions
for t=1:length(Behavior{s}.texture_position)
tex_pos{s}{t}=Behavior{s}.texture_position{t};
%Remove outliers (RFID when lap not complete)
out_tex_pos{s}{t}=[diff(tex_pos{s}{t}); 0];
for out=1:size(out_tex_pos{s}{t},1)
if out_tex_pos{s}{t}(out,1)>=10 %more than 10 cm between same RFID
tex_pos{s}{t}(out,1)=NaN;   
end
end
mean_tex_pos{s}(:,t)=nanmean(tex_pos{s}{t});
end
end

%Find closet bin to position of RFID
for s=sessions
for t=1:length(Behavior{s}.texture_position)
[err_bin_pos{s}(t) bin_tex{s}(t)] = min(abs(Place_cell{s}.Position_Bin{8}  -mean_tex_pos{s}(t)));
end
end

%% Find swapped texture
rotated_tex=abs(bin_tex{sessions(1)} - bin_tex{sessions(2)})>10; %rotated texture= change >10 bins
bins_move=bin_tex{sessions(2)}(rotated_tex);%Bins to switch on the first session
bins_go=bin_tex{sessions(1)}(rotated_tex); %New positions for moved bins

%Rotate X bins before, X bins after (1bins = 2cm);
for i=1:size(bins_move,2)
bins_move_all(:,i)=((bins_move(i))-binbefore:(bins_move(i))+binafter) ;
bins_go_all(:,i)=((bins_go(i))-binbefore:(bins_go(i))+binafter) ;
end
%If bin to swap is 1 go back to end bins
for j=1:size(bins_move,2)
for i=1:size(bins_move_all,1)
for ii=1:size(bins_go_all,1)
if bins_move_all(i,j)<1, 
bins_move_all(i,j)=size(rate_map{sessions(1)},1)+bins_move_all(i,j);
end
if bins_go_all(ii,j)<1,
bins_go_all(ii,j)=size(rate_map{sessions(2)},1)+bins_go_all(ii,j);
end
end
end   
end
bins_swap=reshape(bins_move_all,[],1);
bins_new=reshape(bins_go_all,[],1);
bins_retained=setdiff((1:Nbin),bins_swap);

%% PV and TC correlation between swapped and unchanged texture
for i=1:size(sessions,2)
    %all
rate_map_swap{i}=rate_map{sessions(i)}(bins_swap,:);
rate_map_retained{i}=rate_map{sessions(i)}(bins_retained,:);
df_map_swap{i}=df_map{sessions(i)}(bins_swap,:);
df_map_retained{i}=df_map{sessions(i)}(bins_retained,:);
    %tuned
rate_map_tuned_swap{i}=rate_map{sessions(i)}(bins_swap,tuned_ROI);
rate_map_tuned_retained{i}=rate_map{sessions(i)}(bins_retained,tuned_ROI);
df_map_tuned_swap{i}=df_map{sessions(i)}(bins_swap,tuned_ROI);
df_map_tuned_retained{i}=df_map{sessions(i)}(bins_retained,tuned_ROI);
end

%PV corr
for sbins=1:size(rate_map_swap{sessions(1)},1)  
[PVcorr_swap(:,sbins)] = corr(rate_map_swap{sessions(1)}(sbins,:)',rate_map_swap{sessions(2)}(sbins,:)', 'rows', 'complete');
[PVcorr_tuned_swap(:,sbins)] = corr(rate_map_tuned_swap{sessions(1)}(sbins,:)',rate_map_tuned_swap{sessions(2)}(sbins,:)', 'rows', 'complete');
[PVcorr_df_swap(:,sbins)] = corr(df_map_swap{sessions(1)}(sbins,:)',df_map_swap{sessions(2)}(sbins,:)', 'rows', 'complete');
[PVcorr_df_tuned_swap(:,sbins)] = corr(df_map_tuned_swap{sessions(1)}(sbins,:)',df_map_tuned_swap{sessions(2)}(sbins,:)', 'rows', 'complete');
end
for rbins=1:size(rate_map_retained{sessions(1)},1)
[PVcorr_retained(:,rbins)] = corr(rate_map_retained{sessions(1)}(rbins,:)',rate_map_retained{sessions(2)}(rbins,:)', 'rows', 'complete');
[PVcorr_tuned_retained(:,rbins)] = corr(rate_map_tuned_retained{sessions(1)}(rbins,:)',rate_map_tuned_retained{sessions(2)}(rbins,:)', 'rows', 'complete');
[PVcorr_df_retained(:,rbins)] = corr(df_map_retained{sessions(1)}(rbins,:)',df_map_retained{sessions(2)}(rbins,:)', 'rows', 'complete');
[PVcorr_df_tuned_retained(:,rbins)] = corr(df_map_tuned_retained{sessions(1)}(rbins,:)',df_map_tuned_retained{sessions(2)}(rbins,:)', 'rows', 'complete');
end
Spatial_correlation.PV_correlation.AllROI.retained_bins.PVcorr=PVcorr_retained;
Spatial_correlation.PV_correlation.AllROI.swapped_bins.PVcorr=PVcorr_swap;
Spatial_correlation.PV_correlation.AllROI.retained_bins.PVcorr_dF=PVcorr_df_retained;
Spatial_correlation.PV_correlation.AllROI.swapped_bins.PVcorr_dF=PVcorr_df_swap;
Spatial_correlation.PV_correlation.TunedROI.retained_bins.PVcorr=PVcorr_tuned_retained;
Spatial_correlation.PV_correlation.TunedROI.swapped_bins.PVcorr=PVcorr_tuned_swap;
Spatial_correlation.PV_correlation.TunedROI.retained_bins.PVcorr_dF=PVcorr_df_tuned_retained;
Spatial_correlation.PV_correlation.TunedROI.swapped_bins.PVcorr_dF=PVcorr_df_tuned_swap;


%TC corr
for ROI=1:size(rate_map{sessions(1)},2)  
[TCcorr_swap(ROI)] = corr(rate_map_swap{sessions(1)}(:,ROI),rate_map_swap{sessions(2)}(:,ROI), 'rows', 'complete');
[TCcorr_df_swap(ROI)] = corr(df_map_swap{sessions(1)}(:,ROI),df_map_swap{sessions(2)}(:,ROI), 'rows', 'complete');
[TCcorr_retained(ROI)] = corr(rate_map_retained{sessions(1)}(:,ROI),rate_map_retained{sessions(2)}(:,ROI), 'rows', 'complete');
[TCcorr_df_retained(ROI)] = corr(df_map_retained{sessions(1)}(:,ROI),df_map_retained{sessions(2)}(:,ROI), 'rows', 'complete');
end
for ROI_t=1:size(rate_map_tuned_retained{sessions(1)},2)  
[TCcorr_tuned_swap(ROI_t)] = corr(rate_map_tuned_swap{sessions(1)}(:,ROI_t),rate_map_tuned_swap{sessions(2)}(:,ROI_t), 'rows', 'complete');
[TCcorr_df_tuned_swap(ROI_t)] = corr(df_map_tuned_swap{sessions(1)}(:,ROI_t),df_map_tuned_swap{sessions(2)}(:,ROI_t), 'rows', 'complete');
[TCcorr_tuned_retained(ROI_t)] = corr(rate_map_tuned_retained{sessions(1)}(:,ROI_t),rate_map_tuned_retained{sessions(2)}(:,ROI_t), 'rows', 'complete');
[TCcorr_df_tuned_retained(ROI_t)] = corr(df_map_tuned_retained{sessions(1)}(:,ROI_t),df_map_tuned_retained{sessions(2)}(:,ROI_t), 'rows', 'complete');
end
Spatial_correlation.TC_correlation.AllROI.retained_bins.TCcorr=TCcorr_retained;
Spatial_correlation.TC_correlation.AllROI.swapped_bins.TCcorr=TCcorr_swap;
Spatial_correlation.TC_correlation.AllROI.retained_bins.TCcorr_dF=TCcorr_df_retained;
Spatial_correlation.TC_correlation.AllROI.swapped_bins.TCcorr_dF=TCcorr_df_swap;
Spatial_correlation.TC_correlation.TunedROI.retained_bins.TCcorr=TCcorr_tuned_retained;
Spatial_correlation.TC_correlation.TunedROI.swapped_bins.TCcorr=TCcorr_tuned_swap;
Spatial_correlation.TC_correlation.TunedROI.retained_bins.TCcorr_dF=TCcorr_df_tuned_retained;
Spatial_correlation.TC_correlation.TunedROI.swapped_bins.TCcorr_dF=TCcorr_df_tuned_swap;
end 







%% Plot

