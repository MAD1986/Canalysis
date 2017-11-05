function [Spatial_correlation] = tuned_ROI(Spatial_correlation,Place_cell)

%% Import data
pie_chart=Spatial_correlation.options.pie_sessions;
sessions=Spatial_correlation.options.tuned_session;
criteria1=Spatial_correlation.options.tuned_criteria1;
criteria2=Spatial_correlation.options.tuned_criteria2; 
% all_sessions=Spatial_correlation.options.sessions; % X:Y plot session X to Y
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
        name_criteria1='Spatial Information';

idx_ROI=zeros(size(sessions,2),maxROI);
idx_ROI_pie=zeros(size(sessions,2),maxROI);
for i=sessions
idx_ROI(i,:)=Place_cell{i}.Spatial_Info.significant_ROI ;
end
for i=pie_chart
idx_ROI_pie(i,:)=Place_cell{i}.Spatial_Info.significant_ROI ;
end
    case 'tuning'
        name_criteria1='Tuning Specificity';

idx_ROI=zeros(size(sessions,2),maxROI);
idx_ROI_pie=zeros(size(sessions,2),maxROI);
for i=sessions
idx_ROI(i,:)=Place_cell{i}.Tuning_Specificity.significant_ROI;
end
for i=pie_chart
idx_ROI_pie(i,:)=Place_cell{i}.Spatial_Info.significant_ROI ;
end
    case 'both'
        name_criteria1='Spatial Info + Tuning Spe';
        
idx_ROI=zeros(size(sessions,2),maxROI);
idx_ROI_pie=zeros(size(sessions,2),maxROI);   
for i=sessions
    idx_ROI(i, Place_cell{i}.Tuned_ROI)=1;
end
for i=pie_chart
    idx_ROI_pie(i, Place_cell{i}.Tuned_ROI)=1;
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
Spatial_correlation.options.name_criteria1= name_criteria1;



%% Pie chart
for i=1:size(idx_ROI_pie,1)
ROI_pie{i}=find(idx_ROI_pie(i,:)==1);
end
nb_tunedROI=[sum(idx_ROI_pie(pie_chart(1),:)') sum(idx_ROI_pie(pie_chart(2),:)')];
tuned_tot=unique([ROI_pie{pie_chart(1)} ROI_pie{pie_chart(2)}]);
nb_tuned_tot=numel(tuned_tot);

lost_ROI=setdiff(ROI_pie{pie_chart(1)}, ROI_pie{pie_chart(2)});
lost_nb=numel(lost_ROI);
new_ROI=setdiff(ROI_pie{pie_chart(2)}, ROI_pie{pie_chart(1)});
new_nb=numel(new_ROI);
retained_ROI=intersect(ROI_pie{pie_chart(2)}, ROI_pie{pie_chart(1)});
retained_nb=numel(retained_ROI);
lost_new=[lost_nb new_nb];
for i=1:size(pie_chart,2)
pie_session{i}=[retained_nb lost_new(i)];
end
pie_labels{1}={'Retained', 'Lost'};
pie_labels{2}={'Retained', 'New'};

chart_all=[retained_nb new_nb lost_nb];

Spatial_correlation.pie_chart=chart_all;
%Spatial_correlation.pie_labels=pie_labels;


% %% Venn diagramm
% %Work only for 3 sessions now
% %venn(Z) plots a Venn diagram with zone areas specified by the vector Z. 
% %Find all combination
% combo_ROI=combnk(all_sessions,all_sessions(end)-1);
% 
% for i= 1:size(combo_ROI,1)
% combo_ROI_only(i)=setdiff(all_sessions, combo_ROI(i,:))
% end
% 
% 
% %Find indices
% for i=1:size(idx_ROI_all,1)
%   ROI_all{i}=find(idx_ROI_all(i,:)==1);
% end
% %Find all combinations ROI
% for i=1:size(combo_ROI,1)
% comb_ROI{i}= intersect(ROI_all{combo_ROI(i,1)},ROI_all{combo_ROI(i,end)});
% comb_ROI_only{i}= setdiff(comb_ROI{i},ROI_all{combo_ROI_only(i,:)});
% nb_comb_ROI(i)=numel(comb_ROI{i});
% nb_comb_ROI_only(i)=numel(comb_ROI_only{i});
% end
%     
% % for i=all_sessions
% % for ii=1:size(idx_ROI_all,2)
% %     if idx_ROI_all(i,ii)>=1
% %     idx_ROI_session(i,ii)=i;
% % end
% % end
% % end
% 
% sum_idx_ROI=sum(idx_ROI_all);
% 
% %Find ROI only tuned 1 session 
% for i=all_sessions
%     for ii=1:size(idx_ROI_all,2)
%     if idx_ROI_all(i,ii)==1 & sum_idx_ROI(ii)<=1
% only_ROI_idx(i,ii)=1;
% only_ROI{i}=find(only_ROI_idx(i,:)==1);
% nb_only_ROI(i)=numel(only_ROI{i});
% end
% end
% end
% 
% %Find ROI tuned for all sessions
% all_ROI=find(sum_idx_ROI>=all_sessions(end));
% nb_all_ROI=numel(all_ROI);
% 
% %Venn diagramm Tuned session 1 , 2 , 3
% %venn(Z) plots a Venn diagram with zone areas specified by the vector Z. 
% %For a 3-circle venn, Z is a 7 element vector [z1 z2 z3 z12 z13 z23 z123]
% figure;
% Zvenn=[nb_only_ROI nb_comb_ROI_only nb_all_ROI];
% [H ,S]=venn(Zvenn);
% for i = 1:numel(Zvenn)
%  lgd= num2str(Zvenn(i));
% text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [lgd ])
% end



end

