    set(gca,'FontName','Times New Roman','FontSize',15);  
    set(gcf,'color','w');
   
    x=[0.0010 	0.0040 	0.0100 	0.0400 	0.0800 	0.1000 	0.2000 ];
    y1=[0.0082	0.0146	0.0152	0.0473	0.1549	0.2301	0.3504 ];
    y2=[0.0098	0.0143	0.0192	0.0416	0.1385	0.2203	0.3795 ];
    t1=semilogx(x,y1);
    set(t1,'color','b','linewidth',2);
    hold on
    t2=semilogx(x,y2);
    set(t2,'color','r','linewidth',2);
    %set(y1,'color','b','linewidth',2.5);
    %plot(x,y1,'linewidth',2);
    xlabel('Channel bit error rate','Color','black','FontSize',15);
    ylabel('Post decryption bit error rate','Color','black','FontSize',15);
    grid off
    %grid on
    legend('HD cipher','AES+[36,16,246]RS codes');