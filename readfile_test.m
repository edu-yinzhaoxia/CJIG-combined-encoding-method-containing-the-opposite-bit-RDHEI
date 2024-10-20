clear
clc
I_file_path='BOSSbase_1.01\';
%测试图像数据集文件夹路径
I_path_list=dir(strcat(I_file_path,'*.pgm'));
%获取该文件夹中所有pmg格式的图像
img_num=length(I_path_list);
%获取图像总数量
for i=1:img_num
    I_name=I_path_list(i).name;%图像名
    I=imread(strcat(I_file_path,I_name));%读取图像
end