%PRUEBA
%-----------------------------------------------------------------------------------------------------------
num=0;
valor=0;
voluntaria=3;
bvpcarac=[3 4 12 13 17 18];
gsrcarac=[1 2 3 4 6];
for i=1:1:6
valor=bvpcarac(1,i);
c_1= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 1}.EH.Neutro.BVP_feats(:,valor);      % Generate group 1(Neutro)
c_2= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 1}.EH.Video.BVP_feats(:,valor);       % Generate group 2 (Video)
c_3= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 2}.EH.Neutro.BVP_feats(:,valor);
c_4= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 2}.EH.Video.BVP_feats(:,valor);
c_5= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 3}.EH.Neutro.BVP_feats(:,valor);
c_6= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 3}.EH.Video.BVP_feats(:,valor);
c_7= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 4}.EH.Neutro.BVP_feats(:,valor);
c_8= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 4}.EH.Video.BVP_feats(:,valor);
c_9= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 5}.EH.Neutro.BVP_feats(:,valor);
c_10= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 5}.EH.Video.BVP_feats(:,valor);
c_11= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 6}.EH.Neutro.BVP_feats(:,valor);
c_12= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 6}.EH.Video.BVP_feats(:,valor);
c_13= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 7}.EH.Neutro.BVP_feats(:,valor);
c_14= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 7}.EH.Video.BVP_feats(:,valor);
c_15= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 8}.EH.Neutro.BVP_feats(:,valor);
c_16= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 8}.EH.Video.BVP_feats(:,valor);
c_17= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 9}.EH.Neutro.BVP_feats(:,valor);
c_18= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 9}.EH.Video.BVP_feats(:,valor);
c_19= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 10}.EH.Neutro.BVP_feats(:,valor);
c_20= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 10}.EH.Video.BVP_feats(:,valor);
c_21= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 11}.EH.Neutro.BVP_feats(:,valor);
c_22= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 11}.EH.Video.BVP_feats(:,valor);
c_23= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 12}.EH.Neutro.BVP_feats(:,valor);
c_24= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 12}.EH.Video.BVP_feats(:,valor);
c_25= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 13}.EH.Neutro.BVP_feats(:,valor);
c_26= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 13}.EH.Video.BVP_feats(:,valor);
c_27= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 14}.EH.Neutro.BVP_feats(:,valor);
c_28= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 14}.EH.Video.BVP_feats(:,valor);
C = {c_1(:); c_2(:);c_3(:);c_4(:);c_5(:);c_6(:);c_7(:);c_8(:);c_9(:);c_10(:);c_11(:);c_12(:);c_13(:);c_14(:);c_15(:);c_16(:);c_17(:);c_18(:);c_19(:);c_20(:);c_21(:);c_22(:);c_23(:);c_24(:);c_25(:);c_26(:);c_27(:);c_28(:)};  % <--- Just vertically stack all of your groups here
grp = cell2mat(arrayfun(@(i){i*ones(numel(C{i}),1)},(1:numel(C))'));
num=num+1;
figure(num)
% boxplot(vertcat(C{:}),grp, 'Labels',{'1','V','2','V','3','V','4','V','5','V','6','V','7','V','8','V','9','V','10','V','11','V','12','V','13','V','14','V'})
xlabel('Fase del video')
        if i==1
            title('HRV')
        elseif i==2
            title('IBI')
        elseif i==3
            title('LFnorm')
        elseif i==4
            title('HFnorm')
        elseif i==5
            title('sd2')
        else
            title('sd1')
        end
end
for i=1.0:1.0:5.0
valor=gsrcarac(1,i);
c_1= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 1}.EH.Neutro.GSR_feats(:,valor);      % Generate group 1(Neutro)
c_2= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 1}.EH.Video.GSR_feats(:,valor);       % Generate group 2 (Video)
c_3= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 2}.EH.Neutro.GSR_feats(:,valor);
c_4= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 2}.EH.Video.GSR_feats(:,valor);
c_5= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 3}.EH.Neutro.GSR_feats(:,valor);
c_6= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 3}.EH.Video.GSR_feats(:,valor);
c_7= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 4}.EH.Neutro.GSR_feats(:,valor);
c_8= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 4}.EH.Video.GSR_feats(:,valor);
c_9= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 5}.EH.Neutro.GSR_feats(:,valor);
c_10= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 5}.EH.Video.GSR_feats(:,valor);
c_11= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 6}.EH.Neutro.GSR_feats(:,valor);
c_12= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 6}.EH.Video.GSR_feats(:,valor);
c_13= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 7}.EH.Neutro.GSR_feats(:,valor);
c_14= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 7}.EH.Video.GSR_feats(:,valor);
c_15= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 8}.EH.Neutro.GSR_feats(:,valor);
c_16= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 8}.EH.Video.GSR_feats(:,valor);
c_17= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 9}.EH.Neutro.GSR_feats(:,valor);
c_18= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 9}.EH.Video.GSR_feats(:,valor);
c_19= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 10}.EH.Neutro.GSR_feats(:,valor);
c_20= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 10}.EH.Video.GSR_feats(:,valor);
c_21= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 11}.EH.Neutro.GSR_feats(:,valor);
c_22= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 11}.EH.Video.GSR_feats(:,valor);
c_23= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 12}.EH.Neutro.GSR_feats(:,valor);
c_24= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 12}.EH.Video.GSR_feats(:,valor);
c_25= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 13}.EH.Neutro.GSR_feats(:,valor);
c_26= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 13}.EH.Video.GSR_feats(:,valor);
c_27= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 14}.EH.Neutro.GSR_feats(:,valor);
c_28= BBDDLab_EH_FeaturesBVPGSR_NoVVG_IT02_47V.features{voluntaria, 14}.EH.Video.GSR_feats(:,valor);
C = {c_1(:); c_2(:);c_3(:);c_4(:);c_5(:);c_6(:);c_7(:);c_8(:);c_9(:);c_10(:);c_11(:);c_12(:);c_13(:);c_14(:);c_15(:);c_16(:);c_17(:);c_18(:);c_19(:);c_20(:);c_21(:);c_22(:);c_23(:);c_24(:);c_25(:);c_26(:);c_27(:);c_28(:)};  % <--- Just vertically stack all of your groups here
grp = cell2mat(arrayfun(@(i){i*ones(numel(C{i}),1)},(1:numel(C))'));
num=num+1;
figure(num)
boxplot(vertcat(C{:}),grp, 'Labels',{'1','V','2','V','3','V','4','V','5','V','6','V','7','V','8','V','9','V','10','V','11','V','12','V','13','V','14','V'})
xlabel('Fase del video')
        if i==1
            title('nbPeaks')
        elseif i==2
            title('ampPeaks')
        elseif i==3
            title('riseTime')
        elseif i==4
            title('recoveryTime')
        else
            title('meanGSR')

        end
end
