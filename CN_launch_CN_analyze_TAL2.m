clc 
clear all
close all

%this script allows for a single-step simulation of the final thalamic
%module for a whole set of parameters (and for several realisations of
%the cortical input sequence to thalamus).

% the FOR statements elucidate on which parameters the present script
% cycles. The cycles along the several realizations are being performed by
% CN_analyze_TAL2.

% Obviously, it is mandatory to have already performed and saved all the
% simulations (up to the GPi module) for which you claim the thalamic
% simulation step --> no control for this aspect is present, nor in the
% present script neither in the CN_analyze_tal.m script


sim_length=1000;
t=[0:1:sim_length]';
tal2load='TAL8.mdl';
data_GPI;
data_TAL;
data_synapses;

load in_val;
i_v_16=in_val_16_norm2;
vt0=[i_v_16(321),i_v_16(324),i_v_16(321),i_v_16(324),i_v_16(321),i_v_16(324)];
ht0=[i_v_16(322),i_v_16(325),i_v_16(322),i_v_16(325),i_v_16(322),i_v_16(325)];
rt0=[i_v_16(323),i_v_16(326),i_v_16(323),i_v_16(326),i_v_16(323),i_v_16(326)];

n_giri=25; % number of realizartion of the thalamic simulation for a given set of thalamic parameters and for a given, previously performed, GPi simulation

mod_gpital=3;
ggpith=ggpith*mod_gpital;

ggpegpi_vec=[0 0.3 0.5 0.7 1]; %% several g GPE--> GPi conductances

cond_vec=cell(5,1); % several modes of the module --> change it if you've performed just some of them
cond_vec(1)=cellstr('norm');
cond_vec(2)=cellstr('park');
cond_vec(3)=cellstr('STNDBS');
cond_vec(4)=cellstr('GPEDBS');
cond_vec(5)=cellstr('GPIDBS');

frequenza_vec=[30 60 90 120 150 180]; % several DBS frequencies --> change it if you've performed just some of them

istriato_vec=[-13 -11 -9 -7 -5 -3 -1 0 1 3]; % several i striatum--> gpi currents --> change it if you've performed just some of them
for i=1:length(ggpegpi_vec)
    for j=1:length(istriato_vec)
        for k=1:length(cond_vec)
            for l=1:length(frequenza_vec)
                ggpegpi=ggpegpi_vec(i);
                is=istriato_vec(j);
                condizione=char(cond_vec(k));
                frequenza=frequenza_vec(l);
                CN_analyze_TAL2;
                clear SYNGPI
                clear VGPI 
                clear t_GPI
                clear t2
                clear u2 
                clear input6 
                clear I_SM n_SM           
            end
        end
    end
end
