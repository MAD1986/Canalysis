

%% fix correlation analysis for RZ
for i=1:sessions % or what you used 
Spatialinfo{i}.rate_map.ordered_rate_map=Place_cell{i}.Spatial_tuning_curve_sorted  ;
Spatialinfo{i}.rate_map.normalized_rate_map_smoothed=Place_cell{i}.Spatial_tuning_curve;
Spatialinfo{i}.rate_map.ROI_odered_rate_map=Place_cell{i}.ROI_Spatial_tuning_sorted;

Spatialinfo{i}.rate_map.rate_map_smoothed=Place_cell{i}.Spatial_Info.rate_map_smooth{8}   ;
TunedCells{i}.TunedROI= Place_cell{i}.Tuned_ROI  ;
TunedCells{i}.Spatial_info.significantROI=Place_cell{1, 1}.Spatial_Info.significant_ROI    ; 
TunedCells{i}.TuningSpecificity.significantROI=Place_cell{1, 1}.Tuning_Specificity.significant_ROI  ; 
end

Spatialinfo{i}.rate_map.normalized_rate_map_smoothed;


%% For your scripts
TunedCells=SpatiallyTunedCells;
Spatialinfo8=Spatialinfo;
%[ordered_map] = plotratemap_V3_RZ(Spatial_correlation,Spatialinfo8,SpatiallyTunedCells);
%[Spatial_correlation] = spatial_corr_V3(Spatial_correlation,Spatialinfo8,SpatiallyTunedCells);

SpatiallyTunedCells{1,i}.NbROI=numel(Place_cell{i}.Tuned_ROI);
SpatiallyTunedCells{1,i}.TunedROI=Place_cell{i}.Tuned_ROI;
%for i=1:numSessions
%    tunedNb(i) = SpatiallyTunedCells{1,i}.NbROI;
%    tunedFraction(i) = SpatiallyTunedCells{1,i}.NbROI/length(SpatiallyTunedCells{1,i}.TunedROI);
%end

for i=1:sessions % or what you used 
TuningSpecificity{i}.tuning_vector=Place_cell{i}.Tuning_Specificity.tuning_vector;
end
%compass(TuningSpecificity{1,1}.tuning_vector{odorZoneTunedIdx(ii)},'r');
