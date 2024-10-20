clear
clc
%% ������������������
num_D = 2100000;
rand('seed',0); %��������
D = round(rand(1,num_D)*1); %�����ȶ������
%% ͼ�����ݼ���Ϣ(BOWS2OrigEp3),��ʽ:PGM,����:10000��
I_file_path = 'BOWS2OrigEp3\'; %����ͼ�����ݼ��ļ���·��
I_path_list = dir(strcat(I_file_path,'*.pgm')); %��ȡ���ļ���������pgm��ʽ��ͼ��
img_num = length(I_path_list); %��ȡͼ��������
%% ��¼ÿ��ͼ��ĵ������Ϣ
num_BOWS2OrigEp3 = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ���� 
bpp_BOWS2OrigEp3 = zeros(1,img_num); %��¼ÿ��ͼ���Ƕ����
over_BOWS2OrigEp3 = zeros(1,img_num);%��¼ÿ��ͼ���������ظ���
room_BOWS2OrigEp3 = zeros(8,img_num);%��¼ÿ��ͼ�����λƽ���ѹ���ռ�
len_BOWS2OrigEp3 = zeros(8,img_num); %��¼ÿ��ͼ�����λƽ���ѹ������������
%% ������Կ
K_en = 1; %ͼ�������Կ
K_sh = 2; %ͼ���ϴ��Կ
K_hide=3; %����Ƕ����Կ
%% ���ò���
Block_size = 4; %�ֿ��С���洢�ֿ��С�ı�������Ҫ������Ŀǰ��Ϊ4bits��
L_fix = 3; %�����������
L = 4; %��ͬ���������Ȳ���,�����޸�
%% ͼ�����ݼ�����
ERROR = 0; %������ͳ���޷��洢��Ϣ��ͼ����
for i=1:img_num
    %-------------------------------��ȡͼ��-------------------------------%
    I_name = I_path_list(i).name; %ͼ����
    I = imread(strcat(I_file_path,I_name));%��ȡͼ��
    origin_I = double(I);
    Rot_type = [0,1,2,3];%����������ת�Ƕȣ��ֱ���0��90��180��270��
    %----------------�ճ�ͼ��ռ䲢���ܻ�ϴͼ�����������ߣ�----------------%
     nRotType = 1;
    [ES_I1,onlyES_I1,num_Of1,PL_len1,PL_room1,total_Room1] = Vacate_Encrypt(origin_I,Rot_type(1),Block_size,L_fix,L,K_en,K_sh);
    ES_I = ES_I1; onlyES_I=onlyES_I1; num_Of = num_Of1; PL_len = PL_len1; PL_room = PL_room1; total_Room = total_Room1;
    for j=2:4
        [ES_Ii,onlyES_Ii,num_Ofi,PL_leni,PL_roomi,total_Roomi] = Vacate_Encrypt(rot90(origin_I,j-1),Rot_type(j),Block_size,L_fix,L,K_en,K_sh);
        if total_Roomi>total_Room
            ES_I = ES_Ii; onlyES_I=onlyES_Ii; num_Of = num_Ofi; PL_len = PL_leni; PL_room = PL_roomi; total_Room = total_Roomi;
            nRotType = j;
        end
    end
    %[ES_I,num_Of,PL_len,PL_room,total_Room] = Vacate_Encrypt(origin_I,Block_size,L_fix,L,K_en,K_sh);
    %--------���غɿռ����num������²Ž�������Ƕ�루������ѹ���ռ䣩--------%
    [row,col] = size(origin_I); %����origin_I������ֵ
    num = ceil(log2(row))+ceil(log2(col))+2; %��¼��ѹ���ռ��С��Ҫ�ı�����
    if total_Room>=num %��Ҫnum���ؼ�¼��ѹ���ռ��С
        %---------------�ڼ��ܻ�ϴͼ����Ƕ�����ݣ�����Ƕ���ߣ�---------------%
        [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D); 
        num_emD = length(emD);
        %-----------------������ͼ������ȡ������Ϣ�������ߣ�-----------------%
        [exD] = Data_Extract(stego_I,K_sh,K_hide,num_emD);
        %-----------------------�ָ�����ͼ�񣨽����ߣ�----------------------%
        [recover_I] = Image_Recover(stego_I,K_en,K_sh);
        %-----------------------------�����¼-----------------------------%
        [m,n] = size(origin_I);
        num_BOWS2OrigEp3(i) = num_emD;
        bpp_BOWS2OrigEp3(i) = num_emD/(m*n);
        over_BOWS2OrigEp3(i) = num_Of; %��¼���Ԥ��������
        for pl=1:8 %��¼ͼ��λƽ��ѹ�����Ⱥ�ѹ���ռ�
            len_BOWS2OrigEp3(pl,i) = PL_len(pl);
            room_BOWS2OrigEp3(pl,i) = PL_room(pl);
        end
        %-----------------------------����ж�-----------------------------%
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
        %-----------------------------������-----------------------------%
        if check1 == 1 && check2 == 1
            bpp = bpp_BOWS2OrigEp3(i);
            disp(['Embedding capacity equal to : ' num2str(num_emD)])
            disp(['Embedding rate equal to : ' num2str(bpp)])
            fprintf(['�� ',num2str(i),' ��ͼ��-------- OK','\n\n']);
        else
            ERROR = ERROR+1;
            if check1 ~= 1 && check2 == 1
                bpp_BOWS2OrigEp3(i) = -1; %��ʾ��ȡ���ݲ���ȷ
            elseif check1 == 1 && check2 ~= 1
                bpp_BOWS2OrigEp3(i) = -2; %��ʾͼ��ָ�����ȷ
            else
                bpp_BOWS2OrigEp3(i) = -3; %��ʾ��ȡ���ݺͻָ�ͼ�񶼲���ȷ
            end
            fprintf(['�� ',num2str(i),' ��ͼ��-------- ERROR','\n\n']);
        end 
    else %��ͼ��̫���ӣ����Ԥ�����̫�࣬���¸�����Ϣ����ѹ���ռ�
        ERROR = ERROR+1;
        num_BOWS2OrigEp3(i) = -1; %��ʾ����Ƕ��������Ϣ
        over_BOWS2OrigEp3(i) = num_Of; %��¼���Ԥ��������
        for pl=1:8 %��¼ͼ��λƽ��ѹ�����Ⱥ�ѹ���ռ�
            len_BOWS2OrigEp3(pl,i) = PL_len(pl);
            room_BOWS2OrigEp3(pl,i) = PL_room(pl);
        end
        disp('������Ϣ����ѹ���ռ䣨��ѹ���ռ�С��0���������޷��洢���ݣ�') 
        fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
    end  
end
%% ��������
save('num_BOWS2OrigEp3')
save('bpp_BOWS2OrigEp3')
save('over_BOWS2OrigEp3')
save('room_BOWS2OrigEp3')
save('len_BOWS2OrigEp3')