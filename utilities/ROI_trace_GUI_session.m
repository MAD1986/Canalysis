

function ROI_trace_GUI_session(ROI,C_df, ROI_sh,coord)
nb=size(C_df,2);
Cn_all=ROI.Cn_max;
Cn_mean=mean(Cn_all,3);

warning('off','all')
warning
%Create slider
sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',nb,'Value',1,...
        'Position', [4 20 120 20],...
        'Callback', @ROI_dF); 
% Add a text uicontrol to label the slider.
txt = uicontrol('Style','text',...
        'Position',[4 45 120 20],...
        'String','ROI ');  
    
    
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

    
subplot(1,3,2)
%imshow(Cn_mean);
%hold on
ROI_shape=(ROI_sh(:,:,r));
ROI_shape( ~any(ROI_shape,2), : ) = [];  %rows
ROI_shape( :, ~any(ROI_shape,1) ) = [];  %columns

imagesc(ROI_shape);
subplot(1,3,1)
imagesc(Cn_mean);
hold on
plot(coord{r}(:,2), coord{r}(:,1), 'w', 'LineWidth', 2)


subplot(1,3,3)
plot(C_df(:,r),'linewidth',2);
title(sprintf(['ROI ' num2str(r)] ),'fontsize',16,'fontweight','bold');


end
end

