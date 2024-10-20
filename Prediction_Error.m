function [PE_I,num_Of,Overflow] = Prediction_Error(origin_I)
% ����˵��������origin_I��Ԥ�����
% ���룺origin_I��ԭʼͼ��
% �����PE_I��Ԥ�����ͼ��,num_Of�����Ԥ����������,Overflow�������Ϣ��

[row,col] = size(origin_I); %����origin_I������ֵ
PE_I = origin_I;  %�����洢origin_IԤ��ֵ������
Overflow = zeros(); %��¼�����Ϣ
num_Of = 0; %��������¼������صĸ���
for i=2:row %��һ�е�һ����Ϊ�ο�����
    for j=2:col
        a = origin_I(i-1,j);
        b = origin_I(i-1,j-1);
        c = origin_I(i,j-1);
        if b <= min(a,c)
            pv = max(a,c); %Ԥ��ֵ
        elseif b >= max(a,c)
            pv = min(a,c);
        else
            pv = a + c - b;
        end
        pe = origin_I(i,j) - pv; %����Ԥ�����
        if pe<0 && pe>=-127 %��������������λ��Ϊ1����Ϊ���
            abs_pe = abs(pe); %Ԥ�����ľ���ֵ
            PE_I(i,j) = mod(abs_pe,128) + 128;
        elseif pe>=0 && pe<=127
            PE_I(i,j) = pe;
        else
            PE_I(i,j) = origin_I(i,j); %����㲻�ı�
            num_Of = num_Of+1;
            Overflow(1,num_Of) = i; %��¼���Ԥ������λ��
            Overflow(2,num_Of) = j;
        end  
    end
end