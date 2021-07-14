
in_sig=out_struct{15, 1}.EH.Video.raw.ecg_filt;

samprate_bbddlab_bvp=200;
    % 1.4: BVP advanced data processing: Wavelet Synchrosqueezed Transform
     time=0:1/samprate_bbddlab_bvp:...
          (length(in_sig)/samprate_bbddlab_bvp - 1/samprate_bbddlab_bvp);
     iterations = 2;
     for w=1:iterations
       figure;
       plot(time,in_sig)
       hold on;
       imfs = emd(in_sig,'Display',0);
       z =in_sig;
       [~,b] = size(imfs);
       for j=4:b
         z = z - imfs(:,j);
       end
       [sst,F] = wsst(z,samprate_bbddlab_bvp);
       t=find(F>0.8 & F<3.5);
       [fridge,iridge] = wsstridge(sst(t,:),2,F(1,t),'NumRifges',1);
       xrec = iwsst(sst(t,:),iridge);
       in_sig = xrec(:,1) ;%+ xrec(:,2);
       plot(time,in_sig);
       in_sig=in_sig';
       
%        Draw result:
       figure;
       plot(time,fridge,'k--','linewidth',4);
       hold on;
       contour(time,F(1,t),abs(sst(t,:)));
       ylim([0.5 3.5]);
     end