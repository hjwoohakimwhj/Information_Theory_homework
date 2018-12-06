    set(gca,'FontName','Times New Roman','FontSize',15);  
    set(gcf,'color','w');
   
    x=[0.0010 	0.0040 	0.0100 	0.0400 	0.0800 	0.1000 	0.2000 ];
    y1=[0.0082	0.0146	0.0152	0.0473	0.1549	0.2301	0.3504 ];
    y2=[0.0201 	0.0342 	0.1352 	0.1924 	0.3951 	0.4191 	0.4539 ];
    y3=[0.0014 	0.0250 	0.0932 	0.1936 	0.3324 	0.3789 	0.4414 ];
    y4=[0.0018 	0.0443 	0.0576 	0.1762 	0.2840 	0.3357 	0.4338 ];
    y5=[0.0003 	0.0281 	0.0365 	0.1654 	0.2266 	0.3346 	0.4361 ];
    y6=[0.0005 	0.0113 	0.0244 	0.0705 	0.1805 	0.3092 	0.4375 ];
    t1=semilogx(x,y1);
    set(t1,'color','b','linewidth',2);
    hold on
    t2=semilogx(x,y2);
    set(t2,'color','r','linewidth',2);
    hold on
    t3=semilogx(x,y3);
    set(t3,'color','r','linewidth',2);
    hold on
    t4=semilogx(x,y4);
    set(t4,'color','r','linewidth',2);
    hold on
    t5=semilogx(x,y5);
    set(t5,'color','r','linewidth',2);
    hold on
    t6=semilogx(x,y6);
    set(t6,'color','r','linewidth',2);
    %set(y1,'color','b','linewidth',2.5);
    %plot(x,y1,'linewidth',2);
    xlabel('Channel bit error rate','Color','black','FontSize',15);
    ylabel('Post decryption bit error rate','Color','black','FontSize',15);
    grid off
    %grid on
    legend('HD cipher','AES+convenc(1/2)','AES+convenc(1/3)','AES+convenc(1/4)','AES+convenc(1/5)','AES+convenc(1/6)');