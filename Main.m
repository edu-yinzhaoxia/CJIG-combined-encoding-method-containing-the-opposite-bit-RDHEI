clear
clc
%% 运行测试样例
t1 = now;
%I = imread('测试图像\Airplane.tiff');
%I = imread('测试图像\Tiffany.tiff');
I = imread('测试图像\Lena.tiff');
%I = imread('测试图像\Man.tiff');
%I = imread('测试图像\Baboon.tiff');
%I = imread('测试图像\Jetplane.tiff');

%% 读取测试数据集方法（本程序中不运行）
%I_file_path='BOSSbase_1.01\';
%I_file_path='BOWS2OrigEp3\';
%测试图像数据集文件夹路径
%I_path_list=dir(strcat(I_file_path,'*.pgm'));
%获取该文件夹中所有pmg格式的图像
%img_num=length(I_path_list);
%获取图像总数量
% for i=1:img_num
%     I_name=I_path_list(i).name;%图像名
%     I=imread(strcat(I_file_path,I_name));%读取图像
% end

origin_I = double(I); 
Rot_type = [0,1,2,3];%设置四种旋转角度，分别是0，90，180，270；
%RotOrg_I = [origin_I,rot90(origin_I),rot90(origin_I,2),rot90(origin_I,2)];
%% 产生二进制秘密数据
num_D = 3000000;
rand('seed',0); %设置种子               
D = round(rand(1,num_D)*1); %产生稳定随机数
%% 设置密钥
K_en = 1; %图像加密密钥
K_sh = 2; %图像混洗密钥
K_hide=3; %数据嵌入密钥
%% 设置参数
Block_size = 4; %分块大小（存储分块大小的比特数需要调整，目前设为4bits）
L_fix = 3; %定长编码参数
L = 4; %相同比特流长度参数,方便修改
%% 空出图像空间并加密混洗图像（内容所有者）
nRotType = 1;
[ES_I1,onlyES_I1,num_Of1,PL_len1,PL_room1,total_Room1] = Vacate_Encrypt(origin_I,Rot_type(1),Block_size,L_fix,L,K_en,K_sh);
ES_I = ES_I1; onlyES_I=onlyES_I1; num_Of = num_Of1; PL_len = PL_len1; PL_room = PL_room1; total_Room = total_Room1;
for i=2:4
    [ES_Ii,onlyES_Ii,num_Ofi,PL_leni,PL_roomi,total_Roomi] = Vacate_Encrypt(rot90(origin_I,i-1),Rot_type(i),Block_size,L_fix,L,K_en,K_sh);
    if total_Roomi>total_Room
        ES_I = ES_Ii; onlyES_I=onlyES_Ii; num_Of = num_Ofi; PL_len = PL_leni; PL_room = PL_roomi; total_Room = total_Roomi;
        nRotType = i;
    end
end
%% 净载荷空间大于num的情况下才进行数据嵌入（代表有压缩空间）
[row,col] = size(origin_I); %计算origin_I的行列值
num = ceil(log2(row))+ceil(log2(col))+2; %记录净压缩空间大小需要的比特数
if total_Room>=num %需要num比特记录净压缩空间大小
    %% 在加密混洗图像中嵌入数据（数据嵌入者）
    [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D); 
    num_emD = length(emD);
    %% 在载密图像中提取秘密信息（接收者）
    [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
    %% 恢复载密图像（接收者）
    [recover_I] = Image_Recover(stego_I,K_en,K_sh);
    %% 图像对比
    t2 = now;
    t3 = t2 - t1;
    figure(1);
    H=GetHis(origin_I);
    plot(0:255,H);
    area(0:255,H,'FaceColor','b')
    figure(2);
    H=GetHis(ES_I);
    plot(0:255,H);
    area(0:255,H,'FaceColor','b')
    figure(3);
    H=GetHis(stego_I);
    plot(0:255,H);
    area(0:255,H,'FaceColor','b')
    figure(4);
    set(gcf, 'Position', [100, 100, 900, 170]); % 设置图形窗口位置和大小，使其更宽
    subplot(131);H_Org=GetHis(origin_I); plot(0:255,H_Org);title('原始图像');area(0:255,H_Org,'FaceColor','b');xlim([0 255]); % 设置x轴的范围为0到255
    subplot(132);H_OnlyES=GetHis(onlyES_I); plot(0:255,H_OnlyES);title('加密图像');area(0:255,H_OnlyES,'FaceColor','b');xlim([0 255]); ylim([0 1200]);
    %subplot(143);H_ES=GetHis(ES_I); plot(0:255,H_ES);title('混洗图像');area(0:255,H_ES,'FaceColor','b');xlim([0 255]); ylim([0 1200]);
    subplot(133);H_Strgo=GetHis(stego_I); plot(0:255,H_Strgo);title('载密图像');area(0:255,H_Strgo,'FaceColor','b');xlim([0 255]); ylim([0 1200]);
    figure(5);
    subplot(151);imshow(origin_I,[]);title('原始图像');xlabel('a','FontSize',14,'FontName','Times New Roman');
    subplot(152);imshow(onlyES_I,[]);title('加密图像');xlabel('b','FontSize',14,'FontName','Times New Roman');
    subplot(153);imshow(ES_I,[]);title('混洗图像');xlabel('c','FontSize',14,'FontName','Times New Roman');
    subplot(154);imshow(stego_I,[]);title('载密图像');xlabel('d','FontSize',14,'FontName','Times New Roman');
    subplot(155);imshow(recover_I,[]);title('恢复图像');xlabel('e','FontSize',14,'FontName','Times New Roman');
    figure(6);
    imshow(origin_I,[]);%title('原始图像');
    figure(7);
    imshow(onlyES_I,[]);%title('加密图像');
    figure(8);
    imshow(ES_I,[]);%title('混洗图像');
    figure(9);
    imshow(stego_I,[]);%title('载密图像');
    figure(10);
    imshow(recover_I,[]);%title('恢复图像');
    %% 计算信息熵
    % 计算原始图像的信息熵
    entropy_origin = calculateEntropy(origin_I);
    fprintf('原始图像的信息熵: %f\n', entropy_origin);

    % 计算仅加密图像的信息熵
    entropy_OnlyES = calculateEntropy(onlyES_I);
    fprintf('加密图像的信息熵: %f\n', entropy_OnlyES);
    
    % 计算混洗图像的信息熵
    entropy_ES = calculateEntropy(ES_I);
    fprintf('混洗图像的信息熵: %f\n', entropy_ES);

    % 计算载密图像的信息熵
    entropy_Stego = calculateEntropy(stego_I);
    fprintf('载密图像的信息熵: %f\n', entropy_Stego);
    %% 计算图像嵌入率
    [m,n] = size(origin_I);
    bpp = num_emD/(m*n);
    %% 结果判断
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
    if check1 == 1
        disp('提取数据与嵌入数据完全相同！')
    else
        disp('Warning！数据提取错误！')
    end
    if check2 == 1
        disp('重构图像与原始图像完全相同！')
    else
        disp('Warning！图像重构错误！')
    end
    %---------------结果输出----------------%
    if check1 == 1 && check2 == 1
        disp(['Embedding capacity equal to : ' num2str(num_emD) ' bits'] )
        disp(['Embedding rate equal to : ' num2str(bpp) ' bpp'])
        fprintf(['该测试图像------------ OK','\n\n']);
    else
        fprintf(['该测试图像------------ ERROR','\n\n']);
    end  
else %该图像太复杂，溢出预测误差太多，导致辅助信息大于压缩空间
    disp('辅助信息大于压缩空间，导致无法存储数据！') 
    fprintf(['该测试图像------------ ERROR','\n\n']);
end
