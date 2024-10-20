clear
clc
%% 读取数据
load('num_BOWS2OrigEp3.mat'); %读取数据,嵌入容量
load('bpp_BOWS2OrigEp3.mat'); %读取数据,嵌入率
load('len_BOWS2OrigEp3.mat'); %读取数据,位平面压缩长度
load('room_BOWS2OrigEp3.mat');%读取数据,位平面压缩空间
load('over_BOWS2OrigEp3.mat');%读取数据,图像溢出像素个数
%% 统计图像数据集的平均嵌入率和错误图像ID以及最大嵌入率和最小嵌入率
len = length(num_BOWS2OrigEp3); %数据集图像个数
error_Data = 0;
error_Data_Image = zeros(); %存储辅助信息大于总嵌入量的图像ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %存储提取数据或恢复图像不正确的图像ID
total_True = 0;%统计正确提取恢复图像的数目
total_bpp = 0; %计数，统计正确图像的总嵌入率
Best_Image_bpp = 0;%记录数据集中的最大嵌入率
Best_Image_id = 0; %记录图像ID
Worst_Image_bpp = 8;%记录数据集中的最小嵌入率
Worst_Image_id = 0; %记录图像ID
for i=1:len
    if num_BOWS2OrigEp3(i)==-1 && bpp_BOWS2OrigEp3(i)==0 %辅助信息大于总嵌入量，不能嵌入数据
        error_Data = error_Data + 1;
        error_Data_Image(error_Data) = i;
    elseif bpp_BOWS2OrigEp3(i)==-1 || bpp_BOWS2OrigEp3(i)==-2 || bpp_BOWS2OrigEp3(i)==-3
        error_NoRe = error_NoRe + 1;
        error_NoRe_Image(error_NoRe) = i;    
    else
        total_True = total_True + 1;
        total_bpp = total_bpp + bpp_BOWS2OrigEp3(i);
        if bpp_BOWS2OrigEp3(i) > Best_Image_bpp
            Best_Image_bpp = bpp_BOWS2OrigEp3(i);
            Best_Image_id = i;
        end
        if bpp_BOWS2OrigEp3(i) < Worst_Image_bpp
            Worst_Image_bpp = bpp_BOWS2OrigEp3(i);
            Worst_Image_id = i;
        end
    end
end
ave_bpp = total_bpp/total_True; %正确图像的平均嵌入率
fprintf(['正确图像的平均嵌入率为:',num2str(ave_bpp),'\n']);
fprintf(['图像的最优嵌入率为:',num2str(Best_Image_bpp),'||图像ID:',num2str(Best_Image_id),'\n']);
fprintf(['图像的最差嵌入率为:',num2str(Worst_Image_bpp),'||图像ID:',num2str(Worst_Image_id),'\n']);
%% 统计图像数据集中的最多溢出像素个数和最少溢出像素个数
Most_Over = 0; %记录数据集中的最多溢出像素个数
Most_Over_id = 0; %记录图像ID
Least_Over = Inf; %记录数据集中的最少溢出像素个数
Least_Over_id = 0; %记录图像ID
total_Over = 0;
for i=1:len
    total_Over = total_Over + over_BOWS2OrigEp3(i);
    if over_BOWS2OrigEp3(i) > Most_Over
        Most_Over = over_BOWS2OrigEp3(i);
        Most_Over_id = i;
    end
    if over_BOWS2OrigEp3(i) < Least_Over
        Least_Over = over_BOWS2OrigEp3(i);
        Least_Over_id = i;
    end
end
ave_Over = total_Over/len; %数据集的平均溢出像素个数
fprintf(['数据集的平均溢出预测误差像素个数为:',num2str(ave_Over),'\n']);
fprintf(['图像的最多溢出像素个数为:',num2str(Most_Over),'||图像ID:',num2str(Most_Over_id),'\n']);
fprintf(['图像的最少溢出像素个数为:',num2str(Least_Over),'||图像ID:',num2str(Least_Over_id),'\n']);
%% 统计数据集中每个位平面的压缩情况
Comp_BitPlane = zeros(1,8);
for i=1:len
    for j=1:8
        if room_BOWS2OrigEp3(j,i) ~= 0 %表示位平面有压缩空间，即可压缩
            Comp_BitPlane(j) = Comp_BitPlane(j)+1;
        end
    end
end
%% 统计数据集中每个位平面的平均压缩比
Comp_Ratio = zeros(1,8); %记录位平面的压缩比
for i=1:8
    total_comp_len = 0;
    num_len = 0;
    for j=1:len
        if len_BOWS2OrigEp3(i,j) ~= 0 % %表示位平面可压缩
            num_len = num_len+1; 
            total_comp_len = total_comp_len + len_BOWS2OrigEp3(i,j);
        end
    end
    Comp_Ratio(i) = (total_comp_len/num_len)/(512*512);
end
for i=1:8
    fprintf(['第',num2str(9-i),'位平面的压缩比为:',num2str(Comp_Ratio(i)),'\n']);
end
fprintf(['位平面的平均压缩比为:',num2str(sum(Comp_Ratio)/8),'\n']);
%% 统计位平面压缩平均长度、位平面平均比特（512*512）
lens_BOWS2OrigEp3 = len_BOWS2OrigEp3;
for i=1:8
    for j = 1:len
        if lens_BOWS2OrigEp3(i,j) == 0
            lens_BOWS2OrigEp3(i,j) = 262144;
        end
    end
end
Avg_len_BOWS2OrigEp3 = mean(lens_BOWS2OrigEp3,2);
Avg_over_BOWS2OrigEp3 = mean(over_BOWS2OrigEp3);
Avg_room_BOWS2OrigEp3 = mean(num_BOWS2OrigEp3);