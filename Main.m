clear
clc
%% ���в�������
t1 = now;
%I = imread('����ͼ��\Airplane.tiff');
%I = imread('����ͼ��\Tiffany.tiff');
I = imread('����ͼ��\Lena.tiff');
%I = imread('����ͼ��\Man.tiff');
%I = imread('����ͼ��\Baboon.tiff');
%I = imread('����ͼ��\Jetplane.tiff');

%% ��ȡ�������ݼ��������������в����У�
%I_file_path='BOSSbase_1.01\';
%I_file_path='BOWS2OrigEp3\';
%����ͼ�����ݼ��ļ���·��
%I_path_list=dir(strcat(I_file_path,'*.pgm'));
%��ȡ���ļ���������pmg��ʽ��ͼ��
%img_num=length(I_path_list);
%��ȡͼ��������
% for i=1:img_num
%     I_name=I_path_list(i).name;%ͼ����
%     I=imread(strcat(I_file_path,I_name));%��ȡͼ��
% end

origin_I = double(I); 
Rot_type = [0,1,2,3];%����������ת�Ƕȣ��ֱ���0��90��180��270��
%RotOrg_I = [origin_I,rot90(origin_I),rot90(origin_I,2),rot90(origin_I,2)];
%% ������������������
num_D = 3000000;
rand('seed',0); %��������               
D = round(rand(1,num_D)*1); %�����ȶ������
%% ������Կ
K_en = 1; %ͼ�������Կ
K_sh = 2; %ͼ���ϴ��Կ
K_hide=3; %����Ƕ����Կ
%% ���ò���
Block_size = 4; %�ֿ��С���洢�ֿ��С�ı�������Ҫ������Ŀǰ��Ϊ4bits��
L_fix = 3; %�����������
L = 4; %��ͬ���������Ȳ���,�����޸�
%% �ճ�ͼ��ռ䲢���ܻ�ϴͼ�����������ߣ�
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
%% ���غɿռ����num������²Ž�������Ƕ�루������ѹ���ռ䣩
[row,col] = size(origin_I); %����origin_I������ֵ
num = ceil(log2(row))+ceil(log2(col))+2; %��¼��ѹ���ռ��С��Ҫ�ı�����
if total_Room>=num %��Ҫnum���ؼ�¼��ѹ���ռ��С
    %% �ڼ��ܻ�ϴͼ����Ƕ�����ݣ�����Ƕ���ߣ�
    [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D); 
    num_emD = length(emD);
    %% ������ͼ������ȡ������Ϣ�������ߣ�
    [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
    %% �ָ�����ͼ�񣨽����ߣ�
    [recover_I] = Image_Recover(stego_I,K_en,K_sh);
    %% ͼ��Ա�
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
    set(gcf, 'Position', [100, 100, 900, 170]); % ����ͼ�δ���λ�úʹ�С��ʹ�����
    subplot(131);H_Org=GetHis(origin_I); plot(0:255,H_Org);title('ԭʼͼ��');area(0:255,H_Org,'FaceColor','b');xlim([0 255]); % ����x��ķ�ΧΪ0��255
    subplot(132);H_OnlyES=GetHis(onlyES_I); plot(0:255,H_OnlyES);title('����ͼ��');area(0:255,H_OnlyES,'FaceColor','b');xlim([0 255]); ylim([0 1200]);
    %subplot(143);H_ES=GetHis(ES_I); plot(0:255,H_ES);title('��ϴͼ��');area(0:255,H_ES,'FaceColor','b');xlim([0 255]); ylim([0 1200]);
    subplot(133);H_Strgo=GetHis(stego_I); plot(0:255,H_Strgo);title('����ͼ��');area(0:255,H_Strgo,'FaceColor','b');xlim([0 255]); ylim([0 1200]);
    figure(5);
    subplot(151);imshow(origin_I,[]);title('ԭʼͼ��');xlabel('a','FontSize',14,'FontName','Times New Roman');
    subplot(152);imshow(onlyES_I,[]);title('����ͼ��');xlabel('b','FontSize',14,'FontName','Times New Roman');
    subplot(153);imshow(ES_I,[]);title('��ϴͼ��');xlabel('c','FontSize',14,'FontName','Times New Roman');
    subplot(154);imshow(stego_I,[]);title('����ͼ��');xlabel('d','FontSize',14,'FontName','Times New Roman');
    subplot(155);imshow(recover_I,[]);title('�ָ�ͼ��');xlabel('e','FontSize',14,'FontName','Times New Roman');
    figure(6);
    imshow(origin_I,[]);%title('ԭʼͼ��');
    figure(7);
    imshow(onlyES_I,[]);%title('����ͼ��');
    figure(8);
    imshow(ES_I,[]);%title('��ϴͼ��');
    figure(9);
    imshow(stego_I,[]);%title('����ͼ��');
    figure(10);
    imshow(recover_I,[]);%title('�ָ�ͼ��');
    %% ������Ϣ��
    % ����ԭʼͼ�����Ϣ��
    entropy_origin = calculateEntropy(origin_I);
    fprintf('ԭʼͼ�����Ϣ��: %f\n', entropy_origin);

    % ���������ͼ�����Ϣ��
    entropy_OnlyES = calculateEntropy(onlyES_I);
    fprintf('����ͼ�����Ϣ��: %f\n', entropy_OnlyES);
    
    % �����ϴͼ�����Ϣ��
    entropy_ES = calculateEntropy(ES_I);
    fprintf('��ϴͼ�����Ϣ��: %f\n', entropy_ES);

    % ��������ͼ�����Ϣ��
    entropy_Stego = calculateEntropy(stego_I);
    fprintf('����ͼ�����Ϣ��: %f\n', entropy_Stego);
    %% ����ͼ��Ƕ����
    [m,n] = size(origin_I);
    bpp = num_emD/(m*n);
    %% ����ж�
    check1 = isequal(emD,exD);
    check2 = isequal(origin_I,recover_I);
    if check1 == 1
        disp('��ȡ������Ƕ��������ȫ��ͬ��')
    else
        disp('Warning��������ȡ����')
    end
    if check2 == 1
        disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
    else
        disp('Warning��ͼ���ع�����')
    end
    %---------------������----------------%
    if check1 == 1 && check2 == 1
        disp(['Embedding capacity equal to : ' num2str(num_emD) ' bits'] )
        disp(['Embedding rate equal to : ' num2str(bpp) ' bpp'])
        fprintf(['�ò���ͼ��------------ OK','\n\n']);
    else
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end  
else %��ͼ��̫���ӣ����Ԥ�����̫�࣬���¸�����Ϣ����ѹ���ռ�
    disp('������Ϣ����ѹ���ռ䣬�����޷��洢���ݣ�') 
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end
