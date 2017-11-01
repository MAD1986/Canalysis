function [Spatial_correlation] = plot_tuning(Spatial_correlation,Place_cell)

%% Import data

tuned_ROI=Spatial_correlation.tunedROI;
sessions=Spatial_correlation.options.sessions;
order=Spatial_correlation.options.order;
sm=Spatial_correlation.options.ratemapsm;
criteria1=Spatial_correlation.options.tuned_criteria1;
criteria2=Spatial_correlation.options.tuned_criteria2; 
tuned_ses=Spatial_correlation.options.tuned_session;
bwmap=Spatial_correlation.options.bw_cmap; %use custom B%W colormap
%Custom cmap
custom_cmap=[0,0,0;0.00244200252927840,0.00244200252927840,0.00244200252927840;0.00488400505855680,0.00488400505855680,0.00488400505855680;0.00732600782066584,0.00732600782066584,0.00732600782066584;0.00976801011711359,0.00976801011711359,0.00976801011711359;0.0122100133448839,0.0122100133448839,0.0122100133448839;0.0146520156413317,0.0146520156413317,0.0146520156413317;0.0170940179377794,0.0170940179377794,0.0170940179377794;0.0195360202342272,0.0195360202342272,0.0195360202342272;0.0219780225306749,0.0219780225306749,0.0219780225306749;0.0244200266897678,0.0244200266897678,0.0244200266897678;0.0268620289862156,0.0268620289862156,0.0268620289862156;0.0293040312826633,0.0293040312826633,0.0293040312826633;0.0317460335791111,0.0317460335791111,0.0317460335791111;0.0485437586903572,0.0485437586903572,0.0485437586903572;0.0653414800763130,0.0653414800763130,0.0653414800763130;0.0821392089128494,0.0821392089128494,0.0821392089128494;0.0989369302988052,0.0989369302988052,0.0989369302988052;0.115734651684761,0.115734651684761,0.115734651684761;0.132532373070717,0.132532373070717,0.132532373070717;0.149330109357834,0.149330109357834,0.149330109357834;0.166127830743790,0.166127830743790,0.166127830743790;0.182925552129745,0.182925552129745,0.182925552129745;0.199723273515701,0.199723273515701,0.199723273515701;0.216520994901657,0.216520994901657,0.216520994901657;0.233318716287613,0.233318716287613,0.233318716287613;0.250116437673569,0.250116437673569,0.250116437673569;0.266914159059525,0.266914159059525,0.266914159059525;0.283711880445480,0.283711880445480,0.283711880445480;0.300509631633759,0.300509631633759,0.300509631633759;0.317307353019714,0.317307353019714,0.317307353019714;0.334105074405670,0.334105074405670,0.334105074405670;0.350902795791626,0.350902795791626,0.350902795791626;0.367700517177582,0.367700517177582,0.367700517177582;0.384498238563538,0.384498238563538,0.384498238563538;0.429928451776505,0.429928451776505,0.429928451776505;0.475358664989471,0.475358664989471,0.475358664989471;0.520788848400116,0.520788848400116,0.520788848400116;0.566219091415405,0.566219091415405,0.566219091415405;0.611649274826050,0.611649274826050,0.611649274826050;0.657079517841339,0.657079517841339,0.657079517841339;0.702509701251984,0.702509701251984,0.702509701251984;0.747939944267273,0.747939944267273,0.747939944267273;0.793370127677918,0.793370127677918,0.793370127677918;0.838800370693207,0.838800370693207,0.838800370693207;0.884230554103851,0.884230554103851,0.884230554103851;0.890662193298340,0.890662193298340,0.890662193298340;0.897093832492828,0.897093832492828,0.897093832492828;0.903525471687317,0.903525471687317,0.903525471687317;0.909957110881805,0.909957110881805,0.909957110881805;0.916388750076294,0.916388750076294,0.916388750076294;0.922820389270783,0.922820389270783,0.922820389270783;0.929252028465271,0.929252028465271,0.929252028465271;0.935683667659760,0.935683667659760,0.935683667659760;0.942115306854248,0.942115306854248,0.942115306854248;0.948546886444092,0.948546886444092,0.948546886444092;0.954978525638580,0.954978525638580,0.954978525638580;0.961410164833069,0.961410164833069,0.961410164833069;0.967841804027557,0.967841804027557,0.967841804027557;0.974273443222046,0.974273443222046,0.974273443222046;0.980705082416534,0.980705082416534,0.980705082416534;0.987136721611023,0.987136721611023,0.987136721611023;0.993568360805512,0.993568360805512,0.993568360805512;1,1,1];
cmap=Spatial_correlation.options.cmap; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html

for i = sessions
ordered_rate_map{i}=Place_cell{i}.Spatial_tuning_curve_sorted; 
rate_map{i}=Place_cell{i}.Spatial_tuning_curve;
ROI_rate_map{i}=Place_cell{i}.ROI_Spatial_tuning_sorted;
dF_map{i}=Place_cell{i}.Spatial_tuning_dF  ;
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
% while size(dF_map{i},1)<maxROI 
% dF_map{i}=[dF_map{i} nan(size(dF_map{i},1),1)]
% end  
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
ordered_dF{ii}(i,:)=dF_map{ii}(:,ROI_OR_nn(i));
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

% color map
if bwmap==1
rate_cmap=custom_cmap;
elseif bwmap==0
rate_cmap=cmap;
end

%Smooth 
%all ROI
if sm>0
figure
for i = 1:length(sessions) 
subplot(1, length(sessions),i)
imagesc(ordered_map_sm{sessions(i)});
colormap(rate_cmap);
title([Spatial_correlation.options.name{sessions(i)}, 'rate map All ROI '])
end
%Tuned ROI
figure
for i = 1:length(sessions) 
subplot(1, length(sessions),i)
imagesc(ordered_map_sm{sessions(i)}(ROI_OR_tuned_idx,:));
colormap(rate_cmap);
title([{Spatial_correlation.options.name{sessions(i)}, 'rate map tuned ROI', Spatial_correlation.options.name_criteria1, ['session '  num2str(tuned_ses)]}]);
end
end

%No smooth 
%all ROI
if sm==0
figure
for i = 1:length(sessions) 
subplot(1, length(sessions),i)
imagesc(ordered_map{sessions(i)});
colormap(rate_cmap);
title([Spatial_correlation.options.name{sessions(i)}, 'rate map All ROI '])
end
%Tuned ROI
figure
for i = 1:length(sessions)  
subplot(1, length(sessions),i)
imagesc(ordered_map{sessions(i)}(ROI_OR_tuned_idx,:));
colormap(rate_cmap);
title([{Spatial_correlation.options.name{sessions(i)}, 'rate map tuned ROI', Spatial_correlation.options.name_criteria1, ['session ' num2str(tuned_ses)]}])
end
end


% dF map
figure
for i = 1:length(sessions)  
subplot(1, length(sessions),i)
imagesc(ordered_dF{sessions(i)});
colormap(rate_cmap);
title([Spatial_correlation.options.name{sessions(i)}, 'dF map All ROI '])
end
%Tuned ROI
figure
for i = 1:length(sessions) 
subplot(1, length(sessions),i)
imagesc(ordered_dF{sessions(i)}(ROI_OR_tuned_idx,:));
colormap(rate_cmap);
title([{Spatial_correlation.options.name{sessions(i)}, 'dF map tuned ROI', Spatial_correlation.options.name_criteria1, ['session ' num2str(tuned_ses)]}])
end



Spatial_correlation.ordered_map=ordered_map;
Spatial_correlation.ordered_dF_map=ordered_dF;
Spatial.correlation.options.custom_cmap=custom_cmap;


end

