clc;
clear all;
close all;

% %-----------------upload GPeSTN data
[gpestn2load, pathload, inutile] = uigetfile('simulazioni\GPE*.mat','upload GPeSTN data:');
load(strcat('sims\',gpestn2load));

% %---------------choose the GPi model
[gpi2load, pathload, inutile] = uigetfile('GPI*.mdl','choose the GPi model:');

% % --------------define time vector
sim_length=1000;
t=[0:1:sim_length]';

% % ------------upload parameters
data_GPE;
data_STN;
data_GPI;
data_synapses;


% %-------------upload initial conditions
load in_val;

i_v_16=in_val_16_park2;
sis0=i_v_16(97:112);

sig0=i_v_16(209:224);

vgi0=i_v_16(225:240);
hgi0=i_v_16(241:256);
ngi0=i_v_16(257:272);
rgi0=i_v_16(273:288);
cagi0=i_v_16(289:304);
sgi0=i_v_16(305:320);

% %  -----------------------define additional currents and ISTRIATO DIR
% % define IMORE_GPI
ggpegpi=0.3;
imore_gpi=5;
istriato_dir=-9;
IMORE_GPI=(imore_gpi+istriato_dir)*ones(length(t),1);
input5=[t IMORE_GPI];

% % ------------------------DBS!

% % ---------------------------------------  define IDBS (input DBS)
passo_DBS=0.1;%choose 0.01 if  simulating DBS;
t_DBS=[0:passo_DBS:sim_length]';
amp_DBS=0; %% choose 400 if simulating DBS
freq_DBS=180;
dur_DBS=30;

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

input6=[t_DBS IDBS];
% %-------------------------sim!
tic
t1=t_GPESTN;
u1=[VSTN,VGPE];
sim(gpi2load,t(sim_length+1),[],[]);
toc

% %------------------------save!
modelloGPI=gpi2load(1:(length(gpi2load)-4));
tagGPI=strcat(modelloGPI,'--',num2str(ggpegpi),'--',num2str(sim_length),'--',num2str(istriato_dir),'--',dbstag,'--',tagSTNGPE);
filematGPI=strcat(tagGPI,'.mat');
save(strcat('sims\',filematGPI),'t_GPI','VGPI','SYNGPI','filematGPI','tagGPI','filematGPESTN');

% %------------------------plot!

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
