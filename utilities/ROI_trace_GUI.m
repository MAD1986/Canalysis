

function ROI_trace_GUI(ROI,C_df, ROI_sh,coord, color)

ses=size(C_df,2);
nb=size(C_df{ses},2);
for i=1:length(ROI)
Cn_all(:,:,i)=ROI{i}.Cn_max;
Cn_mean=mean(Cn_all,3);
leg{i}=['session ' num2str(i)];
end
warning('off','all')
warning

%Create slider
sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',nb,'Value',1,...
        'sliderstep',[1/nb 1/nb],...
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
for i=1:length(ROI)
Cn_all(:,:,i)=ROI{i}.Cn_max;
Cn_mean=mean(Cn_all,3);
end
subplot(1,2,1)
imagesc(Cn_mean);
hold on
for i=1:length(ROI)
plot(coord{i}{r}(:,2), coord{i}{r}(:,1), color{i}, 'LineWidth', 2)
end

for i=1:length(ROI)
    hold on
subplot(1,2,2)
plot(C_df{i}(:,r),color{i},'linewidth',1);
title(sprintf(['ROI ' num2str(r)] ),'fontsize',16,'fontweight','bold');
legend(leg)
end
hold off;
end
end

