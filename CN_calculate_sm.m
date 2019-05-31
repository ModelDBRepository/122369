function [sm_input n_sm]=CN_calculate_sm(ampiezza,durata_input,durata)

%  Poisson distribution

a=rand(1000,1);
b=12-log(a)./0.03;

n_sm=0;
flag=0;
sm_input=[];

while flag==0   
    pd=round(b(n_sm+1));  
    period=[zeros(pd-durata_input,1); ampiezza*ones(durata_input,1)];
    if length(sm_input)<(durata-length(period));
        sm_input=[sm_input; period];
        n_sm=n_sm+1;
    else
        period=zeros(durata-length(sm_input),1);
        sm_input=[sm_input; period];
        flag=1;
    end
end
