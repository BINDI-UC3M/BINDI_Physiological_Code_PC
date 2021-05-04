
%%PLOTS MEAN STD
% Da
figure
subplot(2,1,1)
plot(ones(1,length([features_mat_nt.mean_video(1,:).da])),[features_mat_nt.mean_video(1,:).da],'*')
hold on
plot(2*ones(1,length([features_mat_nt.mean_video(2,:).da])),[features_mat_nt.mean_video(2,:).da],'*')
plot(3*ones(1,length([features_mat_nt.mean_video(3,:).da])),[features_mat_nt.mean_video(3,:).da],'*')
plot(4*ones(1,length([features_mat_nt.mean_video(4,:).da])),[features_mat_nt.mean_video(4,:).da],'*')
title('Mean Dopamine')
xlabel('video')
ylabel('Concentration[pg/ml]')

subplot(2,1,2)
plot(ones(1,length([features_mat_nt.std_video(1,:).da])),[features_mat_nt.std_video(1,:).da],'*')
hold on
plot(2*ones(1,length([features_mat_nt.std_video(2,:).da])),[features_mat_nt.std_video(2,:).da],'*')
plot(3*ones(1,length([features_mat_nt.std_video(3,:).da])),[features_mat_nt.std_video(3,:).da],'*')
plot(4*ones(1,length([features_mat_nt.std_video(4,:).da])),[features_mat_nt.std_video(4,:).da],'*')
title('STD Dopamine')
xlabel('video')
ylabel('Concentration[pg/ml]')

% Na
figure
subplot(2,1,1)
plot(ones(1,length([features_mat_nt.mean_video(1,:).na])),[features_mat_nt.mean_video(1,:).na],'*')
hold on
plot(2*ones(1,length([features_mat_nt.mean_video(2,:).na])),[features_mat_nt.mean_video(2,:).na],'*')
plot(3*ones(1,length([features_mat_nt.mean_video(3,:).na])),[features_mat_nt.mean_video(3,:).na],'*')
plot(4*ones(1,length([features_mat_nt.mean_video(4,:).na])),[features_mat_nt.mean_video(4,:).na],'*')
title('Mean noradrenaline')
xlabel('video')
ylabel('Concentration[pg/ml]')

subplot(2,1,2)
plot(ones(1,length([features_mat_nt.std_video(1,:).na])),[features_mat_nt.std_video(1,:).na],'*')
hold on
plot(2*ones(1,length([features_mat_nt.std_video(2,:).na])),[features_mat_nt.std_video(2,:).na],'*')
plot(3*ones(1,length([features_mat_nt.std_video(3,:).na])),[features_mat_nt.std_video(3,:).na],'*')
plot(4*ones(1,length([features_mat_nt.std_video(4,:).na])),[features_mat_nt.std_video(4,:).na],'*')
title('STD noradrenaline')
xlabel('video')
ylabel('Concentration[pg/ml]')


% A
figure
subplot(2,1,1)
plot(ones(1,length([features_mat_nt.mean_video(1,:).a])),[features_mat_nt.mean_video(1,:).a],'*')
hold on
plot(2*ones(1,length([features_mat_nt.mean_video(2,:).a])),[features_mat_nt.mean_video(2,:).a],'*')
plot(3*ones(1,length([features_mat_nt.mean_video(3,:).a])),[features_mat_nt.mean_video(3,:).a],'*')
plot(4*ones(1,length([features_mat_nt.mean_video(4,:).a])),[features_mat_nt.mean_video(4,:).a],'*')
title('Mean adrenaline')
xlabel('video')
ylabel('Concentration[pg/ml]')

subplot(2,1,2)
plot(ones(1,length([features_mat_nt.std_video(1,:).a])),[features_mat_nt.std_video(1,:).a],'*')
hold on
plot(2*ones(1,length([features_mat_nt.std_video(2,:).a])),[features_mat_nt.std_video(2,:).a],'*')
plot(3*ones(1,length([features_mat_nt.std_video(3,:).a])),[features_mat_nt.std_video(3,:).a],'*')
plot(4*ones(1,length([features_mat_nt.std_video(4,:).a])),[features_mat_nt.std_video(4,:).a],'*')
title('STD adrenaline')
xlabel('video')
ylabel('Concentration[pg/ml]')


%%Plot norma
figure
for voluntaria=1:21
    
    temp=resultados_nt_reordered';
    temp2=[temp]
    plot(zscore())
    hold on
    
    
    
end




figure
plot([feature_mat_a(1,:).first_peak_pos],[feature_mat_a(1,:).first_valley_pos],"*");

figure
hist([feature_mat_a(1,:).num_valleys])
figure
hist([feature_mat_a(2,:).num_valleys])




figure
subplot(2,3,1)
test=[feature_mat_a(1,:).num_valleys];
test=horzcat(test,[feature_mat_a(2,:).num_valleys]);
test=horzcat(test,[feature_mat_a(3,:).num_valleys]);
vect(1:21)=1;
vect(22:42)=2;
vect(43:63)=3;
boxplot(test,vect);

boxplot([feature_mat_a(1,:).num_valleys]);
hold on
boxplot([feature_mat_a(2,:).num_valleys]);
boxplot([feature_mat_a(3,:).num_valleys]);


subplot(2,3,4)
boxplot([feature_mat_a(1,:).num_peaks]);
hold on
boxplot([feature_mat_a(2,:).num_peaks]);
boxplot([feature_mat_a(3,:).num_peaks]);










