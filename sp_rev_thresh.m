function [ist_spike soglia]=sp_rev_thresh(t,v,soglia,id1,id2)
vc=v-soglia;
for i=1:size(v,2)     
    v1=[0; vc(:,i)];
    v2=[vc(:,i); 0];
    i1=find(v2>0);
    i2=find(v1<0);
    i3=intersect(i1,i2);
    v3=v1.*0;
    v3(i3)=1;
    ist_spike(:,i)=v3(1:(length(v3)-1));
end
%figure()
% for i=1:size(v,2)
%     plot(t,v(:,i)-(i-1)*150); hold on
%     plot(t,20*ist_spike((1:(size(ist_spike,1))),i)-(i-1)*150+soglia,'r'); hold on
%     title(strcat(id1,'--',id2));
% end
%grid on;