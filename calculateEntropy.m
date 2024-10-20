function entropy = calculateEntropy(image)
    % 将图像转换为灰度图像（如果图像本身不是灰度图像）
    if size(image, 3) == 3
        grayImage = rgb2gray(image);
    else
        grayImage = image;
    end

    % 计算灰度直方图
    counts = GetHis(grayImage);

    % 计算图像的总像素数
    totalPixels = numel(grayImage);

    % 计算每个灰度级别的概率
    probabilities = counts / totalPixels;

    % 计算信息熵
    entropy = -sum(probabilities(probabilities > 0) .* log2(probabilities(probabilities > 0)));
end

