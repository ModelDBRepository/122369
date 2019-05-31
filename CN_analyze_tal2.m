% the present script has been designed to be launched by
% CN_launch_CN_analyze_tal2.m. It takes the GPi sim results defined by the
% several parameters CN_launch_CN_analyze_tal2.m cycle on, and sims a
% number of realization of the thalamic module. Then, it calculates the
% number of correct, false, and missed thalamic responses to cortical
% inputs, calculates their mean across realizations, and saves results.


% try to recover the rgiht GPI sim results a
strGPESTN='GPESTN1';

switch condizione
    case 'norm'
        str1='0';
        str2='0--0.3--0';
        str3=condizione;
    case 'park'
        str1='0';
        str2='-4--0--0';
        str3=condizione;
    case 'STNDBS'
        str1='0';
        str2=strcat('-4--0--400-',num2str(frequenza),'-15');
        str3=strcat(condizione,'-',num2str(frequenza));
    case 'GPEDBS'
        str1='0';
        str2=strcat('-4--0--400-',num2str(frequenza),'-120');
        str3=strcat(condizione,'-',num2str(frequenza));
        strGPESTN='GPESTN1_GPEDBS';
    case 'GPIDBS'
        str1=strcat('400-',num2str(frequenza),'-30');
        str2='-4--0--0';
        str3=strcat(condizione,'-',num2str(frequenza));
end
stringtoload=strcat('sims\GPI1--',num2str(ggpegpi),'--1000--',num2str(is),'--',str1,'--',strGPESTN,'--1000--',str2,'.mat');

load(stringtoload);


% SIMS!
for s=1:n_giri

    close all
    % %---------Input from cortex
    amp_SM=6;
    dur_SM=5;

    [I_SM n_SM]=CN_calculate_sm(amp_SM,dur_SM,length(t));
    input6=[t I_SM];
    t_SM=t;

    %sim!

    t2=t_GPI;
    u2=[SYNGPI];
    tic
    sim(tal2load,1000,[],[]);
    toc
    % % ------------ sample!
    freq_camp=2000; %in Hz
    passo=1000/freq_camp;

    t_TALc=(0:passo:t_TAL(length(t_TAL)))';
    VTALc=interp1(t_TAL,VTAL,t_TALc);
    IGPTALc=interp1(t_TAL,IGPTAL,t_TALc);

    % % ------------ spike detection
    soglia_TAL=-40;
    [sp_TAL  soglia_TAL]=sp_rev_thresh(t_TALc,VTALc,soglia_TAL,'TAL','TAL');

    % ----------- count and classify thalamic spikes
    [correc(s,:) miss(s,:) fal(s,:)]=spike_contr(n_SM,t_SM,I_SM,t_TALc,sp_TAL);
    correc2(s)=mean(correc(s,:))*100/n_SM;
    false2(s)=mean(fal(s,:))*100/n_SM;
    missed2(s)=mean(miss(s,:))*100/n_SM;

end

% calculate mean results across realizations
correct_media=mean(correc2);
false_media=mean(false2);
missed_media=mean(missed2);
correct_std=std(correc2);
false_std=std(false2);
missed_std=std(missed2);

% save!
savefile=strcat('analysis_CN_TAL\CN--TAL--',num2str(mod_gpital),'--',num2str(ggpegpi),'--',num2str(is),'--',str3,'.mat');
savefile
save(savefile,'correct_media','false_media','missed_media','correct_std','false_std','missed_std');






