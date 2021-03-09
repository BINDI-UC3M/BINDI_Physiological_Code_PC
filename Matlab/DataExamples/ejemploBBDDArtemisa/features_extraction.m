% Carcaterirticas Experimento NT


for voluntaria=1:21
    %% Mean
    
    
%     features_mat_nt(1,voluntaria).features.da.mean_video=mean(resultados_nt_reordered(1,voluntaria).da);
%     features_mat_nt(2,voluntaria).features.da.mean_video=mean(resultados_nt_reordered(2,voluntaria).da);
%     features_mat_nt(3,voluntaria).features.da.mean_video=mean(resultados_nt_reordered(3,voluntaria).da);
%     features_mat_nt(4,voluntaria).features.da.mean_video=mean(resultados_nt_reordered(4,voluntaria).da);
%     
%     features_mat_nt(1,voluntaria).features.na.mean_video=mean(resultados_nt_reordered(1,voluntaria).na);
%     features_mat_nt(2,voluntaria).features.na.mean_video=mean(resultados_nt_reordered(2,voluntaria).na);
%     features_mat_nt(3,voluntaria).features.na.mean_video=mean(resultados_nt_reordered(3,voluntaria).na);
%     features_mat_nt(4,voluntaria).features.na.mean_video=mean(resultados_nt_reordered(4,voluntaria).na);
%     
%     features_mat_nt(1,voluntaria).features.a.mean_video=mean(resultados_nt_reordered(1,voluntaria).a);
%     features_mat_nt(2,voluntaria).features.a.mean_video=mean(resultados_nt_reordered(2,voluntaria).a);
%     features_mat_nt(3,voluntaria).features.a.mean_video=mean(resultados_nt_reordered(3,voluntaria).a);
%     features_mat_nt(4,voluntaria).features.a.mean_video=mean(resultados_nt_reordered(4,voluntaria).a);
    
    features_mat_nt.mean_video(1,voluntaria).da=mean(resultados_nt_reordered(1,voluntaria).da);
    features_mat_nt.mean_video(2,voluntaria).da=mean(resultados_nt_reordered(2,voluntaria).da);
    features_mat_nt.mean_video(3,voluntaria).da=mean(resultados_nt_reordered(3,voluntaria).da);
    features_mat_nt.mean_video(4,voluntaria).da=mean(resultados_nt_reordered(4,voluntaria).da);
    
   features_mat_nt.mean_video(1,voluntaria).na=mean(resultados_nt_reordered(1,voluntaria).na);
    features_mat_nt.mean_video(2,voluntaria).na=mean(resultados_nt_reordered(2,voluntaria).na);
    features_mat_nt.mean_video(3,voluntaria).na=mean(resultados_nt_reordered(3,voluntaria).na);
    features_mat_nt.mean_video(4,voluntaria).na=mean(resultados_nt_reordered(4,voluntaria).na);
    
    features_mat_nt.mean_video(1,voluntaria).a=mean(resultados_nt_reordered(1,voluntaria).a);
    features_mat_nt.mean_video(2,voluntaria).a=mean(resultados_nt_reordered(2,voluntaria).a);
    features_mat_nt.mean_video(3,voluntaria).a=mean(resultados_nt_reordered(3,voluntaria).a);
    features_mat_nt.mean_video(4,voluntaria).a=mean(resultados_nt_reordered(4,voluntaria).a);
    
    %% STD
    
%     features_mat_nt(1,voluntaria).features.da.std_video=std(resultados_nt_reordered(1,voluntaria).da);
%     features_mat_nt(2,voluntaria).features.da.std_video=std(resultados_nt_reordered(2,voluntaria).da);
%     features_mat_nt(3,voluntaria).features.da.std_video=std(resultados_nt_reordered(3,voluntaria).da);
%     features_mat_nt(4,voluntaria).features.da.std_video=std(resultados_nt_reordered(4,voluntaria).da);
%     
%     features_mat_nt(1,voluntaria).features.na.std_video=std(resultados_nt_reordered(1,voluntaria).na);
%     features_mat_nt(2,voluntaria).features.na.std_video=std(resultados_nt_reordered(2,voluntaria).na);
%     features_mat_nt(3,voluntaria).features.na.std_video=std(resultados_nt_reordered(3,voluntaria).na);
%     features_mat_nt(4,voluntaria).features.na.std_video=std(resultados_nt_reordered(4,voluntaria).na);
%     
%     features_mat_nt(1,voluntaria).features.a.std_video=std(resultados_nt_reordered(1,voluntaria).a);
%     features_mat_nt(2,voluntaria).features.a.std_video=std(resultados_nt_reordered(2,voluntaria).a);
%     features_mat_nt(3,voluntaria).features.a.std_video=std(resultados_nt_reordered(3,voluntaria).a);
%     features_mat_nt(4,voluntaria).features.a.std_video=std(resultados_nt_reordered(4,voluntaria).a);
    
    features_mat_nt.std_video(1,voluntaria).da=std(resultados_nt_reordered(1,voluntaria).da);
    features_mat_nt.std_video(2,voluntaria).da=std(resultados_nt_reordered(2,voluntaria).da);
    features_mat_nt.std_video(3,voluntaria).da=std(resultados_nt_reordered(3,voluntaria).da);
    features_mat_nt.std_video(4,voluntaria).da=std(resultados_nt_reordered(4,voluntaria).da);
    
    features_mat_nt.std_video(1,voluntaria).na=std(resultados_nt_reordered(1,voluntaria).na);
    features_mat_nt.std_video(2,voluntaria).na=std(resultados_nt_reordered(2,voluntaria).na);
    features_mat_nt.std_video(3,voluntaria).na=std(resultados_nt_reordered(3,voluntaria).na);
    features_mat_nt.std_video(4,voluntaria).na=std(resultados_nt_reordered(4,voluntaria).na);
    
    features_mat_nt.std_video(1,voluntaria).a=std(resultados_nt_reordered(1,voluntaria).a);
    features_mat_nt.std_video(2,voluntaria).a=std(resultados_nt_reordered(2,voluntaria).a);
    features_mat_nt.std_video(3,voluntaria).a=std(resultados_nt_reordered(3,voluntaria).a);
    features_mat_nt.std_video(4,voluntaria).a=std(resultados_nt_reordered(4,voluntaria).a);
    
    
      
 
    
   
    
    %% MAX per video
    
%     resultados_nt_2(1,voluntaria).features.da.max_video=resultados_nt_2(1,voluntaria).da;
%     resultados_nt_2(2,voluntaria).features.da.max_video=resultados_nt_2(2,voluntaria).da;
%     resultados_nt_2(3,voluntaria).features.da.max_video=max([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(4,voluntaria).features.da.max_video=max([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(5,voluntaria).features.da.max_video=max([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(6,voluntaria).features.da.max_video=max([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(7,voluntaria).features.da.max_video=max([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(8,voluntaria).features.da.max_video=resultados_nt_2(8,voluntaria).da;
%     resultados_nt_2(9,voluntaria).features.da.max_video=max([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(10,voluntaria).features.da.max_video=max([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(11,voluntaria).features.da.max_video=max([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(12,voluntaria).features.da.max_video=max([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(13,voluntaria).features.da.max_video=max([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(14,voluntaria).features.da.max_video=resultados_nt_2(14,voluntaria).da;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.na.max_video=resultados_nt_2(1,voluntaria).na;
%     resultados_nt_2(2,voluntaria).features.na.max_video=resultados_nt_2(2,voluntaria).na; 
%     resultados_nt_2(3,voluntaria).features.na.max_video=max([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(4,voluntaria).features.na.max_video=max([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(5,voluntaria).features.na.max_video=max([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(6,voluntaria).features.na.max_video=max([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(7,voluntaria).features.na.max_video=max([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(8,voluntaria).features.na.max_video=resultados_nt_2(8,voluntaria).na;
%     resultados_nt_2(9,voluntaria).features.na.max_video=max([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(10,voluntaria).features.na.max_video=max([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(11,voluntaria).features.na.max_video=max([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(12,voluntaria).features.na.max_video=max([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(13,voluntaria).features.na.max_video=max([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(14,voluntaria).features.na.max_video=resultados_nt_2(14,voluntaria).na;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.a.max_video=resultados_nt_2(1,voluntaria).a;
%     resultados_nt_2(2,voluntaria).features.a.max_video=resultados_nt_2(2,voluntaria).a;
%     resultados_nt_2(3,voluntaria).features.a.max_video=max([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(4,voluntaria).features.a.max_video=max([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(5,voluntaria).features.a.max_video=max([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(6,voluntaria).features.a.max_video=max([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(7,voluntaria).features.a.max_video=max([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(8,voluntaria).features.a.max_video=resultados_nt_2(8,voluntaria).a;
%     resultados_nt_2(9,voluntaria).features.a.max_video=max([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(10,voluntaria).features.a.max_video=max([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(11,voluntaria).features.a.max_video=max([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(12,voluntaria).features.a.max_video=max([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(13,voluntaria).features.a.max_video=max([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(14,voluntaria).features.a.max_video=resultados_nt_2(14,voluntaria).a;
%     
%     %% Min per video
%     resultados_nt_2(1,voluntaria).features.da.min_video=resultados_nt_2(1,voluntaria).da;
%     resultados_nt_2(2,voluntaria).features.da.min_video=resultados_nt_2(2,voluntaria).da;
%     resultados_nt_2(3,voluntaria).features.da.min_video=min([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(4,voluntaria).features.da.min_video=min([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(5,voluntaria).features.da.min_video=min([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(6,voluntaria).features.da.min_video=min([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(7,voluntaria).features.da.min_video=min([resultados_nt_2(3:7,voluntaria).da]);
%     resultados_nt_2(8,voluntaria).features.da.min_video=resultados_nt_2(8,voluntaria).da;
%     resultados_nt_2(9,voluntaria).features.da.min_video=min([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(10,voluntaria).features.da.min_video=min([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(11,voluntaria).features.da.min_video=min([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(12,voluntaria).features.da.min_video=min([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(13,voluntaria).features.da.min_video=min([resultados_nt_2(9:13,voluntaria).da]);
%     resultados_nt_2(14,voluntaria).features.da.min_video=resultados_nt_2(14,voluntaria).da;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.na.min_video=resultados_nt_2(1,voluntaria).na;
%     resultados_nt_2(2,voluntaria).features.na.min_video=resultados_nt_2(2,voluntaria).na; 
%     resultados_nt_2(3,voluntaria).features.na.min_video=min([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(4,voluntaria).features.na.min_video=min([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(5,voluntaria).features.na.min_video=min([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(6,voluntaria).features.na.min_video=min([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(7,voluntaria).features.na.min_video=min([resultados_nt_2(3:7,voluntaria).na]);
%     resultados_nt_2(8,voluntaria).features.na.min_video=resultados_nt_2(8,voluntaria).na;
%     resultados_nt_2(9,voluntaria).features.na.min_video=min([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(10,voluntaria).features.na.min_video=min([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(11,voluntaria).features.na.min_video=min([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(12,voluntaria).features.na.min_video=min([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(13,voluntaria).features.na.min_video=min([resultados_nt_2(9:13,voluntaria).na]);
%     resultados_nt_2(14,voluntaria).features.na.min_video=resultados_nt_2(14,voluntaria).na;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.a.min_video=resultados_nt_2(1,voluntaria).a;
%     resultados_nt_2(2,voluntaria).features.a.min_video=resultados_nt_2(2,voluntaria).a;
%     resultados_nt_2(3,voluntaria).features.a.min_video=min([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(4,voluntaria).features.a.min_video=min([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(5,voluntaria).features.a.min_video=min([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(6,voluntaria).features.a.min_video=min([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(7,voluntaria).features.a.min_video=min([resultados_nt_2(3:7,voluntaria).a]);
%     resultados_nt_2(8,voluntaria).features.a.min_video=resultados_nt_2(8,voluntaria).a;
%     resultados_nt_2(9,voluntaria).features.a.min_video=min([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(10,voluntaria).features.a.min_video=min([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(11,voluntaria).features.a.min_video=min([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(12,voluntaria).features.a.min_video=min([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(13,voluntaria).features.a.min_video=min([resultados_nt_2(9:13,voluntaria).a]);
%     resultados_nt_2(14,voluntaria).features.a.min_video=resultados_nt_2(14,voluntaria).a;
%     
%     %% Increment means previous video
%     
%     resultados_nt_2(1,voluntaria).features.da.increment_mean_prev_vid=0
%     resultados_nt_2(2,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(2,voluntaria).features.da.mean-resultados_nt_2(1,voluntaria).features.da.mean;
%     resultados_nt_2(3,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.da.mean-resultados_nt_2(2,voluntaria).features.da.mean;
%     resultados_nt_2(4,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.da.mean-resultados_nt_2(2,voluntaria).features.da.mean;
%     resultados_nt_2(5,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.da.mean-resultados_nt_2(2,voluntaria).features.da.mean;
%     resultados_nt_2(6,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.da.mean-resultados_nt_2(2,voluntaria).features.da.mean;
%     resultados_nt_2(7,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.da.mean-resultados_nt_2(2,voluntaria).features.da.mean;
%     resultados_nt_2(8,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(8,voluntaria).features.da.mean-resultados_nt_2(7,voluntaria).features.da.mean;
%     resultados_nt_2(9,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.da.mean-resultados_nt_2(8,voluntaria).features.da.mean;
%     resultados_nt_2(10,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.da.mean-resultados_nt_2(8,voluntaria).features.da.mean;
%     resultados_nt_2(11,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.da.mean-resultados_nt_2(8,voluntaria).features.da.mean;
%     resultados_nt_2(12,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.da.mean-resultados_nt_2(8,voluntaria).features.da.mean;
%     resultados_nt_2(13,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.da.mean-resultados_nt_2(8,voluntaria).features.da.mean;
%     resultados_nt_2(14,voluntaria).features.da.increment_mean_prev_vid=resultados_nt_2(14,voluntaria).features.da.mean-resultados_nt_2(13,voluntaria).features.da.mean;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.na.increment_mean_prev_vid=0
%     resultados_nt_2(2,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(2,voluntaria).features.na.mean-resultados_nt_2(1,voluntaria).features.na.mean;
%     resultados_nt_2(3,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.na.mean-resultados_nt_2(2,voluntaria).features.na.mean;
%     resultados_nt_2(4,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.na.mean-resultados_nt_2(2,voluntaria).features.na.mean;
%     resultados_nt_2(5,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.na.mean-resultados_nt_2(2,voluntaria).features.na.mean;
%     resultados_nt_2(6,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.na.mean-resultados_nt_2(2,voluntaria).features.na.mean;
%     resultados_nt_2(7,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.na.mean-resultados_nt_2(2,voluntaria).features.na.mean;
%     resultados_nt_2(8,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(8,voluntaria).features.na.mean-resultados_nt_2(7,voluntaria).features.na.mean;
%     resultados_nt_2(9,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.na.mean-resultados_nt_2(8,voluntaria).features.na.mean;
%     resultados_nt_2(10,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.na.mean-resultados_nt_2(8,voluntaria).features.na.mean;
%     resultados_nt_2(11,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.na.mean-resultados_nt_2(8,voluntaria).features.na.mean;
%     resultados_nt_2(12,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.na.mean-resultados_nt_2(8,voluntaria).features.na.mean;
%     resultados_nt_2(13,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.na.mean-resultados_nt_2(8,voluntaria).features.na.mean;
%     resultados_nt_2(14,voluntaria).features.na.increment_mean_prev_vid=resultados_nt_2(14,voluntaria).features.na.mean-resultados_nt_2(13,voluntaria).features.na.mean;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.a.increment_mean_prev_vid=0
%     resultados_nt_2(2,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(2,voluntaria).features.a.mean-resultados_nt_2(1,voluntaria).features.a.mean;
%     resultados_nt_2(3,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.a.mean-resultados_nt_2(2,voluntaria).features.a.mean;
%     resultados_nt_2(4,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.a.mean-resultados_nt_2(2,voluntaria).features.a.mean;
%     resultados_nt_2(5,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.a.mean-resultados_nt_2(2,voluntaria).features.a.mean;
%     resultados_nt_2(6,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.a.mean-resultados_nt_2(2,voluntaria).features.a.mean;
%     resultados_nt_2(7,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(3,voluntaria).features.a.mean-resultados_nt_2(2,voluntaria).features.a.mean;
%     resultados_nt_2(8,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(8,voluntaria).features.a.mean-resultados_nt_2(7,voluntaria).features.a.mean;
%     resultados_nt_2(9,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.a.mean-resultados_nt_2(8,voluntaria).features.a.mean;
%     resultados_nt_2(10,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.a.mean-resultados_nt_2(8,voluntaria).features.a.mean;
%     resultados_nt_2(11,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.a.mean-resultados_nt_2(8,voluntaria).features.a.mean;
%     resultados_nt_2(12,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.a.mean-resultados_nt_2(8,voluntaria).features.a.mean;
%     resultados_nt_2(13,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(9,voluntaria).features.a.mean-resultados_nt_2(8,voluntaria).features.a.mean;
%     resultados_nt_2(14,voluntaria).features.a.increment_mean_prev_vid=resultados_nt_2(14,voluntaria).features.a.mean-resultados_nt_2(13,voluntaria).features.a.mean;
%     
%     %% Diff 
%     
%     resultados_nt_2(1,voluntaria).features.da.diff_sample=0
%     resultados_nt_2(2,voluntaria).features.da.diff_sample=resultados_nt_2(2,voluntaria).da-resultados_nt_2(1,voluntaria).da;
%     resultados_nt_2(3,voluntaria).features.da.diff_sample=resultados_nt_2(3,voluntaria).da-resultados_nt_2(2,voluntaria).da;
%     resultados_nt_2(4,voluntaria).features.da.diff_sample=resultados_nt_2(4,voluntaria).da-resultados_nt_2(3,voluntaria).da;
%     resultados_nt_2(5,voluntaria).features.da.diff_sample=resultados_nt_2(5,voluntaria).da-resultados_nt_2(4,voluntaria).da;
%     resultados_nt_2(6,voluntaria).features.da.diff_sample=resultados_nt_2(6,voluntaria).da-resultados_nt_2(5,voluntaria).da;
%     resultados_nt_2(7,voluntaria).features.da.diff_sample=resultados_nt_2(7,voluntaria).da-resultados_nt_2(6,voluntaria).da;
%     resultados_nt_2(8,voluntaria).features.da.diff_sample=resultados_nt_2(8,voluntaria).da-resultados_nt_2(7,voluntaria).da;
%     resultados_nt_2(9,voluntaria).features.da.diff_sample=resultados_nt_2(9,voluntaria).da-resultados_nt_2(8,voluntaria).da;
%     resultados_nt_2(10,voluntaria).features.da.diff_sample=resultados_nt_2(10,voluntaria).da-resultados_nt_2(9,voluntaria).da;
%     resultados_nt_2(11,voluntaria).features.da.diff_sample=resultados_nt_2(11,voluntaria).da-resultados_nt_2(10,voluntaria).da;
%     resultados_nt_2(12,voluntaria).features.da.diff_sample=resultados_nt_2(12,voluntaria).da-resultados_nt_2(11,voluntaria).da;
%     resultados_nt_2(13,voluntaria).features.da.diff_sample=resultados_nt_2(13,voluntaria).da-resultados_nt_2(12,voluntaria).da;
%     resultados_nt_2(14,voluntaria).features.da.diff_sample=resultados_nt_2(14,voluntaria).da-resultados_nt_2(13,voluntaria).da;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.na.diff_sample=0
%     resultados_nt_2(2,voluntaria).features.na.diff_sample=resultados_nt_2(2,voluntaria).na-resultados_nt_2(1,voluntaria).na;
%     resultados_nt_2(3,voluntaria).features.na.diff_sample=resultados_nt_2(3,voluntaria).na-resultados_nt_2(2,voluntaria).na;
%     resultados_nt_2(4,voluntaria).features.na.diff_sample=resultados_nt_2(4,voluntaria).na-resultados_nt_2(3,voluntaria).na;
%     resultados_nt_2(5,voluntaria).features.na.diff_sample=resultados_nt_2(5,voluntaria).na-resultados_nt_2(4,voluntaria).na;
%     resultados_nt_2(6,voluntaria).features.na.diff_sample=resultados_nt_2(6,voluntaria).na-resultados_nt_2(5,voluntaria).na;
%     resultados_nt_2(7,voluntaria).features.na.diff_sample=resultados_nt_2(7,voluntaria).na-resultados_nt_2(6,voluntaria).na;
%     resultados_nt_2(8,voluntaria).features.na.diff_sample=resultados_nt_2(8,voluntaria).na-resultados_nt_2(7,voluntaria).na;
%     resultados_nt_2(9,voluntaria).features.na.diff_sample=resultados_nt_2(9,voluntaria).na-resultados_nt_2(8,voluntaria).na;
%     resultados_nt_2(10,voluntaria).features.na.diff_sample=resultados_nt_2(10,voluntaria).na-resultados_nt_2(9,voluntaria).na;
%     resultados_nt_2(11,voluntaria).features.na.diff_sample=resultados_nt_2(11,voluntaria).na-resultados_nt_2(10,voluntaria).na;
%     resultados_nt_2(12,voluntaria).features.na.diff_sample=resultados_nt_2(12,voluntaria).na-resultados_nt_2(11,voluntaria).na;
%     resultados_nt_2(13,voluntaria).features.na.diff_sample=resultados_nt_2(13,voluntaria).na-resultados_nt_2(12,voluntaria).na;
%     resultados_nt_2(14,voluntaria).features.na.diff_sample=resultados_nt_2(14,voluntaria).na-resultados_nt_2(13,voluntaria).na;
%     
%     
%     
%     resultados_nt_2(1,voluntaria).features.a.diff_sample=0
%     resultados_nt_2(2,voluntaria).features.a.diff_sample=resultados_nt_2(2,voluntaria).a-resultados_nt_2(1,voluntaria).a;
%     resultados_nt_2(3,voluntaria).features.a.diff_sample=resultados_nt_2(3,voluntaria).a-resultados_nt_2(2,voluntaria).a;
%     resultados_nt_2(4,voluntaria).features.a.diff_sample=resultados_nt_2(4,voluntaria).a-resultados_nt_2(3,voluntaria).a;
%     resultados_nt_2(5,voluntaria).features.a.diff_sample=resultados_nt_2(5,voluntaria).a-resultados_nt_2(4,voluntaria).a;
%     resultados_nt_2(6,voluntaria).features.a.diff_sample=resultados_nt_2(6,voluntaria).a-resultados_nt_2(5,voluntaria).a;
%     resultados_nt_2(7,voluntaria).features.a.diff_sample=resultados_nt_2(7,voluntaria).a-resultados_nt_2(6,voluntaria).a;
%     resultados_nt_2(8,voluntaria).features.a.diff_sample=resultados_nt_2(8,voluntaria).a-resultados_nt_2(7,voluntaria).a;
%     resultados_nt_2(9,voluntaria).features.a.diff_sample=resultados_nt_2(9,voluntaria).a-resultados_nt_2(8,voluntaria).a;
%     resultados_nt_2(10,voluntaria).features.a.diff_sample=resultados_nt_2(10,voluntaria).a-resultados_nt_2(9,voluntaria).a;
%     resultados_nt_2(11,voluntaria).features.a.diff_sample=resultados_nt_2(11,voluntaria).a-resultados_nt_2(10,voluntaria).a;
%     resultados_nt_2(12,voluntaria).features.a.diff_sample=resultados_nt_2(12,voluntaria).a-resultados_nt_2(11,voluntaria).a;
%     resultados_nt_2(13,voluntaria).features.a.diff_sample=resultados_nt_2(13,voluntaria).a-resultados_nt_2(12,voluntaria).a;
%     resultados_nt_2(14,voluntaria).features.a.diff_sample=resultados_nt_2(14,voluntaria).a-resultados_nt_2(13,voluntaria).a;
    
end