
figure
plot(all_raw{1,1}.gsr_uS)
hold on
plot(all_raw{1,1}.index,all_raw{1,1}.gsr_uS(all_raw{1,1}.index),'*r')

figure
plot(all_raw{1,5}.gsr_uS)
hold on
plot(all_raw{1,5}.index,all_raw{1,5}.gsr_uS(all_raw{1,5}.index),'*r')


figure
plot(all_raw{1,5}.bvp)
hold on
plot(all_raw{1,5}.index,all_raw{1,5}.bvp(all_raw{1,5}.index),'*r')

figure
plot(all_raw{1,8}.bvp)
hold on
plot(all_raw{1,8}.index,all_raw{1,8}.bvp(all_raw{1,8}.index),'*r')


