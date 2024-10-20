function [vacate_I,PL_len,PL_room,total_Room] = Vacate_Room(PE_I,Rot_type,Block_size,L_fix,L,num_Of,Overflow)
% ����˵��������BMPR�㷨ѹ��ԭʼͼ���Կճ�����Ƕ��������Ϣ�Ŀռ�
% ���룺PE_I��Ԥ�����ͼ��,Rot_type(��ת�Ƕ�����),Block_size���ֿ��С��,L_fix���������������,L����ͬ���������Ȳ�����,num_Of�����Ԥ����������,Overflow�������Ϣ��
% �����vacate_I���ճ��ռ��ͼ��,PL_len������λƽ��ѹ���������ĳ��ȣ�,PL_room������λƽ���ѹ���ռ䣩,total_Room����ѹ���ռ䣩

[row,col] = size(PE_I); %����PE_I������ֵ
num = ceil(log2(row)) + ceil(log2(col));
%% ͳ����Ҫ��¼�ĸ�����Ϣ����ز����������Ϣ��
Side = zeros(); %������¼������Ϣ
num_Side = 0; %����
%---------------------��¼��ز�����Block_size,L_fix��---------------------%
[bin28_Rt] = BinaryConversion_10_2(Rot_type); %����ת�Ƕ�����Rot_typeת����8λ������
Side(num_Side+1:num_Side+2) = bin28_Rt(7:8); %��2bit��ʾ�ֿ��СRot_type
num_Side = num_Side + 2;
[bin28_Bs] = BinaryConversion_10_2(Block_size); %���ֿ��СBlock_sizeת����8λ������
Side(num_Side+1:num_Side+4) = bin28_Bs(5:8); %��4bit��ʾ�ֿ��СBlock_size
num_Side = num_Side + 4;
[bin28_Lf] = BinaryConversion_10_2(L_fix); %������L_fixת����8λ������
Side(num_Side+1:num_Side+3) = bin28_Lf(6:8); %��3bit��ʾ����L_fix
num_Side = num_Side + 3;
%---------------------------��¼���Ԥ�������Ϣ----------------------------%
len_num_Of = zeros(1,num); %��num���ر�ʾ���Ԥ��������
bin2_num_Of = dec2bin(num_Of)-'0'; %�����Ԥ��������ת���ɶ�����
len = length(bin2_num_Of);
len_num_Of(num-len+1:num) = bin2_num_Of;
Side(num_Side+1:num_Side+num) = len_num_Of; %��num���ر�ʾ���Ԥ��������
num_Side = num_Side + num;    
if num_Of>0
    for i=1:num_Of
        x = Overflow(1,i); 
        y = Overflow(2,i);
        pos = (x-1)*col + y - 1; %���Ԥ������λ��(-1��Ϊ�˷�ֹ������ǵú����ָ��������)
        len_pos = zeros(1,num); %��num���ر�ʾ���Ԥ������λ��
        bin2_pos = dec2bin(pos)-'0'; %�����Ԥ������λ��ת���ɶ�����
        len = length(bin2_pos);
        len_pos(num-len+1:num) = bin2_pos;
        Side(num_Side+1:num_Side+num) = len_pos; %��num���ر�ʾ���Ԥ������λ��
        num_Side = num_Side + num; 
    end
end
%% �����������洢ͼ�������ѹ������������ظ�����Ϣ
Image_Bits = zeros(); 
t = 0; %����
Image_Bits(t+1:t+num_Side) = Side; %�洢������Ϣ
t = t+num_Side;
%% �Ӹߵ�������ѹ��ͼ���λƽ���������8:MSB��1:LSB��
PL_room = zeros(1,8); %������¼λƽ��ѹ����ճ��Ŀռ��С
PL_len = zeros(1,8); %������¼λƽ��ѹ�����λƽ�����������
num_pl = 0; %������¼��ѹ��λƽ����
for pl=8:-1:1 %MSB��LSB
    %% ----------------------��ȡ��pl��λƽ��----------------------%
    [Plane] = BitPlanes_Extract(PE_I,pl);
    %% ----------------------ѹ����pl��λƽ��----------------------%
    [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix,L);
    %% -------------------��¼���յ�λƽ�������--------------------%
    len_CBS = length(CBS); %ѹ��λƽ��������ĳ���
    len_comp_PL = len_CBS+num+2+1; %ѹ��λƽ������ճ��ȣ�+num:ѹ��������������Ϣ��+2:λƽ�������з�ʽ��+1��ѹ����ǣ�
    if len_comp_PL <= row*col %�жϵ�pl��λƽ���Ƿ����ѹ������ѹ������ҪС��ԭʼ����
        %---------------------��¼λƽ���ѹ����ǣ�1 bit��-----------------%
        num_pl = num_pl+1;
        Image_Bits(t+1) = 1; %1��ʾ��λƽ�����ѹ��
        t = t+1;
        %----------------��¼λƽ��������з�ʽtype��2 bit��----------------%
        bin2_type = dec2bin(type)-'0'; %��λƽ�������з�ʽת���ɶ�����
        if length(bin2_type) == 1  %λƽ�������з�ʽ��2bit��ʾ
            tem = bin2_type(1);
            bin2_type(1) = 0;
            bin2_type(2) = tem;   
        end
        Image_Bits(t+1:t+2) = bin2_type; %�洢��ǰλƽ��������з�ʽ
        t = t+2;
        %----------------��¼λƽ��ѹ��������CBS���䳤����Ϣ-----------------%
        len_CBS_bits = zeros(1,num); 
        bin2_len_CBS = dec2bin(len_CBS)-'0'; %��ѹ��λƽ��������ĳ�����Ϣת���ɶ�����
        len = length(bin2_len_CBS);
        len_CBS_bits(num-len+1:num) = bin2_len_CBS;
        Image_Bits(t+1:t+num) = len_CBS_bits; %��num��������ʾѹ��λƽ��������ĳ���
        t = t + num;
        Image_Bits(t+1:t+len_CBS) = CBS; %��¼ѹ��λƽ�������
        t = t + len_CBS;
        %-------------��¼��λƽ���������ѹ�����ȼ��ճ��Ŀռ��С------------%
        PL_len(pl) = len_CBS;
        room = row*col - len_comp_PL; %�ճ��Ŀռ��С
        PL_room(pl) = room; 
    else
        Image_Bits(t+1) = 0; %0��ʾ��λƽ�治��ѹ��
        t = t+1;
        T_Plane = Plane'; %������ת��,��֤���յı������ǰ��б�����
        PL_bits = reshape(T_Plane,1,row*col);%��Planeת����һά���󣬰��б��� 
        Image_Bits(t+1:t+row*col) = PL_bits; %��¼ԭʼ������
        t = t + row*col;
    end
end
%% �����յ�λƽ��������Ż�ԭʼͼ����
vacate_I = PE_I;
num_t = 0; %����
for pl=8:-1:1
    re = t - num_t; %ʣ���ѹ��ͼ�������
    if re >= row*col    
        PL_bits = Image_Bits(num_t+1:num_t+row*col); %����λƽ�������
        num_t = num_t + row*col;
    else
        PL_bits = zeros(1,row*col);
        PL_bits(1:re) = Image_Bits(num_t+1:num_t+re); %Ƕ��ʣ�µı�����
        num_t = num_t+re;    
    end
    Plane = reshape(PL_bits,col,row); %���ɾ���,��������
    T_Plane = Plane'; %������ת��
    [RI] = BitPlanes_Embed(vacate_I,T_Plane,pl); %������λƽ�����Ż�ͼ����
    vacate_I = RI;
end
%% ������ѹ���ռ��С
total_Room = row*col*8 - t; %�ܱ�������ȥ�洢ѹ����������Ŀ��������Ϣ
end
