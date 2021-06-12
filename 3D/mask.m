function maskedImageXY = mask(X, Value_Threshold)

BW = X>Value_Threshold;
% Invert mask
BW = imcomplement(BW);
% Clear borders
BW = imclearborder(BW);
% Fill holes
BW = imfill(BW, 'holes');
% Erode mask with disk
radius = 3;
decomposition = 0;
se = strel('disk',radius,decomposition);
BW = imerode(BW, se);
% Create masked image.
maskedImageXY = X;
maskedImageXY(~BW) = 1;
maskedImageXY = imcomplement(maskedImageXY);

end