function [auc,train_time] = CGFTSVM_ID_func(Test_data,Train_data,FunPara)
% Training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kerfPara = FunPara.kerfpara;
c1=FunPara.c_1;
c3=c1;
c2=FunPara.c_2;
c4=c2;
omega=FunPara.Omega;
radi_num=FunPara.a;
[~,no_col]=size(Train_data);
obs = Train_data(:,no_col);
A = Train_data(obs==1,1:end-1);
B = Train_data(obs~=1,1:end-1);
[m1,~]=size(A);
[m2,~]=size(B);
e1=ones(m1,1);
e2=ones(m2,1);
mew=kerfPara.pars;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
if strcmp(kerfPara.type,'lin')
    H=[A,e1];
    G=[B,e2];
else
    C=[A;B];
    K1=kernelfun_CGFTSVM_ID(A,kerfPara,C);
    H=[K1,e1];
    G=[kernelfun_CGFTSVM_ID(B,kerfPara,C),e2];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Compute (w1,b1) and (w2,b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DTWSVM1
[s1,s2,K3]=gbell_mem_func(Train_data,mew,radi_num);
lb1=zeros(m2 ,1);
ub1=c2*s2;
HH=H'*H;
HH = HH + c1*eye(size(HH));%regularization
HHG = HH\G';
kerH1=G*HHG;
kerH1=(kerH1+kerH1')/2;
alpha=qpSOR_CGFTSVM_ID(kerH1,-e2,omega,lb1,ub1,0.05);
vpos=-HHG*alpha;

%% DTWSVM2
lb2=zeros(m1 ,1);
ub2=c4*s1;
QQ=G'*G;
QQ=QQ + c3*eye(size(QQ));%regularization
QQP=QQ\H';
kerH2=H*QQP;
kerH2=(kerH2+kerH2')/2;
gamma=qpSOR_CGFTSVM_ID(kerH2,-e1,omega,lb2,ub2,0.05);
vneg=QQP*gamma;
%     clear kerH1 H G HH HHG QQ QQP;
train_time=toc;
w1=vpos(1:(length(vpos)-1));
b1=vpos(length(vpos));
w2=vneg(1:(length(vneg)-1));
b2=vneg(length(vneg));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test_X=Test_data(:,1:end-1);
test_label=Test_data(:,end);
tst_num=size(Test_data,1);
if strcmp(kerfPara.type,'lin')
    T_mat=Test_data(:,end-1);
    y1=T_mat*w1+b1*ones(tst_num,1);
    y2=T_mat*w2+b2*ones(tst_num,1);
else
    C=[A;B];
    T_mat=kernelfun_CGFTSVM_ID(test_X,kerfPara,C);
    y1=(T_mat*w1+b1*ones(tst_num,1))/sqrt(w1'*K3*w1);
    y2=(T_mat*w2+b2*ones(tst_num,1))/sqrt(w2'*K3*w2);
end
predict_Y=sign(abs(y2)-abs(y1));

match = 0.;
match1=0;

posval=0;
negval=0;
for i = 1:tst_num
    if(test_label(i)==1)
        if(predict_Y(i) == test_label(i))
            match = match+1;
        end
        posval=posval+1;
    elseif(test_label(i)==-1)
        if(predict_Y(i) ~= test_label(i))
            match1 = match1+1;
        end
        negval=negval+1;
    end
end
if(posval~=0)
    a_pos=(match/posval);
else
    a_pos=0;
end

if(negval~=0)
    am_neg=(match1/negval);
else
    am_neg=0;
end
AUC=(1+a_pos-am_neg)/2;
auc=AUC*100;
end
