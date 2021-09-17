% temp_feat_mat=feat_mat_zscore_vol
% temp_feat_mat=feat_mat
temp_feat_mat=feat_mat_norm

max_cluster=21

for n_cluster=2:max_cluster

[~,C{n_cluster},sumd] = kmeans(temp_feat_mat,n_cluster,'Replicates',5);

suma(n_cluster-1)=sum(sumd);
end

figure
n_cluster=2:max_cluster;
plot(suma)
ylabel('Suma de las distancias') 
xlabel('Cluster')


[idx3, C, sumd ]= kmeans(temp_feat_mat,3,'Display','final','Replicates',5);

figure
[silh3,h] = silhouette(temp_feat_mat,idx3); 
xlabel('Silhouette Value') 
ylabel('Cluster')
title('Silueta 3 cluster')

mean_silh3=zeros(1,3);
mean_silh3(1)=mean(silh3(idx3==1));
mean_silh3(2)=mean(silh3(idx3==2));
mean_silh3(3)=mean(silh3(idx3==3));


[idx4, C, sumd ]= kmeans(temp_feat_mat,4,'Display','final','Replicates',5);

figure
[silh4,h] = silhouette(temp_feat_mat,idx4); 
xlabel('Silhouette Value') 
ylabel('Cluster')
title('Silueta 4 cluster')

mean_silh4=zeros(1,4);
mean_silh4(1)=mean(silh4(idx4==1));
mean_silh4(2)=mean(silh4(idx4==2));
mean_silh4(3)=mean(silh4(idx4==3));
mean_silh4(4)=mean(silh4(idx4==4));

[idx5, C, sumd ]= kmeans(temp_feat_mat,5,'Replicates',5);

figure
[silh5,h] = silhouette(temp_feat_mat,idx5); 
xlabel('Silhouette Value') 
ylabel('Cluster')
title('Silueta 5 cluster')

mean_silh5=zeros(1,5);
mean_silh5(1)=mean(silh5(idx5==1));
mean_silh5(2)=mean(silh5(idx5==2));
mean_silh5(3)=mean(silh5(idx5==3));
mean_silh5(4)=mean(silh5(idx5==4));
mean_silh5(5)=mean(silh5(idx5==5));

[idx6, C, sumd ]= kmeans(temp_feat_mat,6,'Replicates',5);

figure
[silh6,h] = silhouette(temp_feat_mat,idx6); 
xlabel('Silhouette Value') 
ylabel('Cluster')
title('Silueta 6 cluster')

mean_silh6=zeros(1,6);
mean_silh6(1)=mean(silh6(idx6==1));
mean_silh6(2)=mean(silh6(idx6==2));
mean_silh6(3)=mean(silh6(idx6==3));
mean_silh6(4)=mean(silh6(idx6==4));
mean_silh6(5)=mean(silh6(idx6==5));
mean_silh6(6)=mean(silh6(idx6==6));

figure
plot(idx4,vec_video,'*')



figure
histogram(idx4(vec_emo_binaria'==1))
% title(histr)

figure
histogram(idx4(vec_emo_binaria==2))




figure
histogram(idx4(vec_video==1))
 title('clusters: 4 video 1')
 
 
 figure
histogram(idx4(vec_video==2))
 title('clusters: 4 video 2')
 
 figure
histogram(idx4(vec_video==3))
 title('clusters: 4 video 3')
 
 figure
histogram(idx4(vec_video==4))
 title('clusters: 4 video 4')







