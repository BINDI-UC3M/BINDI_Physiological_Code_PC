

voluntaria=16

diff_vect=diff(allraw{1,voluntaria}.packet_id);
pos_errors=diff_vect~=1;
size_errors=diff_vect(diff(allraw{1,voluntaria}.packet_id)~=1);

figure
plot(diff_vect)
hold on
plot(allraw{1,voluntaria}.index-1,diff_vect(allraw{1,voluntaria}.index-1),'*r')


% figure;plot(allraw{1, 12}.packet_id)
% hold on
% plot(pos_errors*3.5e5)
