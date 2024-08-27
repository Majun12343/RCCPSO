 

y_PSOPLUS=zeros(1,500);

format longG;
[R_arry,T_arry,point_w_arry,point_c_arry]=read("R.txt","T.txt","point_w.txt","point_c.txt");
num=1;
R=R_arry{num};
rotationMatrix = rotationVectorToMatrix(R);
R=rotationMatrix.';

T=T_arry{num};

point_w=point_w_arry{num};
point_c=point_c_arry{num};

RT=[R(1,1),R(1,2),T(1,1);
    R(2,1),R(2,2),T(2,1);
    R(3,1),R(3,2),T(3,1);];


Camera_parameters=[2483.8273508399061,0.0000000000000,664.7563927726678 ;
                   0.0000000000000,2483.7793829045386,469.7034647280543 ;
                   0.0000000000000,0.0000000000000,1.0000000000000 ];
               
u0=Camera_parameters(1,3);                
v0=Camera_parameters(2,3); 
fx=Camera_parameters(1,1);   
fy=Camera_parameters(2,2);   

dis=[-0.0848052231653 0.3123656894887 -0.0004205655654 0.0003456842622 1.3076489366998 ];
k1=dis(1);k2=dis(2);p1=dis(3);p2=dis(4);k3=dis(5);



position_init=[u0,v0,fx,fy,k1,k2,p1,p2,k3];


N = 150;                        
d = 9;                          
ger = 300; 

w = 0.8;                      
c1 = 0.6;                      
c2 = 0.1;                      

w_t = 0.5;                        
c1_t = 0.3;                       
c2_t = 0.6;                       


position_limit_max=[+50,+50,+300,+300,+0.1,+0.1,+0.1,+0.1,+10]; 
position_limit_min=position_limit_max*(-1);
position_limit_min=position_limit_min+position_init;
position_limit_max=position_limit_max+position_init;

position_limit_max=repmat(position_limit_max,N,1);
position_limit_min=repmat(position_limit_min,N,1);

vlimit_max=[1,1,5,5,0.01,0.01,0.01,0.01,0.01];
vlimit_max=vlimit_max*0.125*0.125*0.125;
vlimit_min=vlimit_max*(-1);

vlimit_max=repmat(vlimit_max,N,1);
vlimit_min=repmat(vlimit_min,N,1);

position = position_limit_min + (position_limit_max -  position_limit_min) .* rand(N, d);  
v = vlimit_min + (vlimit_max -  vlimit_min) .* rand(N, d);

position_one_good = position;                
position_our_good = zeros(1, d);             
suit_one_good = ones(N, 1)*inf;               
suit_our_good = inf;                      

suit=zeros(N, 1);

Rmax=0.8;
Rmin=0.4;

record=[];

x=zeros(1,ger);
y=zeros(1,ger);

iter = 1;  
suit_change=zeros(N,1);
change_flag=zeros(N,1);

while iter <= ger  
     
    T=round(N*Rmax-(N*Rmax-N*Rmin)*(iter/ger));
    
     suit_last=suit;
    
     suit = feedback(position,RT,point_w,point_c) ;  
     
     
     suit_change=abs(suit_last-suit);
     
     for i=1:N
         if suit_change(i)<0.05
            change_flag(i)=change_flag(i)+1;
         else
            change_flag(i)=0;
         end  
     end
     
     for i=1:N
         if change_flag(i)>7
             if i>T
                 stop=1;
                 suit_t=inf;
                 while suit_t>suit(i)&&stop<10
                     r3=rand;r4=(rand-0.5)*2;k = randi([1, T]);
                     position_t=r3*position_one_good(i,:)+(1-r3)*position_one_good(k,:)+r4*(position_one_good(i,:)-position_one_good(k,:));
                     suit_t=feedback(position_t,RT,point_w,point_c);
                     stop=stop+1;
                     
                     if(suit_t<suit(i))
                        position(i,:)=position_t;
                        
                         break;
                     end                  
                 end
             end
              if i<=T
                 stop=1;
                 suit_t=inf;
                 while suit_t>suit(i)&&stop<10
                     r3=rand;r4=(rand-0.5)*2;k = randi([T+1, N]);
                     position_t=r3*position_one_good(i,:)+(1-r3)*position_one_good(k,:)+r4*(position_one_good(i,:)-position_one_good(k,:));
                     suit_t=feedback(position_t,RT,point_w,point_c);
                     stop=stop+1;
                     
                     if(suit_t<suit(i))
                        position(i,:)=position_t;
                        
                         break;
                     end
                 end            
              end        
         end
     end
     
     
     [suit,order]=sort(suit);
     
     pp=zeros(N,1);  
     for i=1:N
       pp(i,1)=suit_one_good(order(i),1);     
     end
     suit_one_good=pp;
     
     pp=zeros(N,d);   
     for i=1:N
       pp(i,:)=position_one_good(order(i),1);     
     end
     position_one_good=pp;
     
     pp=zeros(N,1);
     for i=1:N
       pp(i,1)=change_flag(order(i),1);     
     end
     change_flag=pp;
     
     pp=zeros(N,d); 
     for i=1:N
       pp(i,:)=position(order(i),:);     
     end
     position=pp;
     
     
     for i=1:N
        if suit(i)<suit_one_good(i) 
            suit_one_good(i) = suit(i);     
            position_one_good(i,:) = position(i,:);   
        end
     end
     
    if   min(suit_one_good)<  suit_our_good
        [suit_our_good, nmin] = min(suit_one_good);   
        position_our_good = position_one_good(nmin, :);     
    end  
    
    W_and=0;
    Q=zeros(1,d);
    for i=1:T
        W(i)=1/(suit(i)+1);
        W_and=W_and+W(i);
    end
    for i=1:T
        Q_t=(W(i)*position_one_good(i,:))/W_and;
        Q=Q+Q_t;
    end
   

    v(1:T,:) = v(1:T,:) * w + c1 * rand * (position_one_good(1:T,:) - position(1:T,:)) + c2 * rand * (repmat(position_our_good, T, 1) - position(1:T,:)); 
    v(T+1:N,:) = v(T+1:N,:) * w_t + c1_t * rand * (repmat(Q,N-T,1) - position(T+1:N,:)) + c2_t * rand * (repmat(position_our_good, N-T, 1) - position(T+1:N,:));
    
  
    v(v > vlimit_max) = vlimit_max(v > vlimit_max);
    v(v < vlimit_min) = vlimit_min(v < vlimit_min);  
    position = position + v; 
    position(position >position_limit_max) = position_limit_max(position >position_limit_max);  
    position(position <position_limit_min) = position_limit_min(position <position_limit_min);  
    
    record(iter) = suit_our_good; 
  
    y_PSOPLUS(iter)=suit_our_good;
    
   
    plot(record);title('最优适应度进化过程');
    hold on 

    x(iter)=iter;
    y(iter)=suit_our_good;
    
    pause(0.001);
    iter = iter+1; 

end  

span  = 0.3; 
smoothedData = smooth(y,span,'loess');


figure (2);
plot(x, smoothedData, '-');
xlim([0 250]);
ylim([0 5]);

fig = figure (2);

width_p = 300; 
height_p = 600; 
set(fig, 'Position', [100, 100, width_p, height_p]);
hold on


show_error(position_our_good,RT,point_w,point_c);

disp(['最优值：',num2str(suit_our_good)]);  
disp(['变量取值：',num2str(suit_our_good)]);  
