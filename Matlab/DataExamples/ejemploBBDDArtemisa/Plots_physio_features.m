
 dbstop if error

% BOXPLOT figures
 
% Load Lables for plots 
labels_reordered =load_labels_artemisa();

% Feature selection

feat=features_20s_0o;

 
% % % % % % % % % % % % % GSR % % % % % % % % % % % % %

% Norm GSR features
temp_features_norm=norm_phy_features(feat,'zscore','GSR');

Vol_excluded=[0];

% Plots norm
Plots_physio_features_boxplot(temp_features_norm,'GSR',1,'GSR: N picos Norm','Picos',labels_reordered,Vol_excluded);
Plots_physio_features_boxplot(temp_features_norm,'GSR',6,'GSR: Media Norm','uS',labels_reordered,Vol_excluded);

% Plots no norm
Plots_physio_features_boxplot(feat,'GSR',1,'GSR: N picos','Picos',labels_reordered,Vol_excluded);
Plots_physio_features_boxplot(feat,'GSR',6,'GSR: Media','uS',labels_reordered,Vol_excluded);

Vol_excluded=[1 3];

% Plots norm
Plots_physio_features_boxplot(temp_features_norm,'GSR',1,'GSR: N picos Norm','Picos',labels_reordered,Vol_excluded);
Plots_physio_features_boxplot(temp_features_norm,'GSR',6,'GSR: Media Norm','uS',labels_reordered,Vol_excluded);

% Plots no norm
Plots_physio_features_boxplot(feat,'GSR',1,'GSR: N picos','Picos',labels_reordered,Vol_excluded);
Plots_physio_features_boxplot(feat,'GSR',6,'GSR: Media','uS',labels_reordered,Vol_excluded);



feat_select= heart_features_selections(feat);


Vol_excluded=[12];

 features_norm=norm_phy_features(feat_select,'zscore','HR');
% % % 
%  Plots_physio_features_boxplot(features_norm,'HR',4,'Media IBI','',labels_reordered,Vol_excluded);
% 
% 
% Plots_physio_features_boxplot(features_norm,'HR',3,'HRV rmssd','',labels_reordered,Vol_excluded);
% 
% Plots_physio_features_boxplot(features_norm,'HR',11,'Ratio LFHF ','',labels_reordered,Vol_excluded);
% % Plots_physio_features_boxplot(features_norm,'HR',5,'LF ','',labels_reordered,Vol_excluded);
% % 
% % Plots_physio_features_boxplot(features_norm,'HR',6,'HF','',labels_reordered,Vol_excluded);
% 
% Plots_physio_features_boxplot(features_norm,'HR',17,'Sd1','',labels_reordered,Vol_excluded);
% 
% Plots_physio_features_boxplot(features_norm,'HR',18,'Sd2','',labels_reordered,Vol_excluded);
% % 


Plots_physio_features_boxplot(features_norm,'HR',4,'Media IBI','',labels_reordered,Vol_excluded);


Plots_physio_features_boxplot(features_norm,'HR',3,'HRV rmssd','',labels_reordered,Vol_excluded);

Vol_excluded=[ 1 3 12];

Plots_physio_features_boxplot(features_norm,'HR',4,'Media IBI','',labels_reordered,Vol_excluded);


Plots_physio_features_boxplot(features_norm,'HR',3,'HRV rmssd','',labels_reordered,Vol_excluded);

% Plots_physio_features_boxplot(feat_select,'HR',11,'Ratio LFHF ','',labels_reordered,Vol_excluded);
% Plots_physio_features_boxplot(features_norm,'HR',5,'LF ','',labels_reordered,Vol_excluded);
% 
% Plots_physio_features_boxplot(features_norm,'HR',6,'HF','',labels_reordered,Vol_excluded);

% Plots_physio_features_boxplot(feat_select,'HR',17,'Sd1','',labels_reordered,Vol_excluded);
% 
% Plots_physio_features_boxplot(feat_select,'HR',18,'Sd2','',labels_reordered,Vol_excluded);


% vol_to_exclude=[8,0];
% Plots_physio_features_boxplot(feat_resp_test_2_40s,'RESP',12,'Media ','freq',labels_reordered,vol_to_exclude);


features_norm_resp=norm_phy_features(feat,'zscore','RESP');

% Plots norm
Plots_physio_features_boxplot(features_norm_resp,'RESP',12,'RESP: frecuencia respiratoria','',labels_reordered,Vol_excluded);


features_norm_resp=norm_phy_features(feat,'zscore','SKT');

% Plots norm
Plots_physio_features_boxplot(features_norm_resp,'SKT',1,'SKT: media','',labels_reordered,Vol_excluded);



% Plots temporales

feat_select= heart_features_selections(feats);

features_norm_hr=norm_phy_features(feat_select,'zscore','HR');

features_norm_gsr=norm_phy_features(feat_select,'zscore','GSR');

Vol_excluded=[12];

Plots_physio_features_temporal(feat_select,'HR',11,'Ratio LFHF ','',Vol_excluded);

Plots_physio_features_temporal(features_norm_hr,'HR',4,'IBI medio ','',Vol_excluded);

Plots_physio_features_temporal(feat_select,'HRV',4,'HRV ','',Vol_excluded);

Plots_physio_features_temporal(features_norm_gsr,'GSR',1,'N picos ','',Vol_excluded);

Plots_physio_features_temporal(features_norm_gsr,'GSR',6,'GSR mean ','',Vol_excluded);

% Pointcare


Plots_physio_features_pointcare(feat_select,'HR',11,'Ratio LFHF ','',Vol_excluded);

