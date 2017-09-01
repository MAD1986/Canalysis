

function tuned_ROI_GUI(Place_cell,Imaging);

nb=size(Place_cell.Tuned_ROI,2);

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
subplot(1,3,1)
plot(Place_cell.Spatial_tuning_curve(:,Place_cell.Tuned_ROI(r)))
subplot(1,3,2)
compass(Place_cell.Tuning_Specificity.tuning_vector{Place_cell.Tuned_ROI(r)})
hold on
compass(Place_cell.Tuning_Specificity.tuning_vector_specificity( Place_cell.Tuned_ROI(r)), 'r')
hold off
subplot(1,3,3)
plot(Imaging.trace_restricted(:,Place_cell.Tuned_ROI(r)))

suptitle(['Tuned ROI', num2str(Place_cell.Tuned_ROI(r))])

end
end



