function b = extractFeatures(w)
% Extract features for spike sorting.
%   b = extractFeatures(w) extracts features for spike sorting from the
%   waveforms in w, which is a 3d array of size length(window) x #spikes x
%   #channels. The output b is a matrix of size #spikes x #features.
%
%   This implementation does PCA on the waveforms of each channel
%   separately and uses the first three principal components. Thus, we get
%   a total of 12 features.
b = zeros(size(w,2),12);s
for i = 0:3
    [coeff, score] = pca(w(:,:,i+1)');
    b(:,(i*3+1):(i*3+3)) = score(:,1:3);
end