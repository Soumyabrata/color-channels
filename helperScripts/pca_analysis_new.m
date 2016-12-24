function [p,c,explained] = pca_analysis_new(pixels, meanChannels, stdChannels)

% Normalizing data
normalized = (pixels - repmat(meanChannels, [size(pixels, 1), 1])) ./ ...
    repmat(stdChannels, [size(pixels, 1), 1]);

% Mean centering
normalized = normalized - repmat(mean(normalized, 1), [size(pixels, 1), 1]);

% Computing the covariance matrix
covMat = cov(normalized);

% Computing eigen vectors and values
[Ve, ~] = eig(covMat);

% Relative loadings (co-efficients for the input variables)
p = Ve(:,end:-1:1);

% Reprojecting the data points
c = (p'*normalized')';

[~, ~, explained] = pcacov(covMat);

end