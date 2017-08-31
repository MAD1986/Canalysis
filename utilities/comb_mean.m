function [events_mean_cell,network_mean_cell, properties,network]= comb_mean(results,session)


%% Import all
for exp=1:length(results)
for ses=1:length(session)  % nb of session for each experiment
events_all{exp}.(session{ses})=results{exp}.Events{ses}.properties.noNaN  ;
events_run{exp}.(session{ses})=results{exp}.Events{ses}.Run.properties.noNaN  ;
events_norun{exp}.(session{ses})=results{exp}.Events{ses}.NoRun.properties.noNaN  ;
network_all{exp}.(session{ses})=results{exp}.Network{ses};
network_run{exp}.(session{ses})=results{exp}.Network{ses}.Run;
network_norun{exp}.(session{ses})=results{exp}.Network{ses}.NoRun;
end
end

%% Mean for each neuron and perform paired t-test on event properties
properties=fieldnames(events_all{1}.(session{1}));
%fix bug if not same number of ROI between sessions
% Fin minimun nb of ROI for each session
for exp=1:length(results)
for ses=1:length(session)  % nb of session for each experiment
for prop=1:size(properties,1) % measured event properties
 ROI_nb_all{exp}(ses,prop)=size(events_all{exp}.(session{ses}).(properties{prop}),2); %nb of ROI
 ROI_nb_run{exp}(ses,prop)=size(events_run{exp}.(session{ses}).(properties{prop}),2); %nb of ROI
 ROI_nb_norun{exp}(ses,prop)=size(events_norun{exp}.(session{ses}).(properties{prop}),2); %nb of ROI
end
end
minROI_all(exp,:)=min(ROI_nb_all{exp});
minROI_run(exp,:)=min(ROI_nb_run{exp});
minROI_norun(exp,:)=min(ROI_nb_norun{exp});
end
%Make table with mean results
for exp=1:length(results)
for ses=1:length(session)  % nb of session for each experiment
for prop=1:size(properties,1) % measured event properties
for neu=1:minROI_all(exp,prop)  %nb of ROI
events_mean_all_cell{ses}{exp}(neu,prop)=nanmean(events_all{exp}.(session{ses}).(properties{prop}){neu});
end
for neu=1:minROI_run(exp,prop)  %nb of ROI
events_mean_run_cell{ses}{exp}(neu,prop)=nanmean(events_run{exp}.(session{ses}).(properties{prop}){neu});
end
for neu=1:minROI_norun(exp,prop)   %nb of ROI
events_mean_norun_cell{ses}{exp}(neu,prop)=nanmean(events_norun{exp}.(session{ses}).(properties{prop}){neu});
end
end
end
end
%Make one table (ROI=rows, column=properties) for before and after
for ses=1:length(session)  % nb of session for each experiment
events_mean_all{ses}=cell2mat(events_mean_all_cell{ses}') ;
events_mean_run{ses}=cell2mat(events_mean_run_cell{ses}') ;
events_mean_norun{ses}=cell2mat(events_mean_norun_cell{ses}') ;
end

events_mean_cell={events_mean_all_cell  events_mean_run_cell  events_mean_norun_cell};



 %% Mean for each neuron and perform paired t-test on event properties
network=fieldnames(network_all{1}.(session{1}));
%Analyse :
%Frequeny (1), AUC_rate (2), nb_corr_pairs (5),  
%nb HC_neurons (6), nb_synchronous_epochs (11).
netvar=[1,2,5,6,11];
% Fin minimun nb of ROI for each session
for exp=1:length(results)
for ses=1:length(session)  % nb of session for each experiment
for prop=1:size(netvar(1:3),2) % measured network properties
 ROI_nb_all_net{exp}(ses,prop)=size(network_all{exp}.(session{ses}).(network{netvar(prop)}),2); %nb of ROI
 ROI_nb_run_net{exp}(ses,prop)=size(network_run{exp}.(session{ses}).(network{netvar(prop)}),2); %nb of ROI
 ROI_nb_norun_net{exp}(ses,prop)=size(network_norun{exp}.(session{ses}).(network{netvar(prop)}),2); %nb of ROI
end
end
minROI_all_net(exp,:)=min(ROI_nb_all_net{exp});
minROI_run_net(exp,:)=min(ROI_nb_run_net{exp});
minROI_norun_net(exp,:)=min(ROI_nb_norun_net{exp});
end

%Make table with mean results
for exp=1:length(results)
for ses=1:length(session)  % nb of session for each experiment
for prop=1:size(netvar(1:3),2) % measured event properties
for neu=1:min(min(minROI_all_net))  %nb of ROI
 network_mean_all_cell{ses}{exp}(neu,prop)=network_all{exp}.(session{ses}).(network{netvar(prop)})(:,neu);
end
 for neu=1:min(min(minROI_run_net))  %nb of ROI
 network_mean_run_cell{ses}{exp}(neu,prop)=network_run{exp}.(session{ses}).(network{netvar(prop)})(:,neu);
 end
for neu=1:min(min(minROI_norun_net))   %nb of ROI
network_mean_norun_cell{ses}{exp}(neu,prop)=network_norun{exp}.(session{ses}).(network{netvar(prop)})(:,neu);
end
end
end
end


network_mean_cell={network_mean_all_cell  network_mean_run_cell  network_mean_norun_cell};

end