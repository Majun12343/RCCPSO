function [R,T,point_w,point_c]=read(R_addrt,T_addrt,point_w_addrt,point_c_addrt)

format longG;
% 打开文本文件进行读取
fid_R = fopen(R_addrt, 'r');
R_arry = {};
    
fid_T = fopen(T_addrt, 'r');
T_arry = {};

fid_point_w = fopen(point_w_addrt, 'r');
point_w_arry = {};

fid_point_c = fopen(point_c_addrt, 'r');
point_c_arry = {};


% 读取R矩阵
k=1;
j=1;
tline = fgetl(fid_R);% 逐行读取文件内容
while ischar(tline)
   
    if startsWith(tline, '************') % 判断是否为起始符号"*"
        tline = fgetl(fid_R);
        pp = [];  % 新建一个临时的段落
      while ~startsWith(tline, '############') % 逐行读取直到结束符号"#"
           [num1] = sscanf(tline, '%f');
            pp(k,1)=num1;
            k=k+1;
            tline = fgetl(fid_R);
      end
        k=1;
        R_arry{j}=pp;
        j=j+1;
        pp = [];  %将数据清空
    end
    tline = fgetl(fid_R);
end

fclose(fid_R);

k=1;
j=1;
tline = fgetl(fid_T);
while ischar(tline)
   
    if startsWith(tline, '************') 
        tline = fgetl(fid_T);
        pp = []; 
      while ~startsWith(tline, '############') 
           [num1] = sscanf(tline, '%f');
            pp(k,1)=num1;
            k=k+1;
            tline = fgetl(fid_T);
      end
        k=1;
        T_arry{j}=pp;
        j=j+1;
        pp = []; 
    end
    tline = fgetl(fid_T);
end

fclose(fid_T);


k=1;
j=1;
tline = fgetl(fid_point_w);
while ischar(tline)
   
    if startsWith(tline, '************') 
        tline = fgetl(fid_point_w);
        pp = [];  
      while ~startsWith(tline, '############') 
           [num1] = sscanf(tline, '%f %f');
            pp(k,1)=num1(1,1);
            pp(k,2)=num1(2,1);
            k=k+1;
            tline = fgetl(fid_point_w);
      end
        k=1;
        point_w_arry{j}=pp;
        j=j+1;
        pp = [];  
    end
    tline = fgetl(fid_point_w);
end

fclose(fid_point_w);

k=1;
j=1;
tline = fgetl(fid_point_c);
while ischar(tline)
   
    if startsWith(tline, '************') 
        tline = fgetl(fid_point_c);
        pp = [];  
      while ~startsWith(tline, '############') 
           [num1] = sscanf(tline, '%f %f');
            pp(k,1)=num1(1,1);
            pp(k,2)=num1(2,1);
            k=k+1;
            tline = fgetl(fid_point_c);
      end
        k=1;
        point_c_arry{j}=pp;
        j=j+1;
        pp = [];  
    end
    tline = fgetl(fid_point_c);
end

fclose(fid_point_c);

R=R_arry;
T=T_arry;
point_w=point_w_arry;
point_c=point_c_arry;

disp(['读取到R矩阵 ', num2str(size(R_arry,2))])
disp(['读取到T矩阵 ', num2str(size(T_arry,2))])
disp(['读取到point_w矩阵 ', num2str(size(point_w_arry,2))])
disp(['读取到point_c矩阵 ', num2str(size(point_c_arry,2))])

end
