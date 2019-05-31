clc
clear
close all
% %  ----this script sims DBS on GPe neurons; input current to GPe
% is the sum of IDBS and of Imore_GPe
% %---------choose model and parameters
[stngpe2load, pathload, inutile] = uigetfile('GPE*.mdl','Choose the GPeSTN model to use:');
sim_length=1000;
t=[0:1:sim_length]';
data_GPE;
data_STN;
data_synapses;

%upload initial conditions
load in_val
i_v_16=in_val_16_park2;
vs0=i_v_16(1:16);
hs0=i_v_16(17:32);
ns0=i_v_16(33:48);
rs0=i_v_16(49:64);
cas0=i_v_16(65:80);
ss0=i_v_16(81:96);

vg0=i_v_16(113:128);
hg0=i_v_16(129:144);
ng0=i_v_16(145:160);
rg0=i_v_16(161:176);
cag0=i_v_16(177:192);
sg0=i_v_16(193:208);

% % -------------------------------  other parameters
ggpegpe=0;
istriato=-4;
ISTRIATO=istriato*ones(length(t),1);

% % ---------------------------------------  definition of IDBS (input DBS)
passo_DBS=0.01;
t_DBS=[0:passo_DBS:sim_length]';
amp_DBS=400;
freq_DBS=120;
dur_DBS=60;

flag=0;
IDBS=[];
while flag==0       
    dur0_DBS=floor((1000/freq_DBS)/passo_DBS)-dur_DBS;
    period_DBS=[zeros(dur0_DBS,1); amp_DBS*ones(dur_DBS,1)];
    if (length(IDBS)+length(period_DBS))<(length(t_DBS));
        IDBS=[IDBS; period_DBS];
    else
        period_DBS=zeros(length(t_DBS)-length(IDBS),1);
        IDBS=[IDBS; period_DBS];
        flag=1;
    end
end
figure()
plot(t_DBS,IDBS);
title('IDBS');

if amp_DBS==0
    dbstag='0';
else
    dbstag=strcat(num2str(amp_DBS),'-',num2str(freq_DBS),'-',num2str(dur_DBS));
end


% %  -----------------------definition of additional currents
imore_stn=25;
imore_gpe=2;
% % definition of IMORE_GPE
%IMORE_GPE=imore_gpe*ones(length(t),1);
% % definition of IMORE_STN
IMORE_STN=imore_stn*ones(length(t),1);

% % ------------------------ preparation of inputs

input1=[t ISTRIATO];
input2=[t_DBS IDBS+imore_gpe];
input3=[t zeros(length(t),1)];
input4=[t IMORE_STN];

% %---------------------------sim!

tic
sim(stngpe2load,t(sim_length+1),[],[]);
toc

% %------------------------------save!
modelloSTNGPE=stngpe2load(1:(length(stngpe2load)-4));
tagSTNGPE=strcat(modelloSTNGPE,'--',num2str(sim_length),'--',num2str(istriato),'--',num2str(ggpegpe),'--',dbstag);
filematGPESTN=strcat(tagSTNGPE,'.mat');

save(strcat('sims\',filematGPESTN),'t_GPESTN','VGPE','VSTN','istriato','ggpegpe','filematGPESTN','tagSTNGPE');

% %----------------------------plot

figure(2)
for i=1:min(size(VGPE))
    plot(t_GPESTN,VGPE(:,i)-(i-1)*150); hold on
end
grid; 
title(strcat('VGPE--',tagSTNGPE));

figure(3)
for i=1:min(size(VGPE))
    plot(t_GPESTN,VSTN(:,i)-(i-1)*150); hold on
end
grid; 
title(strcat('VSTN--',tagSTNGPE));

%% obsolete
% figure(5)
% for i=1:min(size(VGPE))
%     plot(t_GPESTN,cagpe); hold on
% end
% grid; 
% title(cagpe);
% 
% figure(6)
% for i=1:min(size(VGPE))
%     plot(t_GPESTN,rgpe); hold on
% end
% grid; 
% title(rgpe);
% 
% figure(7)
% for i=1:min(size(VGPE))
%     plot(t_GPESTN,iahpgpe); hold on
% end
% grid; 
% title(iahpgpe);