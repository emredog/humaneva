function [ ] = TestEpipolarLines( im1, im2, F_12, resOfPoints )
%TESTEPIPOLARLINES takes two images and a fundamental matrix
% and displays some of the epipolar lines in second image that corresponds
% to the points in the first image

if nargin < 4
    resOfPoints = 20;
end

%points = zeros((size(im1, 1)/resOfPoints)*(size(im1, 2)/resOfPoints));
points = [];

% generate points
for xi=10:resOfPoints:size(im1, 2)
    for yi=10:resOfPoints:size(im1, 1)
        points = [points; [xi yi] ];
    end
end

% calculate lines
epiLines = epipolarLine(F_12, points);

epiPoints  = lineToBorderPoints(epiLines, size(im2));

for ind=1:size(epiPoints, 1);
    figure;
    subplot(121); imshow(im1);
    title('Point on First Image'); hold on;
    plot(points(ind,1), points(ind,2), 'go');
    subplot(122); imshow(im2);
    title('Epipolar Line on Second Image'); hold on;
    line(epiPoints(ind, [1,3])', epiPoints(ind, [2,4])'); hold off;
    truesize;
    waitforbuttonpress;
    close all;
end


disp('nenee');


end

