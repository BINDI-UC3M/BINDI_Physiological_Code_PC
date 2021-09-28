

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

temp_var_da=horzcat([features_mat_nt.mean_video(1,:).da]',[features_mat_nt.mean_video(2,:).da]',[features_mat_nt.mean_video(3,:).da]',[features_mat_nt.mean_video(4,:).da]');
temp_var_a=horzcat([features_mat_nt.mean_video(1,:).a]',[features_mat_nt.mean_video(2,:).a]',[features_mat_nt.mean_video(3,:).a]',[features_mat_nt.mean_video(4,:).a]')
temp_var_na=horzcat([features_mat_nt.mean_video(1,:).na]',[features_mat_nt.mean_video(2,:).na]',[features_mat_nt.mean_video(3,:).na]',[features_mat_nt.mean_video(4,:).na]')
figure

boxplot(temp_var_da);
title('Concentracion de dopamina por video')
ylabel('Concentration[pg/ml]')

figure

boxplot(temp_var_a);
title('Concentracion de adrenalina por video')
ylabel('Concentration[pg/ml]')

figure

boxplot(temp_var_na);
title('Concentracion de noradrenalina por video')
ylabel('Concentration[pg/ml]')