        clc;
        clear all;
        r=1;%������ֵΪ1
        s=999;%������ֵΪ0
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
        %x=[1 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0];%����������
       
        x8=reshape(x,8,length(x)/8);%���Ķ�
        x8_t=x8';%���Ķ�
        xsym=bi2de(x8_t)';%���Ķ�
       
       
        n=36; k=16;                     
        m=8;                             
        msg  = gf(xsym,m);   
        code = rsenc(msg,n,k);
       

        for i=1:1:288
            rand_num=binornd(1,p,1,1);% p����1���ֵĸ���
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
        error_8_t=error_8';%���Ķ�
        errorsym=bi2de(error_8_t)';%���Ķ�
        errors = gf(errorsym,m);
       
        codeNoi = code + errors;
        trans=de2bi(codeNoi.x);
        trans_hold=trans';
        trans_hold2=reshape(trans_hold,1,288);
        %ss= pskmod(whj_hold2,2);  % ����
        %mm=randn(1,288);%��������ŵ�����
        %tt=randn(1,288); 
        %hh=(m+j*t)/sqrt(2);%����Ϊ1
        %yy=ss.*hh;%���������ŵ�
        %r1=real(y./h);%ȡʵ��
        %r2 = pskdemod(r1,2); % ���
        for i=1:1:288
            aa=double(trans_hold2(i));
            ss(i)=(-1*exp(1i*pi*aa));  %BPSK�����ź� (1)--(1),(0)--(-1)
        end
       
        signal=awgn(ss,Eb_N,'measured');

        %  �о�����ź�
        signal((real(signal)>0))=1;
        signal((real(signal)<0))=-1;

        xx=(signal+1)/2;  % ����ź�

        err_num=length(find(xx~= trans_hold2));
        ber_simulate=err_num/288  ;
       
        trans_8=reshape(xx,8,length(xx)/8);
        trans_8_t=trans_8';%���Ķ�
        transsym=bi2de(trans_8_t)';%���Ķ�
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

