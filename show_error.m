function   show_error(position,RT,point_w,point_c)
           
u0=position(1);v0=position(2);fx=position(3);fy=position(4);               
k1=position(5);k2=position(6);p1=position(7);p2=position(8);k3=position(9);
  
Camera_parameters=[fx,0,u0;
                   0,fy,v0;
                   0, 0,1];
               
point_s=zeros(size(point_w,1),2);

for i=1:size(point_w)
    
    x=point_w(i,1);
    y=point_w(i,2);
    z=0;
    
    point_t=Camera_parameters*RT*[x;y;1];
    x=point_t(1,1)/point_t(3,1);
    y=point_t(2,1)/point_t(3,1);
    
    x_t=(x-u0)/fx;
    y_t=(y-v0)/fy;
    
    r2=x_t*x_t+y_t*y_t;
    
    x_d=x_t*(1+k1*r2+k2*r2^2+k3*r2^3)+2*p1*x_t*y_t+p2*(r2+2*x_t^2);
    y_d=y_t*(1+k1*r2+k2*r2^2+k3*r2^3)+2*p2*x_t*y_t+p1*(r2+2*y_t^2);
    
    x=x_d*fx+u0;
    y=y_d*fy+v0;
    point_s(i,1)=x;
    point_s(i,2)=y;
  
end
    figure (3)
    plot(point_c(:,1), point_c(:,2), 'o', 'Color', 'b','MarkerSize', 8); % 绘制检测到的点
    hold on
    
    plot(point_s(:,1), point_s(:,2), '+', 'Color', 'r','MarkerSize', 9); % 绘制检测到的点
    hold on
     
    rectangle('Position', [0,0, 1280, 1024]);
    hold on
    quiver(point_c(:,1), point_c(:,2),(point_s(:,1)-point_c(:,1)), (point_s(:,2)-point_c(:,2)),'MaxHeadSize', 1, 'AutoScaleFactor', 0.5, 'Color', 'b');
    hold on
    
    ylabel('y(pixel)','FontSize', 20);
    xlabel('x(pixel)','FontSize', 20);
    
    ax = gca;
    ax.Color=[1 1 1];
    ax.Box = 'off';
    
    ax.FontSize=14;
    
    set(gcf, 'Color', [1 1 1]);%设置窗口背景颜色
    
    
end