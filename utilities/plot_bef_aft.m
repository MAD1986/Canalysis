function [Results]=plot_bef_aft(Results,rows_sub,properties,session,events_mean)

col_sub=size(properties,1)/rows_sub;
bg_title={'All', 'Running epochs', 'Non running epochs'};
% mean for all experiment
for st=1:size(events_mean,2)
for ses=1:length(session)
events_mean_all{st}{ses}=cell2mat(events_mean{st}{ses}');
end
end
%Test session 1 vs session 2
for st=1:size(events_mean,2)
for prop=1:size(properties,1)
for ses=1:length(session)
bef_aft{st}{prop}(:,ses)=events_mean_all{st}{ses}(:,prop);
end
end
end

for st=1:size(events_mean,2)
figure
for prop=1:size(properties,1)
%paired t-test all
%Wilcoxon signed rank test
[p_value(st,prop),hyp(st,prop)] = signrank(bef_aft{st}{prop}(:,1), bef_aft{st}{prop}(:,2));
subplot(rows_sub,col_sub,prop)
boxplot(bef_aft{st}{prop},'Labels', session)
suptitle(bg_title{st})
nan_nb{st}(:,prop)=sum(~isnan(bef_aft{st}{prop}),2);
N_pairs{st}=sum(nan_nb{st}==2);
title({properties{prop}, ['N = ' num2str(N_pairs{st}(:,prop))]} );
if hyp(st,prop)==1
sigstar([1,2], p_value(st,prop))
end
end
end



%make histogram session 1 vs session 2
for st=1:size(events_mean,2)
figure;
for prop=1:size(properties,1)
subplot(rows_sub,col_sub,prop)
for ses=1:length(session)
hold on;
histogram(events_mean_all{st}{ses}(:,prop)); 
nan_nb{st}(:,prop)=sum(~isnan(bef_aft{st}{prop}),2);
N_pairs{st}=sum(nan_nb{st}==2);
title({properties{prop}, ['N = ' num2str(N_pairs{st}(:,prop))]} );
legend(session)
end
hold off
end
suptitle(bg_title{st})
end

%% Make a structure with results (p value)
str_nam={'All', 'Run', 'NoRun'};
for st=1:size(events_mean,2)
for prop=1:size(properties,1)
Results.(str_nam{st}).(properties{prop}).pvalue=p_value(st,prop);
Results.(str_nam{st}).(properties{prop}).N=N_pairs{st}(prop);
Results.(str_nam{st}).(properties{prop}).Before_After=bef_aft{st}{prop};
end
end
end

