function [ES_I,onlyES_I,num_Of,PL_len,PL_room,total_Room] = Vacate_Encrypt(origin_I,Rot_type,Block_size,L_fix,L,K_en,K_sh)
% ����˵�����ճ�ͼ��ռ䲢����ԭʼͼ�񣬵õ��ճ�Ƕ��ռ�ļ���ͼ��
% ���룺origin_I��ԭʼͼ��,Rot_type(��ת�Ƕ�����),Block_size���ֿ��С��,L_fix���������������,L����ͬ���������Ȳ�����,K_en��ͼ�������Կ��,K_sh��ͼ���ϴ��Կ��
% �����ES_I��ѹ��֮��ļ��ܻ�ϴͼ��,onlyES_I(ѹ��֮�������ͼ�񣬺�ѹ���ռ��С��¼),Overflow�����Ԥ������λ����Ϣ��,PL_len������λƽ��ѹ���������ĳ��ȣ�,PL_room����λƽ��ѹ���ռ��С��,total_Room����ѹ���ռ䣩

[row,col] = size(origin_I); %����origin_I������ֵ
num = ceil(log2(row))+ceil(log2(col))+3; %��¼��ѹ���ռ��С��Ҫ�ı�������+3�������Ƕ���ʲ�����8bpp��
%% ����ԭʼͼ��origin_I��Ԥ�����ͼ��
[PE_I,num_Of,Overflow] = Prediction_Error(origin_I);
%% ��Ԥ�����ͼ��PE_I�пճ�����Ƕ��������Ϣ�Ŀռ�
[vacate_I,PL_len,PL_room,total_Room] = Vacate_Room(PE_I,Rot_type,Block_size,L_fix,L,num_Of,Overflow);
%% ����ͼ�������ԿK_en����ͼ��vacate_I
rand('seed',K_en); %��������
E = round(rand(row,col)*255); %���ɴ�СΪrow*col��α���������
encrypt_I = vacate_I;
for i=1:row  %����α���������E��ͼ��vacate_I����bit������
    for j=1:col
        encrypt_I(i,j) = bitxor(vacate_I(i,j),E(i,j));
    end
end
%% ���غɿռ����num������²Ž��м�¼��������ѹ���ռ䣩
transition_I = encrypt_I;
if total_Room>=num %��Ҫnum���ؼ�¼��ѹ���ռ��С
    %% ����ѹ���ռ��Сת���ɶ��������� 
    bits_room = zeros(1,num);
    bin2_room = dec2bin(total_Room)-'0';
    len = length(bin2_room);
    bits_room(num-len+1:num) = bin2_room;
    %% ��ͼ���LSBλƽ�����num���ؼ�¼��ѹ���ռ��С(bits_room)
    for i=1:num %���ճ��ռ��С��¼��ͼ�����λƽ������һ�е����num����
        j = col-num+i; %���ռ��¼��������
        value = transition_I(row,j);
        bit = bits_room(i);
        value_1 = (floor(value/2))*2 + bit;
        transition_I(row,j) = value_1;
    end  
end
onlyES_I = transition_I;
%% ����ͼ���ϴ��ԿK_sh��ϴͼ��transition_I����߰�ȫ�ԣ�
rand('seed',K_sh); %��������
SH = randperm(row*col); %���ɴ�СΪrow*col��α�������
[shuffle_I] = Image_Shuffle(transition_I,SH);
%% ��¼����Ƕ��ռ�ļ��ܻ�ϴͼ��
ES_I = shuffle_I;
