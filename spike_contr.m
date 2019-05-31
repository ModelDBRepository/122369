function [corr_spikes missed_spikes false_spikes]=spike_contr(n_SM,t_S,I_S,t_T,sp_T)

%I_S=interp1(t_S,I_S,t_T);

I_S1=[I_S];
I_S2=[0; I_S(1:(length(I_S)-1))];
I_S3=I_S1-I_S2;

index_SM=find(I_S3>0);

I_S5=0.*I_S3;
for i=1:length(index_SM);
   if (index_SM(i)+6)<=length(I_S5);
      I_S5(index_SM(i):(index_SM(i)+6))=1;
   else
      I_S5(index_SM(i):length(I_S5))=1;
   end
end

for j=1:size(sp_T,2);
    
    sp_Tind=find(sp_T(:,j)>0);
    sp_Tind=floor(sp_Tind/2);
    sp_T2=zeros(length(I_S),1);
    sp_T2(sp_Tind)=1;
    
    %figure()
    %plot(t_S,sp_T2,'r',t_S,I_S5,'k');
    corr_spikes(j)=0;
    false_spikes(j)=0;
    
    verit=I_S5.*sp_T2;
    corr_spikes(j)=length(find(verit>0));
    
%     for i=1:(length(index_spikes))
%         flag=0;
%         ind=index_spikes(i);
%         if (ind+3)<=round(length(sp_T(:,j)));
%             ind2=ind+3;
%         else
%             ind2=round(length(sp_T(:,j)))
%         end
%         for k=ind:ind2
%             if I_S5(k)==1
%                 flag=1;
%             end
%         end
%         if flag==1
%             corr_spikes(j)=corr_spikes(j)+1;
%         end
%     end
    false_spikes(j)=length(sp_Tind)-corr_spikes(j);
    missed_spikes(j)=length(index_SM)-corr_spikes(j);
end
   