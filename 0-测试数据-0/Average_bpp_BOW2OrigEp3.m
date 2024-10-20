clear
clc
%% ��ȡ����
load('num_BOWS2OrigEp3.mat'); %��ȡ����,Ƕ������
load('bpp_BOWS2OrigEp3.mat'); %��ȡ����,Ƕ����
load('len_BOWS2OrigEp3.mat'); %��ȡ����,λƽ��ѹ������
load('room_BOWS2OrigEp3.mat');%��ȡ����,λƽ��ѹ���ռ�
load('over_BOWS2OrigEp3.mat');%��ȡ����,ͼ��������ظ���
%% ͳ��ͼ�����ݼ���ƽ��Ƕ���ʺʹ���ͼ��ID�Լ����Ƕ���ʺ���СǶ����
len = length(num_BOWS2OrigEp3); %���ݼ�ͼ�����
error_Data = 0;
error_Data_Image = zeros(); %�洢������Ϣ������Ƕ������ͼ��ID
error_NoRe = 0;
error_NoRe_Image = zeros(); %�洢��ȡ���ݻ�ָ�ͼ����ȷ��ͼ��ID
total_True = 0;%ͳ����ȷ��ȡ�ָ�ͼ�����Ŀ
total_bpp = 0; %������ͳ����ȷͼ�����Ƕ����
Best_Image_bpp = 0;%��¼���ݼ��е����Ƕ����
Best_Image_id = 0; %��¼ͼ��ID
Worst_Image_bpp = 8;%��¼���ݼ��е���СǶ����
Worst_Image_id = 0; %��¼ͼ��ID
for i=1:len
    if num_BOWS2OrigEp3(i)==-1 && bpp_BOWS2OrigEp3(i)==0 %������Ϣ������Ƕ����������Ƕ������
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
ave_bpp = total_bpp/total_True; %��ȷͼ���ƽ��Ƕ����
fprintf(['��ȷͼ���ƽ��Ƕ����Ϊ:',num2str(ave_bpp),'\n']);
fprintf(['ͼ�������Ƕ����Ϊ:',num2str(Best_Image_bpp),'||ͼ��ID:',num2str(Best_Image_id),'\n']);
fprintf(['ͼ������Ƕ����Ϊ:',num2str(Worst_Image_bpp),'||ͼ��ID:',num2str(Worst_Image_id),'\n']);
%% ͳ��ͼ�����ݼ��е����������ظ���������������ظ���
Most_Over = 0; %��¼���ݼ��е����������ظ���
Most_Over_id = 0; %��¼ͼ��ID
Least_Over = Inf; %��¼���ݼ��е�����������ظ���
Least_Over_id = 0; %��¼ͼ��ID
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
ave_Over = total_Over/len; %���ݼ���ƽ��������ظ���
fprintf(['���ݼ���ƽ�����Ԥ��������ظ���Ϊ:',num2str(ave_Over),'\n']);
fprintf(['ͼ������������ظ���Ϊ:',num2str(Most_Over),'||ͼ��ID:',num2str(Most_Over_id),'\n']);
fprintf(['ͼ�������������ظ���Ϊ:',num2str(Least_Over),'||ͼ��ID:',num2str(Least_Over_id),'\n']);
%% ͳ�����ݼ���ÿ��λƽ���ѹ�����
Comp_BitPlane = zeros(1,8);
for i=1:len
    for j=1:8
        if room_BOWS2OrigEp3(j,i) ~= 0 %��ʾλƽ����ѹ���ռ䣬����ѹ��
            Comp_BitPlane(j) = Comp_BitPlane(j)+1;
        end
    end
end
%% ͳ�����ݼ���ÿ��λƽ���ƽ��ѹ����
Comp_Ratio = zeros(1,8); %��¼λƽ���ѹ����
for i=1:8
    total_comp_len = 0;
    num_len = 0;
    for j=1:len
        if len_BOWS2OrigEp3(i,j) ~= 0 % %��ʾλƽ���ѹ��
            num_len = num_len+1; 
            total_comp_len = total_comp_len + len_BOWS2OrigEp3(i,j);
        end
    end
    Comp_Ratio(i) = (total_comp_len/num_len)/(512*512);
end
for i=1:8
    fprintf(['��',num2str(9-i),'λƽ���ѹ����Ϊ:',num2str(Comp_Ratio(i)),'\n']);
end
fprintf(['λƽ���ƽ��ѹ����Ϊ:',num2str(sum(Comp_Ratio)/8),'\n']);
%% ͳ��λƽ��ѹ��ƽ�����ȡ�λƽ��ƽ�����أ�512*512��
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