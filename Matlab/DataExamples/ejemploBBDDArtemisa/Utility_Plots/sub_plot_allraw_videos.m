% Plot online heart variables
for voluntaria=1:length(allraw)
if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
num_var=2;
else
num_var=1;
end
%     temp=[allraw{1,voluntaria}.bvp_filt(1:allraw{1,voluntaria}.index(1)); ...
%         allraw{1,voluntaria}.bvp_filt(allraw{1,voluntaria}.index(3):allraw{1,voluntaria}.index(4));...
%         allraw{1,voluntaria}.bvp_filt(allraw{1,voluntaria}.index(6):allraw{1,voluntaria}.index(7));...
%         allraw{1,voluntaria}.bvp_filt(allraw{1,voluntaria}.index(9):allraw{1,voluntaria}.index(10))];
temp=[allraw{1,voluntaria}.bvp(1:allraw{1,voluntaria}.index(1)); ...
allraw{1,voluntaria}.bvp(allraw{1,voluntaria}.index(3):allraw{1,voluntaria}.index(4));...
allraw{1,voluntaria}.bvp(allraw{1,voluntaria}.index(6):allraw{1,voluntaria}.index(7));...
allraw{1,voluntaria}.bvp(allraw{1,voluntaria}.index(9):allraw{1,voluntaria}.index(10))];
index_temp(1)=allraw{1,voluntaria}.index(1);
index_temp(2)=index_temp(1)+allraw{1,voluntaria}.index(4)-allraw{1,voluntaria}.index(3);
index_temp(3)=index_temp(2)+allraw{1,voluntaria}.index(7)-allraw{1,voluntaria}.index(6);
%     index_temp(4)=index_temp(3)+allraw{1,voluntaria}.index(9)-allraw{1,voluntaria}.index(10);
ax=0;
figure
ax(1)=subplot(num_var,1,1);
plot(temp)
hold on
plot(index_temp,temp(index_temp),'*r')
if isfield(allraw{1,voluntaria},'ecg') && ~isempty(allraw{1,voluntaria}.ecg)
temp_ecg=[allraw{1,voluntaria}.ecg_filt(1:allraw{1,voluntaria}.index(1)); ...
allraw{1,voluntaria}.ecg_filt(allraw{1,voluntaria}.index(3):allraw{1,voluntaria}.index(4));...
allraw{1,voluntaria}.ecg_filt(allraw{1,voluntaria}.index(6):allraw{1,voluntaria}.index(7));...
allraw{1,voluntaria}.ecg_filt(allraw{1,voluntaria}.index(9):allraw{1,voluntaria}.index(10))];
ax(2)=subplot(num_var,1,2);
plot(temp_ecg)
hold on
plot(index_temp,temp_ecg(index_temp),'*r')
end
linkaxes(ax,'x');
end