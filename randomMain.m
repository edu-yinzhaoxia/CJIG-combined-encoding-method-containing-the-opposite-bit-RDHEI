clear
clc
%% 运行测试样例
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Tiffany.tiff');
I = imread('测试图像\Lena.tiff');
%I = imread('测试图像\Man.tiff');
%I = imread('测试图像\Baboon.tiff');
%I = imread('测试图像\Jetplane.tiff');
origin_I = double(I); 


[row,col] = size(origin_I); %计算origin_I的行列值
num = ceil(log2(row))+ceil(log2(col))+3; %记录净压缩空间大小需要的比特数（+3代表最大嵌入率不超过8bpp）
%% 产生二进制秘密数据
rand('seed',1); %设置种子
E = round(rand(row,col)*1); %生成大小为row*col的伪随机数矩阵
rand('seed',2589); %设置种子
E1 = round(rand(row,col)*1); %生成大小为row*col的伪随机数矩阵
%% 设置参数
Block_size = 4; %分块大小（存储分块大小的比特数需要调整，目前设为4bits）
L_fix = 3; %定长编码参数
L = 4; %相同比特流长度参数,方便修改
%% 计算原始图像origin_I的预测误差图像
[PE_I,num_Of,Overflow] = Prediction_Error(origin_I);
CanCompressNum=0;
RandCompressNum=0;
ContCompressNUm = 0;
% for pl=3:-1:1 %MSB→LSB
%     %% ----------------------提取第pl个位平面----------------------%
%     [Plane] = BitPlanes_Extract(PE_I,pl);
%     randomXOR_I = Plane;
%     for i=1:row  %根据伪随机数矩阵E对图像vacate_I进行bit级加密
%         for j=1:col
%             randomXOR_I(i,j) = bitxor(Plane(i,j),E(i,j));
%         end
%     end
%     %% ----------------------压缩第pl个位平面----------------------%
%     [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix,L);
%     %% -------------------记录最终的位平面比特流--------------------%
%     len_CBS = length(CBS); %压缩位平面比特流的长度
%     len_comp_PL = len_CBS+num+2+1; %压缩位平面的最终长度（+num:压缩比特流长度信息，+2:位平面重排列方式，+1：压缩标记）
%     if len_comp_PL <= row*col 
%         CanCompressNum=CanCompressNum+1;
%     else
%          [RCBS,type] = BitPlanes_Compress(randomXOR_I,Block_size,L_fix,L);
%          len_RCBS = length(RCBS); %压缩位平面比特流的长度
%          len_comp_RPL = len_RCBS+num+2+1; %压缩位平面的最终长度（+num:压缩比特流长度信息，+2:位平面重排列方式，+1：压缩标记）
%          if len_comp_RPL<=row*col
%              RandCompressNum=RandCompressNum+1;
%          else
%              ContCompressNUm=ContCompressNUm+1;
%          end
%     end 
% end

randomXOR_I = E;
 for i=1:row  %根据伪随机数矩阵E对图像vacate_I进行bit级加密
    for j=1:col
        randomXOR_I(i,j) = bitxor(E1(i,j),E(i,j));
    end
end
[RCBS,type] = BitPlanes_Compress(randomXOR_I,Block_size,L_fix,L);
len_RCBS = length(RCBS); %压缩位平面比特流的长度
len_comp_RPL = len_RCBS+num+2+1; %压缩位平面的最终长度（+num:压缩比特流长度信息，+2:位平面重排列方式，+1：压缩标记）
