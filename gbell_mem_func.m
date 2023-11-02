function [S1,S2,K3]=gbell_mem_func(A,mew,radii)  %%S1is for positive and S2 is for negative
[no_input,no_col]=size(A);
A1=A(A(:,end)==1,1:end-1);
B1=A(A(:,end)~=1,1:end-1);
K1 = exp(-(1/(mew^2))*(repmat(sqrt(sum(A1.^2,2).^2),1,size(A1,1))-2*(A1*A1')+repmat(sqrt(sum(A1.^2,2)'.^2),size(A1,1),1)));
K2 = exp(-(1/(mew^2))*(repmat(sqrt(sum(B1.^2,2).^2),1,size(B1,1))-2*(B1*B1')+repmat(sqrt(sum(B1.^2,2)'.^2),size(B1,1),1)));
A_temp=A(:,1:end-1);
K3 = exp(-(1/(mew^2))*(repmat(sqrt(sum(A_temp.^2,2).^2),1,size(A_temp,1))-2*(A_temp*A_temp')+repmat(sqrt(sum(A_temp.^2,2)'.^2),size(A_temp,1),1)));

radiusxp=sqrt(1-2*mean(K1,2)+mean(mean(K1)));
radiusmaxxp=max(radiusxp);
radiusxn=sqrt(1-2*mean(K2,2)+mean(mean(K2)));
radiusmaxxn=max(radiusxn);
a1=radii*radiusmaxxp;
a2=radii*radiusmaxxn;
alpha_d=max(radiusmaxxp,radiusmaxxn);

b1=a1;
b2=a2;
frac1=(radiusxp./a1).^(2*b1);
frac2=(radiusxn./a2).^(2*b2);
m1=size(A1,1);
m2=size(B1,1);
% ir=m2/m1;
mem1=1./(1+frac1);
mem2=1./(1+frac2);

ro=[];
DD=sqrt(2*(ones(size(K3))-K3));
for i=1:no_input

    temp=DD(i,:)';
    B1=A(temp<alpha_d,:);

    [x3,~]=size(B1);
    count=sum(A(i,end)*ones(size(B1,1),1)==B1(:,end));

    x5=count/x3;
    ro=[ro;x5];
end

A2=[A(:,no_col) ro];
ro2=A2(A2(:,1)==-1,2);
ro1=A2(A2(:,1)~=-1,2);

if m1>=m2
    S1=mem1.*ro1.*(m2/m1);
    S2=ones(m2,1);
else %%m2>=m1
    S1=ones(m1,1);
    S2=mem2.*ro2.*(m1/m2);
end
end