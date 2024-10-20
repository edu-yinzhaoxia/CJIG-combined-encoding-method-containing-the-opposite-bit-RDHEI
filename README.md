# 本文为“位平面隐含异位压缩的密文图像可逆信息隐藏”的实验代码

**引用格式：** 

陈振宇,殷赵霞*,占鸿渐等.隐含异位联合编码的密文图像可逆信息隐藏[J].中国图象图形学报,DOI：10.11834/jig.240287.

CHEN Zhenyu,YIN Zhaoxia*,ZHAN Hongjian,et al.Reversible data hiding in encrypted images based on combined encoding method containing the opposite bit[J].Journal of Image and Graphics,DOI：10.11834/jig.240287.

原文链接：https://www.cjig.cn/zh/article/doi/10.11834/jig.240287/


## 摘要

目的 密文图像可逆信息隐藏技术旨在将信息嵌入至加密图像，以确保信息和原始图像能够准确提取和无损恢复。针对密文图像可逆信息隐藏嵌入率不高的问题，通过增加编码的信息运载效率与利用相邻像素相关性，提出了一种位平面隐含异位联合编码的密文图像可逆信息隐藏方案。方法 首先，图像所有者将原始图像分成大小相等的块，并计算出原始图像像素的预测误差。然后，对预测误差的八个位平面进行重排。在位平面压缩阶段，运用隐含异位的联合编码方法进行压缩。压缩后，各类辅助信息被放置到多个高位平面并加密，在多个低位平面上预留空间，结束后进行图像混洗。信息隐藏者将信息嵌入到混洗图像的预留空间中。最后，图像接收者使用密钥提取嵌入的信息或无损恢复原始图像。结果 实验结果表明，所提算法在两个常用数据集BOSSBase和BOWS2上的平均嵌入率分别为3.818 3bpp和3.694 3bpp，在同类算法中表现优异。结论 所提算法更好地利用原始图像相邻像素间的相关性解决了实际应用中连续比特流串长度较短、数量较多带来的压缩率损失问题，从而提升了嵌入率。

## Abstract

Objective The technology of reversible data hiding in encrypted images (RDHEI) aims to embed secret information into encrypted images, ensuring that both the secret information and the original image can be extracted and restored without loss. This technology is gaining increasing attention from researchers and is widely applied in cloud services to protect users’ privacy. Currently, RDHEI can be mainly divided into two categories: the VRAE (vacating room after encryption) algorithm and the RRBE (reserving room before encryption) algorithm, based on the order of image encryption and room operation. The VRAE algorithm vacates room by compressing the pixels of the encrypted image. Due to the high information entropy of the encrypted image, the compression of the image only yields a limited amount of room. The RRBE algorithm primarily compresses the image utilizing pixel correlation, and then encrypts the image. Since there is a smaller information entropy of the original image, more room is reserved before encryption. To improve the performance of the reversible data hiding in encrypted images algorithm, a new RDHEI scheme based on bit-plane compression containing opposite bits, leveraging the correlation between the encoding information delivery efficiency and adjacent pixels, is proposed in this paper. Method Firstly, to ensure the utilization of the correlation between adjacent pixels, bit-plane rearrangement and pixel prediction methods are adopted. First, the image owner divides the original image into several equally sized blocks and calculates the prediction errors of the original image pixels. Then, the eight bit-planes of the processed image are rearranged. In the phase of bit-plane compression, we present a combined encoding method containing the opposite bit. Specifically, the image bitstream is divided into continuous and discontinuous streams for compression, based on the length threshold. After compressing a continuous bitstream string, the next opposite digit at the end of the string is included, meaning each long compressed bitstream adds an opposite digit. According to this rule, the rearranged images are compressed and sequentially placed in each high-level plane with additional information. Encryption and scrambling operations occur at this point. Then, the room in the low-level plane is vacated and the information hider embeds the data into the reserved room of the encrypted image. Finally, the image receiver extracts the original image or secret information without loss based on the different keys used. Result To evaluate the effectiveness of this algorithm, we provide experimental comparisons with six advanced methods on six standard test images and two common datasets, namely, BOSSBase and BOWS2. The embedding rate is used to measure algorithm performance, while PSNR and SSIM indicators serve as quantitative evaluation metrics for lossless reversible recovery. The experimental results show that the average embedding rates of the proposed algorithm on the BOSSBase and BOWS2 datasets are 3.818 3bpp and 3.694 3bpp, respectively, demonstrating superior performance compared to similar algorithms. PSNR and SSIM are constant values equal to +∞ and 1, which indicates that the algorithm is reversible. Conclusion The proposed algorithm utilizes the image correlation of the original image and effectively explores the potential of the encoded and compressed information during the encoding and compression process. It addresses the issue of compression loss caused by the short and large number of continuous bitstream strings in practical applications, thereby improving compression efficiency and enhancing the embedding rate.

**实验环境：** matlab R2021a（大部分版本都可复现）

**实验数据介绍：**

1. 图片样例6张，分别为Airplane.tiff、Baboon.tiff、Jetplane.tiff、Lena.tiff、Man.tiff、Tiffany.tiff，放在“测试图像”文件夹中；

2. 测试数据集共2个，分别为BOSSbase_1.01和BOWS2OrigEp3，分别都含有10000张测试图片，数据集下载地址为BOSSbase_1.01 http://dde.binghamton.edu/download/ImageDB/BOSSbase_1.01.zip  ，
BOWS2OrigEp3 http://bows2.ec-lille.fr/BOWS2OrigEp3.tgz ，并在含有main.m的文件夹中新建BOSSbase_1.01与BOWS2OrigEp3文件夹，将两者的数据集图片，分别解压到各自的文件夹中。


## 图片样例测试
1.打开 main.m 文件，在运行测试样例部分，测试哪张图片，就取消注释哪张图片，然后点击运行即可。

正确运行后，会弹出四张图，第1、2、3张图分别为原始图像、加密图像、载密图像的灰度直方图，第4张图为实验流程不同阶段图像；在命令行窗口会展示是否正确运行，打印出嵌入bit数量，以及嵌入率（ER）。

## 数据集测试
以BOSSbase_1.01测试为例，BOWS2OrigEp3操作步骤类似：
1.打开 Main_BOSSbase.m 文件，点击运行；
2.每测试一张图片，就会打开一张图片窗口，每张图片运行后会在命令行窗口会展示是否正确运行，打印出嵌入bit数量，以及嵌入率（ER），如此遍历整个数据集；
3.全部运行完成后，会生成num_BOSSbase.mat（嵌入容量）、bpp_BOSSbase.mat（嵌入率）、over_BOSSbase.mat（图像溢出像素个数）、room_BOSSbase.mat（位平面压缩空间）、len_BOSSbase.mat（位平面压缩长度）五个数据文件，然后将他们放入“0-测试数据-0”文件夹中；
4.运行Average_bpp_BOSSbase.m 文件，在命令行窗口会展示、正确图像的平均嵌入率、图像的最优嵌入率及图像ID、图像的最差嵌入率及图像ID、数据集的平均溢出预测误差像素个数、图像的最多溢出像素个数及图像ID、图像的最少溢出像素个数及图像ID、第1-8位平面的压缩比、位平面的平均压缩比。

## 备注
1. 部分matlab可能需要安装“Image Processing Toolbox”才可正确运行。
2. 已将两个数据集实验数据文件打包至“0-测试数据-0”文件夹中的BOSS_BOW2_实验数据文件.zip中，打开即可直接使用。
3. 数据集链接如果无法打开，请使用如下网盘链接下载：链接：https://pan.baidu.com/s/1f7mCRQViUmWzRMVKLk9OIA 提取码：56yj