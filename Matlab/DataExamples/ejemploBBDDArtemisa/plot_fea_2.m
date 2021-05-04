


plot([feature_mat_a(1,:).first_peak_pos],[feature_mat_a(1,:).first_valley_pos],"*");

for video=1:3
    num_peaks_a(video,:)=[feature_mat_a(video,:).num_peaks];
    num_valleys_a(video,:)=[feature_mat_a(video,:).num_valleys];
%     temp1=[feature_mat_a(1,:).first_peak_pos];
end

% first_peak_pos_a_1_1(1,:)=temp1(num_peaks_a(1,:)==1&num_valleys_a(1,:)==1);
% first_peak_pos_a_2_1(1,:)=temp1(num_peaks_a(1,:)==2&num_valleys_a(1,:)==1);
% 
% first_peak_pos_a_1_2(1,:)=temp1(num_peaks_a(1,:)==1&num_valleys_a(1,:)==2);
% first_peak_pos_a_2_2(1,:)=temp1(num_peaks_a(1,:)==2&num_valleys_a(1,:)==2);
% peaks


temp_index=1:21;
temp_index=temp_index(num_peaks_a(1,:)==2&num_valleys_a(1,:)==2);

temp1=[feature_mat_a(1,temp_index).order];

order_a_2_2_video_1=reshape(temp1,[4 sum(num_peaks_a(1,:)==2 & num_valleys_a(1,:)==2)])



temp_index=1:21;
temp_index=temp_index(num_peaks_a(2,:)==2&num_valleys_a(2,:)==2);

temp1=[feature_mat_a(2,temp_index).order];

order_a_2_2_video_2=reshape(temp1,[4 sum(num_peaks_a(2,:)==2 & num_valleys_a(2,:)==2)])


temp_index=1:21;
temp_index=temp_index(num_peaks_a(3,:)==2&num_valleys_a(3,:)==2);

temp1=[feature_mat_a(3,temp_index).order];

order_a_2_2_video_3=reshape(temp1,[4 sum(num_peaks_a(3,:)==2 & num_valleys_a(3,:)==2)])

figure
plot([feature_mat_a(1,:).type],'*')

figure
plot([feature_mat_a(2,:).type],'*')


figure
plot([feature_mat_a(3,:).type],'*')



