

function sessions_tuned_ROI_GUI(Place_cell,Imaging,Behavior,Spatial_correlation,sessions);
%make 4 5 6 be 1 2 3 

nb=numel(Spatial_correlation.tunedROI);



%Create slider
sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',nb,'Value',1,...
        'sliderstep',[1/nb 1/nb],...
        'Position', [4 20 120 20],...
        'Callback', @ROI_dF);      

% Make figure visble after adding all components
f.Visible = 'on';
plot_component(1)

    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');


function ROI_dF(source,callbackdata)
r = source.Value;
plot_component(round(r))  
end


function plot_component(r) 
 pos=1:3:(length(sessions)*length(sessions));
   for i=1:length(sessions)
subplot(length(sessions),3,pos(i)+1)
plot(Place_cell{sessions(i)}.Spatial_tuning_curve(:,Spatial_correlation.tunedROI(r)))

subplot(length(sessions),3,pos(i))
compass(Place_cell{sessions(i)}.Tuning_Specificity.tuning_vector{Spatial_correlation.tunedROI(r)})
hold on
compass(Place_cell{sessions(i)}.Tuning_Specificity.tuning_vector_specificity( Spatial_correlation.tunedROI(r)), 'r')
hold off
subplot(length(sessions),3,pos(i)+2)
 plot(Imaging{sessions(i)}.trace(:,Spatial_correlation.tunedROI(r)))
hold on;
plot(Behavior{sessions(i)}.resampled.position/200) 

suptitle(['Tuned ROI', num2str(Spatial_correlation.tunedROI(r))])
   end
end
end



