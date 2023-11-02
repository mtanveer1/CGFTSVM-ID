close all;clear all;clc;

Training_data=load("train.txt");
testing_data=load("test.txt");


FunPara.c_1=0.01;
FunPara.c_2=1;
FunPara.kerfpara.pars=4;
FunPara.a=0.625;
FunPara.Omega=0.5;
FunPara.kerfpara.type='rbf';
[ auc]=CGFTSVM_ID_func(testing_data,Training_data,FunPara);


display(auc)