%% Function to calculate lung volume from 3D volumetric structures

function vol = lung_funcion(path_in)

    %% READ THE DATA
    info = dicomread(path_in);

    %We adjust the structure and grayscale
    V = im2single(info);
    V = imadjustn(V);

    %We go from 4D to 3D
    V = V(:,:,1,:);
    V = squeeze(V); 

    %Read values
    filename = 'C:/Users/lucia/Desktop/TFG/Prueba/Values.xlsx';
    Values = readtable(filename);
    Value_Threshold = Values.Threshold(1);

    %% SEGMENT THE LUNG
    size_=size(V);
    size_XY=int16(size_(3)/2)-15;
    size_XZ=int16(size_(1)/2);

    %Select center images
    XY = V(:,:,size_XY);
    XZ = squeeze(V(size_XZ,:,:));

    %We create the center images
    maskedImageXY = mask(XY, Value_Threshold);
    maskedImageXZ = mask(XZ, Value_Threshold);


    %% CREATE SEED MASK AND SEGMENT LUNGS USING ACTIVECONTOUR

    mask = false(size(V));
    mask(:,:,size_XY) = maskedImageXY;
    mask(size_XZ,:,:) = maskedImageXZ;

    V = histeq(V);
    BW = activecontour(V,mask,100,'Chan-Vese');

    %% COMPUTE THE VOLUME OF THE SEGMENTED LUNGS

    volLungsPixels = regionprops3(logical(BW),'volume');

    if height(volLungsPixels)>0
        vol = volLungsPixels.Volume(1);
    else
        vol = NaN;
    end

end

