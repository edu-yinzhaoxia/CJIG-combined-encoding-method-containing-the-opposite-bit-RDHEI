function [recover_I] = Image_Recover(stego_I,K_en,K_sh)
% ����˵����������ͼ��stego_I���ָܻ�
% ���룺stego_I������ͼ��,K_en��ͼ�������Կ��,K_sh��ͼ���ϴ��Կ��
% �����recover_I���ָ�ͼ��

[row,col] = size(stego_I); %����stego_I������ֵ
%% ����ͼ���ϴ��ԿK_sh�ָ�ͼ�����ص�ԭʼλ��
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[reShuffle_I] = Image_ReShuffle(stego_I,SH);
%% ����ͼ�������ԿK_en����ͼ��re_I
rand('seed',K_en); %��������
E = round(rand(row,col)*255); %���ɴ�СΪrow*col��α���������
decrypt_I = reShuffle_I;
for i=1:row  %����α���������E��ͼ��vacate_I����bit������
    for j=1:col
        decrypt_I(i,j) = bitxor(reShuffle_I(i,j),E(i,j));
    end
end
%% ͳ��decrypt_I����λƽ��ı�����
Image_Bits = zeros();  %�洢ͼ��λƽ��ı�����
num_TB = 0; %����,��¼�����ı�������
for pl=8:-1:1
    [Plane] = BitPlanes_Extract(decrypt_I,pl);
    T_Plane = Plane'; %������ת��,��֤���յı������ǰ��б�����
    PL_bits = reshape(T_Plane,1,row*col); %��Planeת����һά����,���б���
    Image_Bits(num_TB+1:num_TB+row*col) = PL_bits;
    num_TB = num_TB+row*col;
end
t = 0; %����
%% ��ȡ��ز�����Block_size,L_fix��
bin28_Rt = Image_Bits(t+1:t+2); %��ȡ�洢����ת�Ƕ���Ϣ(2 bits)
[Rot_type] = BinaryConversion_2_10(bin28_Rt); %�Ƕȴ�С
t = t+2;
bin28_Bs = Image_Bits(t+1:t+4); %��ȡ�洢�ķֿ��С��Ϣ(4 bits)
[Block_size] = BinaryConversion_2_10(bin28_Bs); %�ֿ��С
t = t+4;
bin28_Lf = Image_Bits(t+1:t+3); %��ȡ�洢�Ĳ�����Ϣ(3 bits)
[L_fix] = BinaryConversion_2_10(bin28_Lf); %����L_fix
t = t+3;
%% ��ȡ�����Ϣ
Overflow = zeros(); %��¼�����Ϣ
num = ceil(log2(row)) + ceil(log2(col)); %��¼������Ϣ��Ҫ�ı�����
bin2_num_Of = Image_Bits(t+1:t+num); %��num���ر�ʾ���Ԥ��������
t = t+num;
[num_Of] = BinaryConversion_2_10(bin2_num_Of); %���Ԥ�����ĸ���
if num_Of>0
    for i=1:num_Of
        bin2_pos = Image_Bits(t+1:t+num);
        t = t+num;
        [pos] = BinaryConversion_2_10(bin2_pos);
        x = ceil((pos+1)/col);%+1��ǰ������з�ֹ�����-1���Ӧ
        y = pos+1 - (x-1)*col;
        Overflow(1,i) = x;
        Overflow(2,i) = y;
    end
end
%% �Ӹߵ������λָ�ͼ���λƽ�棨8��1��
PE_I = decrypt_I;
for pl=8:-1:1
    sign = Image_Bits(t+1);
    t = t+1; %����ѹ�����
    if sign == 1 %��ʾ��λƽ���ѹ��
        %------------------��ȡλƽ��������з�ʽ��2 bits��-----------------%
        bin2_type = Image_Bits(t+1:t+2); 
        [type] = BinaryConversion_2_10(bin2_type); %λƽ�������з�ʽ
        t = t+2;
        %----------------------��ȡλƽ���ѹ��������-----------------------%
        bin2_len = Image_Bits(t+1:t+num); 
        [len_CBS] = BinaryConversion_2_10(bin2_len); %λƽ��ѹ���������ĳ���
        t = t+num;
        CBS = Image_Bits(t+1:t+len_CBS); %��ǰλƽ���ѹ��������
        t = t+len_CBS;
        %---------------------��ѹ��λƽ���ѹ��������----------------------% 
        [Plane_bits] = BitStream_DeCompress(CBS,L_fix);
        %-----------------------�ָ�λƽ���ԭʼ����------------------------% 
        [Plane_Matrix] = BitPlanes_Recover(Plane_bits,Block_size,type,row,col);
    else %��ʾ��λƽ�治��ѹ����ֱ����ȡ
        Plane_bits = Image_Bits(t+1:t+row*col); %��ǰλƽ���ѹ��������
        t = t+row*col;
        Plane = reshape(Plane_bits,col,row); %���ɾ���,��������
        Plane_Matrix = Plane'; %ת�þ���
    end
    %% ---------------���ָ���λƽ�����Żؽ���ͼ����---------------% 
    [RI] = BitPlanes_Embed(PE_I,Plane_Matrix,pl);
    PE_I = RI;
end
%% �ָ�ԭʼͼ��
recover_I = PE_I;
k = 0; %����
for i=2:row  %��һ�е�һ��Ϊ�ο�����ֵ
    for j=2:col
        if k<num_Of   
            if i==Overflow(1,k+1) && j==Overflow(2,k+1) %����㲻��
                k = k+1;
                recover_I(i,j) = PE_I(i,j);
            else
                %--------------------------����Ԥ��ֵ--------------------------%
                a = recover_I(i-1,j);
                b = recover_I(i-1,j-1);
                c = recover_I(i,j-1);
                if b <= min(a,c)
                    pv = max(a,c); %Ԥ��ֵ
                elseif b >= max(a,c)
                    pv = min(a,c);
                else
                    pv = a + c - b;
                end
                %-----------------����Ԥ�����ָ�ԭʼ����ֵ------------------%
                value = recover_I(i,j);
                if value>128 %���λΪ1����ʾԤ������Ǹ���
                    pe = value-128;
                    recover_I(i,j) = pv - pe; 
                else
                    pe = value; %Ԥ�����
                    recover_I(i,j) = pv + pe;
                end   
            end  
        else
            %--------------------------����Ԥ��ֵ--------------------------%
            a = recover_I(i-1,j);
            b = recover_I(i-1,j-1);
            c = recover_I(i,j-1);
            if b <= min(a,c)
                pv = max(a,c); %Ԥ��ֵ
            elseif b >= max(a,c)
                pv = min(a,c);
            else
                pv = a + c - b;
            end
            %-----------------����Ԥ�����ָ�ԭʼ����ֵ------------------%
            value = recover_I(i,j);
            if value>128 %���λΪ1����ʾԤ������Ǹ���
                pe = value-128;
                recover_I(i,j) = pv - pe; 
            else
                pe = value; %Ԥ�����
                recover_I(i,j) = pv + pe;
            end 
        end 
    end
end 
%% ������ת�������»ָ�ͼ��
if Rot_type == 0
    %recover_I = recover_I;
elseif Rot_type == 1
    recover_I = rot90(recover_I,3);
elseif Rot_type == 2
    recover_I = rot90(recover_I,2);
elseif Rot_type == 3
    recover_I = rot90(recover_I);
end
    