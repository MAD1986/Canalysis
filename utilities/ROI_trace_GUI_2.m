

function [rm_ROI]= ROI_trace_GUI_2(ROI,C_df, ROI_sh,coord, color,rm_ROI);

ses=size(C_df,2);
nb=size(C_df{ses},2);
for i=1:length(ROI)
leg{i}=['session ' num2str(i)];
Cn_all(:,:,i)=ROI{i}.Cn_max;
Cn_mean=mean(Cn_all,3);
end

% Create push button
btn = uicontrol('Style', 'pushbutton', 'String', 'Remove ROI',...
        'Position', [200 20 120 20],...
        'Callback', @remove_ROI);     

%Create slider
sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',nb,'Value',1,...
        'sliderstep',[1/nb 1/nb],...
        'Position', [4 20 120 20],...
        'Callback', @ROI_dF);      

    % Make figure visble after adding all components
f.Visible = 'on';
plot_component(1)
ROI_nb(1)

    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');

function remove_ROI(source,callbackdata)
r = source.Value;
ROI_nb(round(r))  
end

function ROI_dF(source,callbackdata)
r = source.Value;
plot_component(round(r))  
end

function ROI_nb(r) 
remove_ROI = round(get(sld,'value'));



end



function plot_component(r) 
pos=1:3:(length(ROI)*length(ROI));



for i=1:length(ROI)
subplot(length(ROI),3,pos(i)+1)
%imshow(Cn_mean);
%hold on
ROI_shape=(ROI_sh{i}(:,:,r));
ROI_shape( ~any(ROI_shape,2), : ) = [];  %rows
ROI_shape( :, ~any(ROI_shape,1) ) = [];  %columns
imagesc(ROI_shape);

subplot(length(ROI),3,pos(i))
%imagesc(Cn_mean);
%imshow(Cn_mean);
imagesc(ROI{i}.Cn_max)
hold on
plot(coord{i}{r}(:,2), coord{i}{r}(:,1), 'w', 'LineWidth', 2)

subplot(length(ROI),3,pos(i)+2)
plot(C_df{i}(:,r),color{i},'linewidth',1);
title(sprintf(['ROI ' num2str(r)] ),'fontsize',16,'fontweight','bold');
legend(leg{i});



end
end
end



