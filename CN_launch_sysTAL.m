clc;
clear all;
close all;

% %  ----this script sims the thalamic module

% % --------------choose the GPi data to upload
[gpi2load, pathload, inutile] = uigetfile('simulazioni\GPI1*.mat','Choose the GPi data to upload:');
load(strcat('sims\',gpi2load));

% % ---------------choose the Thalamic model to use
[tal2load, pathload, inutile] = uigetfile('TAL*.mdl','Choose the Thalamic model to use:');

% % --------------define time vector
sim_length=1000;
t=[0:1:sim_length]';

% % ------------upload parameters

data_GPI;
data_TAL;
data_synapses;

ggpith=ggpith*2;

% % -------------upload initial conditions
load in_val

i_v_16=in_val_16_norm2;

vt0=[i_v_16(321),i_v_16(324),i_v_16(321),i_v_16(324),i_v_16(321),i_v_16(324)];
ht0=[i_v_16(322),i_v_16(325),i_v_16(322),i_v_16(325),i_v_16(322),i_v_16(325)];
rt0=[i_v_16(323),i_v_16(326),i_v_16(323),i_v_16(326),i_v_16(323),i_v_16(326)];

% % ---------CTX input
amp_SM=6;
dur_SM=5;

[I_SM n_SM]=CN_calculate_sm(amp_SM,dur_SM,length(t));

input6=[t I_SM];

tagSM=strcat(num2str(amp_SM),'-',num2str(dur_SM));
t_SM=t;

% % -------------------------sim!
tic
t2=t_GPI;
u2=[SYNGPI];
sim(tal2load,t(sim_length+1),[],[]);
toc
% ------------ sample!
freq_camp=2000; %in Hz
passo=1000/freq_camp;

t_TALc=(0:passo:t_TAL(length(t_TAL)))';
VTALc=interp1(t_TAL,VTAL,t_TALc);
IGPTALc=interp1(t_TAL,IGPTAL,t_TALc);

% ------------ spikes detection through a threshold method 
soglia_TAL=-40;
[sp_TAL  soglia_TAL]=sp_rev_thresh(t_TALc,VTALc,soglia_TAL,'TAL','TAL');

%----------- thalamic spikes count; .
[correc miss fal]=spike_contr(n_SM,t_SM,I_SM,t_TALc,sp_TAL);
correc2=mean(correc);
false2=mean(fal);
missed2=mean(miss);
% % ------------------------save!
modelloTAL=tal2load(1:(length(tal2load)-4));
tagTAL=strcat(modelloTAL,'--',num2str(sim_length),'--',tagSM,'--',tagGPI);
filematTAL=strcat(tagTAL,'.mat');
save(strcat('sims\',filematTAL),'t_TAL','VTAL','t_SM','I_SM','IGPTAL','tagTAL','filematGPI','filematTAL','filematGPESTN','n_SM');

% % --------upload GPeSTN data
load(strcat('sims\',filematGPESTN));

% % ------------------------plot!
figure(1)
for i=1:min(size(VGPE))
    plot(t_GPESTN,VGPE(:,i)-(i-1)*150); hold on
end
grid; 
title(strcat('VGPE--',tagSTNGPE));

figure(2)
for i=1:min(size(VSTN))
    plot(t_GPESTN,VSTN(:,i)-(i-1)*150); hold on
end
grid; 
title(strcat('VSTN--',tagSTNGPE))

figure(3);
for i=1:min(size(VGPI))
    plot(t_GPI,VGPI(:,i)-(i-1)*150); hold on
end
grid; 
title(strcat('VGPI--',tagGPI));

figure(4);
subplot(2,1,1)
for i=1:min(size(VTAL))
    plot(t_TAL,VTAL(:,i)-(i-1)*150); hold on
end
grid;
hold on;
plot(t,5*I_SM,'r')
title(strcat('VTAL--',tagTAL));

subplot(2,1,2)
for i=1:min(size(IGPTAL))
    plot(t_TAL,IGPTAL(:,i)-(i-1)*10); hold on
end
grid; 
title(strcat('IGPTAL--',tagTAL));