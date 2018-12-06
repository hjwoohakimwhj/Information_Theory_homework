% % 
% �ó���ʵ�֣�2,1,3��������룬��ͷϵ���İ˽��Ʊ�ʾΪ��5,7������������ɶ���ʽΪ1+x^2,1+x+x^2
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
       r=10;%������ֵΪ1
       s=990;%������ֵΪ0
       delt=100;
       p=r/(r+s);

for ii=1:1:40

       for i=1:1:256
           rand_num=binornd(1,p,1,1);% p����1���ֵĸ�
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

       ss=(-1*exp(1i*pi*data_channel));  %BPSK�����ź� (1)--(1),(0)--(-1)
 
        Eb_N=2;

        signal=awgn(ss,Eb_N,'measured');

        %  �о�����ź�
        signal((real(signal)>0))=1;
        signal((real(signal)<0))=-1;

        xx=(signal+1)/2;  % ����ź�
    c=func_conv_dec_213_hard(xx);
    b=bitxor(c,data);
    e=find(b==1);
    bb(ii)=length(e)/128;
    if(bb(ii)>0.5)
        bb(ii)=1-bb(ii);
    end
end
mean(bb)