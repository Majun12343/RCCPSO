function   [error_array]=feedback(position_array,RT,point_w,point_c)
           
%error_array=zeros(size(position_array,1),1);

for i=1:size(position_array,1)
    
   error_array(i,1)=error(position_array(i,:),RT,point_w,point_c);
   
end


end

function   [error]=error(position,RT,point_w,point_c)

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
error=0;
error_and=0;
for i=1:size(point_c)
    
    error=sqrt((point_s(i,1)-point_c(i,1))*(point_s(i,1)-point_c(i,1))+(point_s(i,2)-point_c(i,2))*(point_s(i,2)-point_c(i,2)));
    error_and=error+error_and;
end
error=error_and/size(point_c,1);

end
