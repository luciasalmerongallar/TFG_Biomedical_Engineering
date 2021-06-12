%% Function to calculate lung volume from 3D volumetric structures with 2D images

function Vol = LUNG(path_in)


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
    Value_Similarity = Values.Similarity(1);
    Value_Threshold = Values.Threshold(1);

    %% SEGMENT THE LUNG
    size_=size(V);
    size_XY=int16(size_(3)/2)-15;

    %Select center image
    XY = V(:,:,size_XY);

    %% CREATE THE MASK AND SEGMENT LUNGS USING ACTIVWCONTOUR
    maskedImageXY = MASK(XY, Value_Threshold);
    maskedImageXY_fisrt = maskedImageXY;

     %Initialize variables
    AreaPixels = [];
    similarity=1;
    
    %Processed loop for top
    while ((similarity>=Value_Similarity)&& (not(size_XY == 0)))

        %% SEGMENT LUNGS USING ACTIVECONTOUR
        XY = histeq(XY);
        BW = activecontour(XY,maskedImageXY);

        %% COMPUTE THE VOLUME OF THE SEGMENTED LUNGS
        area = regionprops(logical(BW),'Area');
        area = struct2table(area);
        area = sortrows(area, [-1]);
        area = table2struct(area);
    
        % We save the lung area
        if height(area)>=1
            pe =struct2cell(area(1,1));
            if height(area)>=2
                pe2 =struct2cell(area(2,1));
                AreaPixels = [AreaPixels pe2];
            end
            AreaPixels = [AreaPixels pe];
            lunges(:,:,size_XY) = BW;

        end
        %% Select the next cut
        size_XY = size_XY-1;
        XY = V(:,:,size_XY);


        %% Create de new mask

        maskedImageXY2 = MASK(XY, Value_Threshold);

        maskedImageXY_inverse = imcomplement(maskedImageXY);
        maskedImageXY_ = imsubtract(maskedImageXY2,maskedImageXY_inverse);
        
        %Similarity calculation
        similarity = dice(logical(maskedImageXY2), logical(maskedImageXY));
        maskedImageXY = maskedImageXY2;

    end

    %Reset the variables
    size_XY=int16(size_(3)/2)-15;
    size_XY1 =size_XY;
    area = [2;2;2];
    similarity=1;
    maskedImageXY = maskedImageXY_fisrt;

    %Processed loop for bottom
    while ((similarity>=Value_Similarity)&& (not(size_XY == size_(3))))

        if(not(size_XY==size_XY1))
            %% SEGMENT LUNGS USING ACTIVECONTOUR
            XY = histeq(XY);
            BW = activecontour(XY,maskedImageXY);

            %% COMPUTE THE VOLUME OF THE SEGMENTED LUNGS
            area = regionprops(logical(BW),'Area');
            area=struct2table(area);
            area=sortrows(area, [-1]);
            area = table2struct(area);
            
            % We save the lung area
            if height(area)>=1
                pe =struct2cell(area(1,1));
                if height(area)>=2
                    pe2 =struct2cell(area(2,1));
                    AreaPixels = [AreaPixels pe2];
                end
                AreaPixels = [AreaPixels pe];
                lunges(:,:,size_XY) = BW;

            end
            
        end
        
        %% Select the next cut
        size_XY = size_XY+1;
        XY = V(:,:,size_XY);

        %% Create de new mask
        maskedImageXY2 = MASK(XY, Value_Threshold);

        maskedImageXY_inverse = imcomplement(maskedImageXY);
        maskedImageXY_ = imsubtract(maskedImageXY2,maskedImageXY_inverse);
        
        %Similarity calculation
        similarity = dice(logical(maskedImageXY2), logical(maskedImageXY));
        maskedImageXY = maskedImageXY2;

    end

    if not(isempty(AreaPixels))
        Vol = sum([AreaPixels{:}]);
    else
        Vol = NaN;
    end

end