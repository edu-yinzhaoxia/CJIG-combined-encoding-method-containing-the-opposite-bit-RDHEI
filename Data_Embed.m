function [stego_I,emD] = Data_Embed(ES_I,K_sh,K_hide,D)
% ����˵�����ڼ��ܻ�ϴͼ��ES_I��Ƕ��������Ϣ
% ���룺ES_I�����ܻ�ϴͼ��,K_sh��ͼ���ϴ��Կ��,K_hide������Ƕ����Կ��,D����Ƕ���������Ϣ��
% �����stego_I������ͼ��,emD(Ƕ���������Ϣ)

[row,col] = size(ES_I); %����ES_I������ֵ
%% ����ͼ���ϴ��ԿK_sh�ָ�ͼ�����ص�ԭʼλ��
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[reshuffle_I] = Image_ReShuffle(ES_I,SH);
%% ��ͼ���LSBλƽ����ȡѹ���ռ��С
num = ceil(log2(row))+ceil(log2(col))+3; %��¼��ѹ���ռ��С��Ҫ�ı�������+3�������Ƕ���ʲ�����8bpp��
bits_room = zeros(1,num); %��¼�ռ��С�ı�����
for i=1:num  %���ճ��ռ��С��¼��ͼ�����λƽ������һ�е����num����
    j = col-num+i; %���ռ��¼��������
    value = reshuffle_I(row,j);
    bit = mod(value,2);
    bits_room(i) = bit;
end
[total_Room] = BinaryConversion_2_10(bits_room);
%% ��������Ƕ����ԿK_hide��ԭʼ������ϢD���м���
[encrypt_D] = Data_Encrypt(D,K_hide);
%% �ڿճ��Ŀռ���Ƕ��������Ϣ
marked_I = reshuffle_I;
num_D = length(D);
num_emD = 0; %������Ƕ��������Ϣ��
for pl=1:8 
    if num_emD==num_D || num_emD==total_Room %������Ϣ��Ƕ��||�Ѵﵽ���Ƕ����
        break;
    end
    index = 8-pl+1; %���ص�pl��λƽ�������
    for i=row:-1:1  %�Ӻ���ǰǶ�룬��֤����ѹ���ռ䲻�����
        for j=col:-1:1
            if num_emD==num_D || num_emD==total_Room %������Ϣ��Ƕ��||�Ѵﵽ���Ƕ����
                break;
            end
            value = marked_I(i,j); %��ǰ����ֵ
            [bin2_8] = BinaryConversion_10_2(value); %ת����8λ������
            num_emD = num_emD+1;
            bin2_8(index) = encrypt_D(num_emD);
            [value] = BinaryConversion_2_10(bin2_8);
            marked_I(i,j) = value; %����������Ϣ������ֵ
        end
    end
end
%% ������������Ϣ�ı��ͼ��marked_I���л�ϴ
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[stego_I] = Image_Shuffle(marked_I,SH);
%% ͳ��Ƕ���������Ϣ
emD = D(1:num_emD);
end