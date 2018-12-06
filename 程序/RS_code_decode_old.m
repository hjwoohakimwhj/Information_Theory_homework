       clc;
       clear all;
       fid=fopen('C:\Users\Administrator\Desktop\new.txt','w');  
       r=100;%噪声的值为1
       s=900;%噪声的值为0
       delt=100;
       p=r/(r+s);
for ii=1:1:10
    x=randint(128,1);
    %[b1 b2]=size(x); 
    %for i=1:b1  
     %   for j=1:b2  
      %      fprintf(fid,'%d',x(i,j));  
       % end  
    %fprintf(fid,'\n\n');
    %end  
       %x=[1 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0];%比特流序列
       
       x8=reshape(x,8,length(x)/8);%不改动
       x8_t=x8';%不改动
       xsym=bi2de(x8_t)';%不改动
       
       
       n=36; k=16;                        % Codeword and message word lengths
       m=8;                             % Number of bits per symbol
       msg  = gf(xsym,m);   % Two k-symbol message words
       code = rsenc(msg,n,k);
       

       for i=1:1:288
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
       %rand_sequence=[0 1 1 0 1 0 1 0 1 1 0 1 1 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 1 0 0 1 0 0 0 0 0 1 0 0 0 1 1 1 0 0 0 1 0 1 0 1 0 0 0 1 1 0 1 1 1 0 0 0 0 1 0 1 0 0 0 0 1 0 1 1 1 0 0 0 1 1 0 1 1 1 1 0 0 0 0 0 1 0 0 1 0 0 1 1 0 0 0 0 1 1 1 0 1 0 0 1 0 1 1 1 0 0 0 0 0 0 1 1 0 0 1 1 1 1 0 0 1 0 0 1 0 0 1 1 0 0 1 0 0 0 0 1 1 0 0 1 0 1 0 1 1 0 0 1 0 0 0 1 0 1 1 0 0 0 0 1 1 1 1 1 0 0 1 0 1 1 1 0 1 1 1 0 0 1 1 1 1 1 1 1 1 0 1 0 0 1 1 1 1 0 1 0 0 1 1 0 0 0 0 1 1 0 1 0 1 0 1 0 0 0 0 0 1 1 1 1 0 1 0 0 1 0 0 1 0 0 0 0 1 1 0 1 0 0 0 1 0 1 1 0 1 1 1 1 0 1 0 1 0 1 0 1 0 1 1 0 1 1 1 0 0 0 0 1 1 0 0 1 0 1 0 ]
       e=find(rand_sequence==1);
       bb(ii)=length(e);
       error_8=reshape(rand_sequence,8,length(rand_sequence)/8);
       error_8_t=error_8';%不改动
       errorsym=bi2de(error_8_t)';%不改动
       errors = gf(errorsym,m);
       
       codeNoi = code + errors;
       
       
       %s= pskmod(codeNoi,2);  % 调制
       %m=randn(1,288);%获得瑞利信道函数
       %t=randn(1,288); 
       %h=(m+j*t)/sqrt(2);%能量为1
       %y=s.*h;%经过瑞利信道
       %r1=real(y./h);%取实部
       %r2 = pskdemod(r1,2); % 解调
       
       
       %codeNoi=code;
       [dec,cnumerr] = rsdec(codeNoi,n,k); % Decoding failure : cnumerr(3) is -1
       xsym2=double(dec.x);
       %for i =1:1:16
        %   xsym(i)
         %  xsym2(i)
      % end
       c=bitxor(xsym,xsym2);
       b=0;
       for i=1:1:16
           if(c(i) ~= 0)
               h=de2bi(c(i));
               e=find(h==1);
               b=b+length(e);
           end
       end
       bit_error(ii)=b/128
       if(bit_error(ii)>0.0 && bit_error(ii)<0.01)
           b
           [b1 b2]=size(rand_sequence); 
           for i=1:b1  
               for j=1:b2  
                   fprintf(fid,'%d ',rand_sequence(i,j));  
               end
               fprintf(fid,'\n\n');
           end
       end
end 
       fclose(fid);
mean(bit_error(1:10))