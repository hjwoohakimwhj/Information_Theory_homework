% % 
% 该程序实现（3,1,2）卷积编码，抽头系数的八进制表示为，代表的生成多项式为
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

clear all;
clc;


input=randint(1,128,2);
g=[1 0 0;1 1 0;1 0 1];
%data=[data 0 0];
out=cnv_encd(g,1,input);

       r=1;%噪声的值为1
       s=999;%噪声的值为0
       delt=100;
       p=r/(r+s);

for ii=1:1:40

       for i=1:1:length(out)
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
       data_channel=bitxor(out,rand_sequence);      

       ss=(-1*exp(1i*pi*data_channel));  %BPSK调制信号 (1)--(1),(0)--(-1)
 
        Eb_N=2;

        signal=awgn(ss,Eb_N,'measured');

        %  判决检测信号
        signal((real(signal)>0))=1;
        signal((real(signal)<0))=-1;

        xx=(signal+1)/2;  % 解调信号
    c=viterbi(g,1,xx);
    b=bitxor(c,input);
    e=find(b==1);
    bb(ii)=length(e)/128;
    if(bb(ii)>0.5)
        bb(ii)=1-bb(ii);
    end
end
mean(bb)
