
function [Spatial_correlation] = textures(Behavior,Place_cell,Spatial_correlation);
%% Import data
sessions=Spatial_correlation.options.sessions; 
binbefore=Spatial_correlation.options.textures.bin_before_RFID; % how many bins before RFID signal considered as same texture
binafter=Spatial_correlation.options.textures.bin_after_RFID; % how many bins after RFID signal considered as same texture
name= Spatial_correlation.options.name;
Nbin=Place_cell{1, 1}.options.bin_spatial_tuning  ;
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
for i=sessions
rate_map_swap{i}=rate_map{i}(bins_swap,:);
rate_map_retained{i}=rate_map{i}(bins_retained,:);
df_map_swap{i}=df_map{i}(bins_swap,:);
df_map_retained{i}=df_map{i}(bins_retained,:);
end

%PV matrix
for i = sessions
for ii= sessions
    %all roi
[PVmatrix_swap{i}{ii}] = corr(rate_map_swap{i}',rate_map_swap{ii}', 'rows', 'complete');
[PVmatrix_retained{i}{ii}] = corr(rate_map_retained{i}',rate_map_retained{ii}', 'rows', 'complete');
[PVmatrix_df_swap{i}{ii}] = corr(df_map_swap{i}',df_map_swap{ii}', 'rows', 'complete');
[PVmatrix_df_retained{i}{ii}] = corr(df_map_retained{i}',df_map_retained{ii}', 'rows', 'complete');
end 
end




%% Plot

