function [stds,rds]=plot_dataBBDDLabGSRs(s,pa,pb,va,vb)

    stds = [];
    rds  = [];

    for i=pa:pb
        
    gsreh=[];
    gsreh_neutro=[];
    gsreh_video=[];
    gsreh_labels=[];
    gsreh_recov=[];
    
    gsrnew = [];
    gsrnew_neutro=[];
    gsrnew_video=[];
    gsrnew_labels=[];
    gsrnew_recov=[];
    
    gsrb=[];
    gsrb_neutro=[];
    gsrb_video=[];
    gsrb_labels=[];
    gsrb_recov=[];
    
%     f = figure('units','normalized','outerposition',[0 0 1 1]);
%     f.Name = "Volunteer " + s{i,1}.ParticipantNum +  " Complete Experiment";
%     tb1=0;
%     tgn1=0;
%     teh1=0;
%     tb2=0;
%     tgn2=0;
%     teh2=0;
    
    for j=va:vb

        gsreh_neutro = s{i, j}.EH.Neutro.raw.gsr_uS_filtered_dn_sm;
        gsreh_video  = s{i, j}.EH.Video.raw.gsr_uS_filtered_dn_sm;
        gsreh_labels = s{i, j}.EH.Labels.raw.gsr_uS_filtered_dn_sm;
        gsreh_recov = s{i, j}.EH.Recovery.raw.gsr_uS_filtered_dn_sm;
        gsreh_neutro = zscore(gsreh_neutro);
        gsreh_video  = zscore(gsreh_video);
        gsreh_labels = zscore(gsreh_labels);
        gsreh_recov = zscore(gsreh_recov);
        %gsreh = [gsreh; gsreh_neutro; gsreh_video; gsreh_labels; gsreh_recov];
        gsreh = [gsreh;  gsreh_video; ];

        gsrnew_neutro = s{i, j}.GSR.Neutro.raw.gsr_uS_filtered_dn_sm;
        gsrnew_video  = s{i, j}.GSR.Video.raw.gsr_uS_filtered_dn_sm;
        gsrnew_labels = s{i, j}.GSR.Labels.raw.gsr_uS_filtered_dn_sm;
        gsrnew_recov = s{i, j}.GSR.Recovery.raw.gsr_uS_filtered_dn_sm;
        gsrnew_neutro = zscore(gsrnew_neutro);
        gsrnew_video  = zscore(gsrnew_video);
        gsrnew_labels = zscore(gsrnew_labels);
        gsrnew_recov  = zscore(gsrnew_recov);
        %gsrnew = [gsrnew; gsrnew_neutro; gsrnew_video; gsrnew_labels; gsrnew_recov];
        gsrnew = [gsrnew; gsrnew_video;];

        %gsr_filtered is the ADC codes
        gsrb_neutro = (movmedian(movmean(downsample(s{i, j}.BINDI.Neutro.raw.gsr_filtered,20),10),5));
        %gsrb_neutro = (((downsample(s{i, j}.BINDI.Neutro.raw.gsr_filtered,20))));
        gsrb_neutro = -((1000000/1).*gsrb_neutro)./(gsrb_neutro - 16383);
        gsrb_neutro = 1./gsrb_neutro;
        gsrb_neutro = gsrb_neutro.*10e6;
        gsrb_video  = (movmedian(movmean(downsample(s{i, j}.BINDI.Video.raw.gsr_filtered,20),10),5));
        %gsrb_video  = (((downsample(s{i, j}.BINDI.Video.raw.gsr_filtered,20))));
        gsrb_video = -((1000000/1).*gsrb_video)./(gsrb_video - 16383);
        gsrb_video = 1./gsrb_video;
        gsrb_video = gsrb_video.*10e6;
        gsrb_labels = (movmedian(movmean(downsample(s{i, j}.BINDI.Labels.raw.gsr_filtered,20),10),5));
        %gsrb_labels = (((downsample(s{i, j}.BINDI.Labels.raw.gsr_filtered,20))));
        gsrb_labels = -((1000000/1).*gsrb_labels)./(gsrb_labels - 16383);
        gsrb_labels = 1./gsrb_labels;
        gsrb_labels = gsrb_labels.*10e6;
        gsrb_neutro = zscore(movmedian(movmean((gsrb_neutro),10),5));
        gsrb_video  = zscore(movmedian(movmean((gsrb_video),10),5));
        gsrb_labels = zscore(movmedian(movmean((gsrb_labels),10),5));
%         gsrb_neutro = movmean(zscore(gsrb_neutro),[20 20]);
%         gsrb_video  = movmean(zscore(gsrb_video),[20 20]);
%         gsrb_labels = movmean(zscore(gsrb_labels),[20 20]);
        gsrb = [gsrb; gsrb_neutro; gsrb_video; gsrb_labels];

        %%
        f = figure('units','normalized','outerposition',[0 0 1 1]);
        f.Name = "Volunteer " + s{i,j}.ParticipantNum +  " Stimulus" + j;
        
        subplot(3,1,1)
        
        t = 0:1/10:(length(gsreh_neutro)/10 - 1/10);
        plot(t, gsreh_neutro,'-.b','LineWidth',2)
        hold on
        t = (t(end)+1/10):1/10:(t(end)+length(gsreh_video)/10);
        plot(t, gsreh_video,'-.k','LineWidth',2)    
        t = (t(end)+1/10):1/10:(t(end)+length(gsreh_labels)/10);
        plot(t, gsreh_labels,'-.r','LineWidth',2)  
        
        t = 0:1/10:(length(gsrnew_neutro)/10 - 1/10);
        plot(t, gsrnew_neutro,'--b')
        hold on
        t = (t(end)+1/10):1/10:(t(end)+length(gsrnew_video)/10);
        plot(t, gsrnew_video,'--k')
        t = (t(end)+1/10):1/10:(t(end)+length(gsrnew_labels)/10);
        plot(t, gsrnew_labels,'--r')
        
        ylabel('uSiemens') 
        title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j) ' EH(-.) vs GSR(--)'])
        legend({'Neutro','Video','Labels'})
        
        subplot(3,1,2)
        
        t = 0:1/10:(length(gsreh_neutro)/10 - 1/10);
        plot(t, gsreh_neutro,'-.b','LineWidth',2)
        hold on
        t = (t(end)+1/10):1/10:(t(end)+length(gsreh_video)/10);
        plot(t, gsreh_video,'-.k','LineWidth',2)    
        t = (t(end)+1/10):1/10:(t(end)+length(gsreh_labels)/10);
        plot(t, gsreh_labels,'-.r','LineWidth',2) 
                
        t = 0:1/10:(length(gsrb_neutro)/10 - 1/10);
        plot(t, gsrb_neutro,'b')
        hold on
        t = (t(end)+1/10):1/10:(t(end)+length(gsrb_video)/10);
        plot(t, gsrb_video,'k')
        t = (t(end)+1/10):1/10:(t(end)+length(gsrb_labels)/10);
        plot(t, gsrb_labels,'r')

        ylabel('uSiemens') 
        title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j) ' EH(-.) vs BINDI'])
        legend({'Neutro','Video','Labels'})
        
        subplot(3,1,3)
        t = 0:1/10:(length(gsrnew_neutro)/10 - 1/10);
        plot(t, gsrnew_neutro,'--b','LineWidth',1)
        hold on
        t = (t(end)+1/10):1/10:(t(end)+length(gsrnew_video)/10);
        plot(t, gsrnew_video,'--k','LineWidth',1)
        t = (t(end)+1/10):1/10:(t(end)+length(gsrnew_labels)/10);
        plot(t, gsrnew_labels,'--r','LineWidth',1)
        
        t = 0:1/10:(length(gsrb_neutro)/10 - 1/10);
        plot(t, gsrb_neutro,'b')
        hold on
        t = (t(end)+1/10):1/10:(t(end)+length(gsrb_video)/10);
        plot(t, gsrb_video,'k')
        t = (t(end)+1/10):1/10:(t(end)+length(gsrb_labels)/10);
        plot(t, gsrb_labels,'r')

        ylabel('uSiemens') 
        title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j) ' GSR(--) vs BINDI'])
        legend({'Neutro','Video','Labels'})
        
        %estímulo a estimulo nos guardamos las stds de cada sensor
        [r,c]=size(stds);
        stds(r+1,1)= abs(std(gsreh))/abs((max(gsreh)-abs(min(gsreh))));
        stds(r+1,2)= abs(std(gsrnew))/abs((max(gsrnew)-abs(min(gsrnew))));
        stds(r+1,3)= std(gsrb);
        
        %estímulo a estimulo nos guardamos el rango de cada sensor
        [r,c]=size(rds);
        rds(r+1,1)= max(gsreh)-mean(gsreh);
        rds(r+1,2)= max(gsrnew)-mean(gsrnew);
        rds(r+1,3)= max(gsrb)-mean(gsrb);
        
        [~, order] = sort(stds(:,3));
        stds = stds(order,:);
        [~, order] = sort(rds(:,3));
        rds = rds(order,:);
        
        gsreh=[];
        gsreh_neutro=[];
        gsreh_video=[];
        gsreh_labels=[];

        gsrnew = [];
        gsrnew_neutro=[];
        gsrnew_video=[];
        gsrnew_labels=[];

        gsrb=[];
        gsrb_neutro=[];
        gsrb_video=[];
        gsrb_labels=[];
        
        
        
        %%
%         subplot(3,1,1)
%         
%         teh1 = teh1(end):1/10:(teh1(end)+length(gsreh_neutro)/10 - 1/10);
%         plot(teh1, gsreh_neutro,'-.b','LineWidth',1)
%         hold on
%         teh1 = (teh1(end)+1/10):1/10:(teh1(end)+length(gsreh_video)/10);
%         plot(teh1, gsreh_video,'-.k','LineWidth',1)    
%         teh1 = (teh1(end)+1/10):1/10:(teh1(end)+length(gsreh_labels)/10);
%         plot(teh1, gsreh_labels,'-.r','LineWidth',1)  
%         
%         tgn1 = tgn1(end):1/10:(tgn1(end)+length(gsrnew_neutro)/10 - 1/10);
%         plot(tgn1, gsrnew_neutro,'--b')
%         hold on
%         tgn1 = (tgn1(end)+1/10):1/10:(tgn1(end)+length(gsrnew_video)/10);
%         plot(tgn1, gsrnew_video,'--k')
%         tgn1 = (tgn1(end)+1/10):1/10:(tgn1(end)+length(gsrnew_labels)/10);
%         plot(tgn1, gsrnew_labels,'--r')
%         
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j) ' EH(-.) vs GSR(--)'])
%         legend({'Neutro','Video','Labels'})
%         
%         subplot(3,1,2)
%         
%         teh2 = teh2(end):1/10:(teh2(end)+length(gsreh_neutro)/10 - 1/10);
%         plot(teh2, gsreh_neutro,'-.b','LineWidth',1)
%         hold on
%         teh2 = (teh2(end)+1/10):1/10:(teh2(end)+length(gsreh_video)/10);
%         plot(teh2, gsreh_video,'-.k','LineWidth',1)    
%         teh2 = (teh2(end)+1/10):1/10:(teh2(end)+length(gsreh_labels)/10);
%         plot(teh2, gsreh_labels,'-.r','LineWidth',1) 
%                 
%         tb1 = tb1(end):1/10:(tb1(end)+length(gsrb_neutro)/10 - 1/10);
%         plot(tb1, gsrb_neutro,'b')
%         hold on
%         tb1 = (tb1(end)+1/10):1/10:(tb1(end)+length(gsrb_video)/10);
%         plot(tb1, gsrb_video,'k')
%         tb1 = (tb1(end)+1/10):1/10:(tb1(end)+length(gsrb_labels)/10);
%         plot(tb1, gsrb_labels,'r')
% 
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j) ' EH(-.) vs BINDI'])
%         legend({'Neutro','Video','Labels'})
%         
%         subplot(3,1,3)
%         tgn2 = tgn2(end):1/10:(tgn2(end)+length(gsrnew_neutro)/10 - 1/10);
%         plot(tgn2, gsrnew_neutro,'--b','LineWidth',1)
%         hold on
%         tgn2 = (tgn2(end)+1/10):1/10:(tgn2(end)+length(gsrnew_video)/10);
%         plot(tgn2, gsrnew_video,'--k','LineWidth',1)
%         tgn2 = (tgn2(end)+1/10):1/10:(tgn2(end)+length(gsrnew_labels)/10);
%         plot(tgn2, gsrnew_labels,'--r','LineWidth',1)
%         
%         tb2 = tb2(end):1/10:(tb2(end)+length(gsrb_neutro)/10 - 1/10);
%         plot(tb2, gsrb_neutro,'b')
%         hold on
%         tb2 = (tb2(end)+1/10):1/10:(tb2(end)+length(gsrb_video)/10);
%         plot(tb2, gsrb_video,'k')
%         tb2 = (tb2(end)+1/10):1/10:(tb2(end)+length(gsrb_labels)/10);
%         plot(tb2, gsrb_labels,'r')
% 
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j) ' GSR(--) vs BINDI'])
%         legend({'Neutro','Video','Labels'})
        

    end

    end
    

    
end