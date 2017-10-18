
function [Spatial_correlation] = corr_score(Spatial_correlation,Place_cell, plot_corr);

%% Import data / fix bug
sessions=Spatial_correlation.options.sessions;
tuned_ROI=Spatial_correlation.tunedROI;
name=Spatial_correlation.options.name;
multcomp=Spatial_correlation.options.multcomp;


bwmap=Spatial_correlation.options.bw_cmap; %use custom B%W colormap
%Custom cmap
custom_cmap=[0,0,0;0.00244200252927840,0.00244200252927840,0.00244200252927840;0.00488400505855680,0.00488400505855680,0.00488400505855680;0.00732600782066584,0.00732600782066584,0.00732600782066584;0.00976801011711359,0.00976801011711359,0.00976801011711359;0.0122100133448839,0.0122100133448839,0.0122100133448839;0.0146520156413317,0.0146520156413317,0.0146520156413317;0.0170940179377794,0.0170940179377794,0.0170940179377794;0.0195360202342272,0.0195360202342272,0.0195360202342272;0.0219780225306749,0.0219780225306749,0.0219780225306749;0.0244200266897678,0.0244200266897678,0.0244200266897678;0.0268620289862156,0.0268620289862156,0.0268620289862156;0.0293040312826633,0.0293040312826633,0.0293040312826633;0.0317460335791111,0.0317460335791111,0.0317460335791111;0.0485437586903572,0.0485437586903572,0.0485437586903572;0.0653414800763130,0.0653414800763130,0.0653414800763130;0.0821392089128494,0.0821392089128494,0.0821392089128494;0.0989369302988052,0.0989369302988052,0.0989369302988052;0.115734651684761,0.115734651684761,0.115734651684761;0.132532373070717,0.132532373070717,0.132532373070717;0.149330109357834,0.149330109357834,0.149330109357834;0.166127830743790,0.166127830743790,0.166127830743790;0.182925552129745,0.182925552129745,0.182925552129745;0.199723273515701,0.199723273515701,0.199723273515701;0.216520994901657,0.216520994901657,0.216520994901657;0.233318716287613,0.233318716287613,0.233318716287613;0.250116437673569,0.250116437673569,0.250116437673569;0.266914159059525,0.266914159059525,0.266914159059525;0.283711880445480,0.283711880445480,0.283711880445480;0.300509631633759,0.300509631633759,0.300509631633759;0.317307353019714,0.317307353019714,0.317307353019714;0.334105074405670,0.334105074405670,0.334105074405670;0.350902795791626,0.350902795791626,0.350902795791626;0.367700517177582,0.367700517177582,0.367700517177582;0.384498238563538,0.384498238563538,0.384498238563538;0.429928451776505,0.429928451776505,0.429928451776505;0.475358664989471,0.475358664989471,0.475358664989471;0.520788848400116,0.520788848400116,0.520788848400116;0.566219091415405,0.566219091415405,0.566219091415405;0.611649274826050,0.611649274826050,0.611649274826050;0.657079517841339,0.657079517841339,0.657079517841339;0.702509701251984,0.702509701251984,0.702509701251984;0.747939944267273,0.747939944267273,0.747939944267273;0.793370127677918,0.793370127677918,0.793370127677918;0.838800370693207,0.838800370693207,0.838800370693207;0.884230554103851,0.884230554103851,0.884230554103851;0.890662193298340,0.890662193298340,0.890662193298340;0.897093832492828,0.897093832492828,0.897093832492828;0.903525471687317,0.903525471687317,0.903525471687317;0.909957110881805,0.909957110881805,0.909957110881805;0.916388750076294,0.916388750076294,0.916388750076294;0.922820389270783,0.922820389270783,0.922820389270783;0.929252028465271,0.929252028465271,0.929252028465271;0.935683667659760,0.935683667659760,0.935683667659760;0.942115306854248,0.942115306854248,0.942115306854248;0.948546886444092,0.948546886444092,0.948546886444092;0.954978525638580,0.954978525638580,0.954978525638580;0.961410164833069,0.961410164833069,0.961410164833069;0.967841804027557,0.967841804027557,0.967841804027557;0.974273443222046,0.974273443222046,0.974273443222046;0.980705082416534,0.980705082416534,0.980705082416534;0.987136721611023,0.987136721611023,0.987136721611023;0.993568360805512,0.993568360805512,0.993568360805512;1,1,1];
cmap=Spatial_correlation.options.cmap; %use colormap http://www.mathworks.com/help/matlab/ref/colormap.html




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
[PVcorr_tuned{i}{ii}(:,iii)] = corr(rate_map{i}(iii,tuned_ROI)',rate_map{ii}(iii,tuned_ROI)', 'rows', 'complete');
PVcorr_mean{i}{ii}= nanmean(PVcorr{i}{ii});
PVcorr_tuned_mean{i}{ii}=nanmean(PVcorr_tuned{i}{ii});
end
end
end

%WRONG
% for i = sessions
% for ii= sessions 
% PVcorr_tuned{i}{ii}=PVcorr{i}{ii}(:,tuned_ROI);
% PVcorr_tuned_mean{i}{ii}=nanmean(PVcorr_tuned{i}{ii});
% end
% end 

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
% color map
if bwmap==1
rate_cmap=custom_cmap;
elseif bwmap==0
rate_cmap=cmap;
end


% Plot matrix
figure; 
for i=1:size(plot_corr,2)
    subplot(1,size(plot_corr,2),i)
imagesc(PVmatrix{plot_corr{i}(1)}{plot_corr{i}(end)});
colormap(rate_cmap);
title({'All ROI', [Spatial_correlation.options.name{plot_corr{i}(1)}, ' VS ', Spatial_correlation.options.name{plot_corr{i}(end)} ]})
end

figure; 
for i=1:size(plot_corr,2)
    subplot(1,size(plot_corr,2),i)
imagesc(PVmatrix_tuned{plot_corr{i}(1)}{plot_corr{i}(end)});
colormap(rate_cmap);
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

 for i=1:size(plot_corr,2)
ttl{i}=[name{plot_corr{i}(1)} ' VS '  name{plot_corr{i}(end)}];
end 

%% Multiple comparison 
if multcomp==1

    % PV CORRELATION
    
%anova PV corr all ROI
figure
[p_PV,tbl_PV,stats_PV] = anova1(PV_corr_test);
title({'PV correlation all ROI', ttl{1:size(PV_corr_test,2)}})
figure
c_PV = multcompare(stats_PV);
title({'PV correlation all ROI', ttl{1:size(PV_corr_test,2)}})

%anova PV corr tuned ROI
figure
[p_PV_t,tbl_PV_t,stats_PV_t] = anova1(PV_corr_tuned_test);
title({'PV correlation tuned ROI', ttl{1:size(PV_corr_tuned_test,2)}})
figure
c_PV_t = multcompare(stats_PV_t);
title({'PV correlation tuned ROI', ttl{1:size(PV_corr_tuned_test,2)}})

    %TC CORRELATION

%anova TC corr all ROI
figure
[p_TC,tbl_TC,stats_TC] = anova1(TC_corr_test);
title({'TC correlation all ROI', ttl{1:size(TC_corr_test,2)}})
figure
c_TC = multcompare(stats_TC);
title({'TC correlation all ROI', ttl{1:size(TC_corr_test,2)}})

%anova TC corr tuned ROI
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

end


