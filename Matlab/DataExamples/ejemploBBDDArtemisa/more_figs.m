


order_a_v1=[feature_mat_a(1,:).type];
order_a_v2=[feature_mat_a(2,:).type];
order_a_v3=[feature_mat_a(3,:).type];

order_da_v1=[feature_mat_da(1,:).type];
order_da_v2=[feature_mat_da(2,:).type];
order_da_v3=[feature_mat_da(3,:).type];

order_na_v1=[feature_mat_na(1,:).type];
order_na_v2=[feature_mat_na(2,:).type];
order_na_v3=[feature_mat_na(3,:).type];


figure
sub(1)=subplot(1,3,1)
hist(order_a_v1)
title('Video 2: Refugiado - Miedo VG')

sub(2)=subplot(1,3,2)
hist(order_a_v2)
title('Video 3: Queen - Alegria')

sub(3)=subplot(1,3,3)
hist(order_a_v3)
title('Video 4: Sotano - Miedo')

sgtitle('Histograma tipos de respuesta Adrenalina')
linkaxes(sub)


figure
sub(1)=subplot(1,3,1)
hist(order_da_v1)
title('Video 2: Refugiado - Miedo VG')

sub(2)=subplot(1,3,2)
hist(order_da_v2)
title('Video 3: Queen - Alegria')

sub(3)=subplot(1,3,3)
hist(order_da_v3)
title('Video 4: Sotano - Miedo')
sgtitle('Histograma tipos de respuesta Dopamina')
linkaxes(sub)

figure
sub(1)=subplot(1,3,1)
hist(order_na_v1)
title('Video 2: Refugiado - Miedo VG')

sub(2)=subplot(1,3,2)
hist(order_na_v2)
title('Video 3: Queen - Alegria')

sub(3)=subplot(1,3,3)
hist(order_na_v3)
title('Video 4: Sotano - Miedo')
sgtitle('Histograma tipos de respuesta Noradrenalina')
linkaxes(sub)

index1=1;
index2=1;
for video=1:3
    for voluntarias =1:21
        
        if strcmp(table2array(labels_reordered{1,voluntarias}(video+2,9)),'Miedo')
            order_na_miedo(index1)=feature_mat_na(video,voluntarias).type;
            order_a_miedo(index1)=feature_mat_a(video,voluntarias).type;
            order_da_miedo(index1)=feature_mat_da(video,voluntarias).type;
            index1=index1+1;
        else
            order_na_nomiedo(index2)=feature_mat_na(video,voluntarias).type;
            order_a_nomiedo(index2)=feature_mat_a(video,voluntarias).type;
            order_da_nomiedo(index2)=feature_mat_da(video,voluntarias).type;
            index2=index2+1;
        end
    end
end

figure
sub(1)=subplot(1,2,1)
hist(order_a_miedo)
title('Miedo')

sub(2)=subplot(1,2,2)
hist(order_a_nomiedo)
title('No miedo')


sgtitle('Histograma tipos de respuesta Adrenalina')
linkaxes(sub)

figure
sub(1)=subplot(1,2,1)
hist(order_da_miedo)
title('Miedo')

sub(2)=subplot(1,2,2)
hist(order_da_nomiedo)
title('No miedo')


sgtitle('Histograma tipos de respuesta Dopamina')
linkaxes(sub)


figure
sub(1)=subplot(1,2,1)
hist(order_na_miedo)
title('Miedo')

sub(2)=subplot(1,2,2)
hist(order_na_nomiedo)
title('No miedo')


sgtitle('Histograma tipos de respuesta Noradrenalina')
linkaxes(sub)



