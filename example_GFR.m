clear all;
close all;
options = optimset('Display','off');

% 0 for regularized inverse, 1 for thresholded SVD
solutionType = 1;

% regularization for least squares
regularizationLambda = 5e3;

load('images.mat');
im = double(im_int2);

Nx = size(im, 1);  
Ny = size(im, 2);  
Nt = size(im, 4);
Nz = size(im, 3);

timeBetweenImages = 6;
t = [0:1:(Nt-1)] * timeBetweenImages;

cortexCenter = [153 58];
medullaCenter = [152 76];            
halfWindowSize = 2;


% make a square ROI centered about the AIF
ix = cortexCenter(1); 
iy = cortexCenter(2);
w = halfWindowSize;
cortexROI = squeeze(im((ix-w):(ix+w), (iy-w):(iy+w), 1, :));
ix = medullaCenter(1); 
iy = medullaCenter(2);
medullaROI = squeeze(im((ix-w):(ix+w), (iy-w):(iy+w), 1, :));


cortex = zeros([1, Nt]);
medulla = zeros([1, Nt]);

for ii = 1:Nt
  thisTimePointROI = cortexROI(:, :, ii);
  cortex(ii) = mean(thisTimePointROI(:));
  thisTimePointROI = medullaROI(:, :, ii);
  medulla(ii) = mean(thisTimePointROI(:));
  
end

% make a montage of the zoomed in kidney
% montage doesnt work though
xlimits = 100:200; ylimits = 40:110;
plotMatrix = zeros([length(xlimits), length(ylimits), 1, Nt]);
for ii = 1:Nt
  thisImage = squeeze(im(xlimits, ylimits, 1, ii));
  plotMatrix(:,:,1,ii) = thisImage;  
end

figure()
plot(t, cortex, '.-',...
     t, medulla, '.-')
legend('cortex ROI', 'medulla ROI')
xlabel('time [s]');
ylabel('signal');