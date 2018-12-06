% % 
% 该程序实现（2,1,3）卷积编码，抽头系数的八进制表示为【5,7】，代表的生成多项式为1+x^2,1+x+x^2
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear all;
clc;

% parameter
constraint_length=3;% Constraint length 
m=constraint_length-1;% Register lengrh
cn_1=[1 0 1];% Generation polynomial[5,7]
cn_2=[1 1 1];

an=zeros(1,m);% Register initialization
data=randint(1,128,2);
%data=[data 0 0];

for ii=1:length(data)   
    inter_var=[data(ii) an];
    first_out(ii)=mod(sum(cn_1.*inter_var),2);
    second_out(ii)=mod(sum(cn_2.*inter_var),2);
    an=inter_var(1:end-1);
    output(ii*2-1:ii*2)=[first_out(ii) second_out(ii)];
end
       r=10;%噪声的值为1
       s=990;%噪声的值为0
       delt=100;
       p=r/(r+s);

for ii=1:1:40

       for i=1:1:256
           rand_num=binornd(1,p,1,1);% p代表1出现的概
           if(rand_num==0)
               s=s+delt;
           end         
           if(rand_num==1)
               r=r+delt;
           end
       rand_sequence(i)=rand_num;
       p=r/(r+s);
       end
       data_channel=bitxor(output,rand_sequence);      

       ss=(-1*exp(1i*pi*data_channel));  %BPSK调制信号 (1)--(1),(0)--(-1)
 
        Eb_N=2;

        signal=awgn(ss,Eb_N,'measured');

        %  判决检测信号
        signal((real(signal)>0))=1;
        signal((real(signal)<0))=-1;

        xx=(signal+1)/2;  % 解调信号
    c=func_conv_dec_213_hard(xx);
    b=bitxor(c,data);
    e=find(b==1);
    bb(ii)=length(e)/128;
    if(bb(ii)>0.5)
        bb(ii)=1-bb(ii);
    end
end
mean(bb)