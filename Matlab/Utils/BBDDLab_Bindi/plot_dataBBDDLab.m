%s --> matriz
% pa --> start volunteer
% pb --> stop volunteer
% va --> start stimulus
% va --> stop stimulus
function plot_dataBBDDLab(s,pa,pb,va,vb)

    for i=pa:pb
        
    bvp=[];
    bvp_neutro=[];
    bvp_video=[];
    bvp_labels=[];
    bvp_recov=[];
    gsr0 = [];
    gsr0_neutro=[];
    gsr0_video=[];
    gsr0_labels=[];
    gsr0_recov=[];
    gsr=[];
    gsr_neutro=[];
    gsr_video=[];
    gsr_labels=[];
    gsr_recov=[];
    skt=[];
    skt_neutro=[];
    skt_video=[];
    skt_labels=[];
    skt_recov=[];
    
    f = figure('units','normalized','outerposition',[0 0 1 1]);
    f.Name = "Volunteer " + s{i,1}.ParticipantNum +  " Complete Experiment";
    tb=0;
    tg=0;
    ts=0;
%     
    for j=va:vb

        bvp_neutro = s{i, j}.EH.Neutro.raw.bvp_filt;
        bvp_video  = s{i, j}.EH.Video.raw.bvp_filt;
        bvp_labels = s{i, j}.EH.Labels.raw.bvp_filt;
        bvp_recov = s{i, j}.EH.Recovery.raw.bvp_filt;
        bvp = [bvp; bvp_neutro; bvp_video; bvp_labels; bvp_recov];

        gsr_neutro = s{i, j}.EH.Neutro.raw.gsr_uS_filtered_dn;
        gsr_video  = s{i, j}.EH.Video.raw.gsr_uS_filtered_dn;
        gsr_labels = s{i, j}.EH.Labels.raw.gsr_uS_filtered_dn;
        gsr_recov = s{i, j}.EH.Recovery.raw.gsr_uS_filtered_dn;
        gsr = [gsr; gsr_neutro; gsr_video; gsr_labels; gsr_recov];

        gsr0_neutro = s{i, j}.EH.Neutro.raw.gsr_uS_filtered_dn;
        gsr0_video  = s{i, j}.EH.Video.raw.gsr_uS_filtered_dn;
        gsr0_labels = s{i, j}.EH.Labels.raw.gsr_uS_filtered_dn;
        gsr0 = [gsr0; gsr0_neutro; gsr0_video; gsr0_labels];

        skt_neutro = s{i, j}.EH.Neutro.raw.skt_filt_dn_sm;
        skt_video  = s{i, j}.EH.Video.raw.skt_filt_dn_sm;
        skt_labels = s{i, j}.EH.Labels.raw.skt_filt_dn_sm;
        skt_recov = s{i, j}.EH.Recovery.raw.skt_filt_dn_sm;
        skt = [skt; skt_neutro; skt_video; skt_labels; skt_recov];

%         f = figure('units','normalized','outerposition',[0 0 1 1]);
%         f.Name = "Volunteer " + s{i,j}.ParticipantNum +  " Stimulus" + j;
%         
%         subplot(3,1,1)
%         t = 0:1/200:(length(bvp_neutro)/200 - 1/200);
%         plot(t, bvp_neutro,'b')
%         hold on
%         t = (t(end)+1/200):1/200:(t(end)+length(bvp_video)/200);
%         plot(t, bvp_video,'k')    
%         t = (t(end)+1/200):1/200:(t(end)+length(bvp_labels)/200);
%         plot(t, bvp_labels,'r')  
%         ylabel('A.U.') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
%         legend({'Neutro','Video','Labels'})
%         
%         subplot(3,1,2)
%         t = 0:1/10:(length(gsr_neutro)/10 - 1/10);
%         plot(t, gsr_neutro,'b')
%         hold on
%         t = (t(end)+1/10):1/10:(t(end)+length(gsr_video)/10);
%         plot(t, gsr_video,'k')
%         t = (t(end)+1/10):1/10:(t(end)+length(gsr_labels)/10);
%         plot(t, gsr_labels,'r')
%         ylabel('uSiemens') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
%         legend({'Neutro','Video','Labels'})
%         
%         subplot(3,1,3)
%         t = 0:1/10:(length(skt_neutro)/10 - 1/10);
%         plot(t, skt_neutro,'b')
%         hold on
%         t = (t(end)+1/10):1/10:(t(end)+length(skt_video)/10);
%         plot(t, skt_video,'k')
%         t = (t(end)+1/10):1/10:(t(end)+length(skt_labels)/10);
%         plot(t, skt_labels,'r')
%         ylabel('ºC') 
%         title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
%         legend({'Neutro','Video','Labels'})
        
        
        subplot(3,1,1)
        tb = tb(end):1/200:(tb(end)+length(bvp_neutro)/200 - 1/200);
        plot(tb, bvp_neutro,'b')
        hold on
        tb = (tb(end)+1/200):1/200:(tb(end)+length(bvp_video)/200);
        plot(tb, bvp_video,'k')    
        tb = (tb(end)+1/200):1/200:(tb(end)+length(bvp_labels)/200);
        plot(tb, bvp_labels,'r')  
        tb = (tb(end)+1/200):1/200:(tb(end)+length(bvp_recov)/200);
        plot(tb, bvp_recov,'g')  
        ylabel('A.U.') 
        title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
        legend({'Neutro','Video','Labels'})
        
        subplot(3,1,2)
        tg = tg(end):1/10:(tg(end)+length(gsr_neutro)/10 - 1/10);
        plot(tg, gsr_neutro,'b')
        hold on
        tg = (tg(end)+1/10):1/10:(tg(end)+length(gsr_video)/10);
        plot(tg, gsr_video,'k')
        tg = (tg(end)+1/10):1/10:(tg(end)+length(gsr_labels)/10);
        plot(tg, gsr_labels,'r')
        tg = (tg(end)+1/10):1/10:(tg(end)+length(gsr_recov)/10);
        plot(tg, gsr_recov,'g')  
        ylabel('uSiemens') 
        title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
        legend({'Neutro','Video','Labels'})
        
        subplot(3,1,3)
        ts = ts(end):1/10:(ts(end)+length(skt_neutro)/10 - 1/10);
        plot(ts, skt_neutro,'b')
        hold on
        ts = (ts(end)+1/10):1/10:(ts(end)+length(skt_video)/10);
        plot(ts, skt_video,'k')
        ts = (ts(end)+1/10):1/10:(ts(end)+length(skt_labels)/10);
        plot(ts, skt_labels,'r')
        ts = (ts(end)+1/10):1/10:(ts(end)+length(skt_recov)/10);
        plot(ts, skt_recov,'g')  
        ylabel('ºC') 
        title(['Volunteer ' s{i,j}.ParticipantNum ' Stimulus' num2str(j)])
        legend({'Neutro','Video','Labels'})
        
%         bvp=[];
%         bvp_neutro=[];
%         bvp_video=[];
%         bvp_labels=[];
%         gsr0 = [];
%         gsr0_neutro=[];
%         gsr0_video=[];
%         gsr0_labels=[];
%         gsr=[];
%         gsr_neutro=[];
%         gsr_video=[];
%         gsr_labels=[];
%         skt=[];
%         skt_neutro=[];
%         skt_video=[];
%         skt_labels=[];

    end

    end
    

    
end