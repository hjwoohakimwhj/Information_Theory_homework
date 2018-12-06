        clc;
        clear all;
        r=1;%噪声的值为1
        s=999;%噪声的值为0
        delt=100;
        p=r/(r+s);
for ii=1:1:40
        
        Eb_N=2;
        x=randint(128,1);
        %[b1 b2]=size(x); 
        %for i=1:b1  
        %   for j=1:b2  
        %      fprintf(fid,'%d',x(i,j));  
        %end  
        %fprintf(fid,'\n\n');
        %end  
        %x=[1 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0];%比特流序列
       
        x8=reshape(x,8,length(x)/8);%不改动
        x8_t=x8';%不改动
        xsym=bi2de(x8_t)';%不改动
       
       
        n=36; k=16;                     
        m=8;                             
        msg  = gf(xsym,m);   
        code = rsenc(msg,n,k);
       

        for i=1:1:288
            rand_num=binornd(1,p,1,1);% p代表1出现的概率
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
        bb=length(e);
        error_8=reshape(rand_sequence,8,length(rand_sequence)/8);
        error_8_t=error_8';%不改动
        errorsym=bi2de(error_8_t)';%不改动
        errors = gf(errorsym,m);
       
        codeNoi = code + errors;
        trans=de2bi(codeNoi.x);
        trans_hold=trans';
        trans_hold2=reshape(trans_hold,1,288);
        %ss= pskmod(whj_hold2,2);  % 调制
        %mm=randn(1,288);%获得瑞利信道函数
        %tt=randn(1,288); 
        %hh=(m+j*t)/sqrt(2);%能量为1
        %yy=ss.*hh;%经过瑞利信道
        %r1=real(y./h);%取实部
        %r2 = pskdemod(r1,2); % 解调
        for i=1:1:288
            aa=double(trans_hold2(i));
            ss(i)=(-1*exp(1i*pi*aa));  %BPSK调制信号 (1)--(1),(0)--(-1)
        end
       
        signal=awgn(ss,Eb_N,'measured');

        %  判决检测信号
        signal((real(signal)>0))=1;
        signal((real(signal)<0))=-1;

        xx=(signal+1)/2;  % 解调信号

        err_num=length(find(xx~= trans_hold2));
        ber_simulate=err_num/288  ;
       
        trans_8=reshape(xx,8,length(xx)/8);
        trans_8_t=trans_8';%不改动
        transsym=bi2de(trans_8_t)';%不改动
        transs = gf(transsym,m);
   
   
        %codeNoi=code;
        [dec,cnumerr] = rsdec(transs,n,k); % Decoding failure : cnumerr(3) is -1
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
        bit_error(ii)=b/128;
end
        mean(bit_error)     

