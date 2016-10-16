% Task 3. Task3block1 is a function that perfoms a segmentation of the red
% and blue colors over an input RGB image. The function has the next 
% three input parameters (IP) and one output parameter (OP).
% 
% path_images:(IP) Is the path where we can find all the dataset.
% Imgs:(IP) List of images that have been chosen as training set (Task 2)
% on which segmentation will be performed.
% colorSpace:(IP) number that represents the method applied to implement
% the segmentation.
%                                  ------Method------
%       colorSpace 1 -> RGB with manual selection of the thresholds.
%       colorSpace 2 -> RGB using Otsu?s segmentation method.
%       colorSpace 3 -> Segmentation on HSV color space.
%       colorSpace 4 -> Segmentation on Lab color space.
%       colorSpace 5 -> Segmentation on YUV color space.
%       colorSpace 6 -> Combination of HSV and RGB color spaces.
%
% time:(OP) number that represents the average of time that is needed for
% execute the segmentation for a specific method.

function time = Mask4(path_images, Imgs, colorSpace)
mkdir([path_images 'Masks'])
Imgs = dir([path_images '/*.jpg']);

ext='.jpg';
theTime = zeros(size(Imgs, 1),1); 


switch colorSpace
    case 1
        mkdir([path_images 'Masks/RGBManual'])
        for numImagen=1:length(Imgs)
            tic
            
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
            % Red segmentation
            redMask = rgbImage(:,:,1) > 50 & rgbImage(:,:,2) < 40 &...
                rgbImage(:,:,3) < 40;
            % Blue segmentation
            blueMask = rgbImage(:,:,1) < 50 & rgbImage(:,:,2) < 60 &...
                rgbImage(:,:,3) > 60;
            
            % Combination of the red and blue segmentation -> binary image
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images 'Masks/RGBManual/' Imgswithoutext...
                '_mask.jpg' ]);
   
         theTime(numImagen) = toc;
        end

    case 2
        mkdir([path_images 'Masks/OtsuRGB'])
        for numImagen = 1:length(Imgs)
            tic
            
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));            
            Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
            redThresh = multithresh(rgbImage(:,:,1),2);
            greenThresh = multithresh(rgbImage(:,:,2),2);
            blueThresh = multithresh(rgbImage(:,:,3),2);
            
            % Red segmentation
            redMask = rgbImage(:,:,1) > redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) < blueThresh(1);
            % Blue segmentation
            blueMask = rgbImage(:,:,1) < redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) > blueThresh(1);
            % Combination of the red and blue segmentation -> binary image
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images 'Masks/OtsuRGB/' Imgswithoutext...
                '_mask.jpg' ]);
            
            theTime(numImagen) = toc;            
        end
        
    case 3
        mkdir([path_images 'Masks/HSV'])
        for numImagen=1:length(Imgs)
            tic
            
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name)); 
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            
            % Convert RGB image to HSV space            
            hsvImage = rgb2hsv(rgbImage);
            hImage = round(hsvImage(:,:,1)*360);% Multiplied by 360 because hue is defined as and angle [0,2pi]
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);
            
            % A threshold of the hsv components of pixels must be an interval
            hredInterval = [350 20]; % Range of hue values considered red
            hblueInterval = [200 230]; % Range of hue values considered blue            
            sInterval = [0.5 1]; % Minimum saturation value to exclude noise
            vInterval = [0.1 1];
            
            % Red segmentation
            redMask = (hImage >=hredInterval(1) | hImage <= hredInterval(2))...
                & sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            % Blue segmentation
            blueMask = (hImage >= hblueInterval(1) & hImage <= hblueInterval(2))...
                & sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
     
            % Combination of the red and blue segmentation -> binary image
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images 'Masks/HSV/' Imgswithoutext...
                '_mask.jpg' ]);
            
            theTime(numImagen) = toc;  
        end
        
    case 4
        mkdir([path_images 'Masks/Lab'])
        for numImagen=1:length(Imgs)
            tic
            
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            
            % Convert RGB image to Lab space
            labImage = rgb2lab(rgbImage);
            
            labImage = zeros(size(rgbImage));
            [labImage(:, :, 1), labImage(:, :, 2), labImage(:, :, 3)] =...
                RGB2Lab_own(rgbImage(:, :, 1), rgbImage(:, :, 2),...
                rgbImage(:, :, 3));
            %labImage = rgb2lab(rgbImage);
            
            % Red segmentation
            redMask = labImage(:,:,2)==1 & labImage(:,:,3)==1;
            % Blue segmentation
            blueMask = labImage(:,:,2)==0 & labImage(:,:,3)==0;
            
            % Combination of the red and blue segmentation -> binary image
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images 'Masks/Lab/' Imgswithoutext...
                '_mask.jpg' ]);
            
            theTime(numImagen) = toc;
        end
        
    case 5
        mkdir([path_images 'Masks/YUV'])
        for numImagen=1:length(Imgs)
            
            tic
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            Imgswithoutext = strrep(Imgs(numImagen).name,ext,'');
            
            % Convert RGB image to YUV space
            yuvImage = rgb2yuv(rgbImage);
            
            % Red segmentation
            redMask = yuvImage(:,:,2) > 110 & yuvImage(:,:,2) < 130 & ...
                yuvImage(:,:,3) > 135 & yuvImage(:,:,3) < 165;
            % Blue segmentation
            blueMask = yuvImage(:,:,2) > 140 & yuvImage(:,:,2) < 170 & ...
                yuvImage(:,:,3) > 100 & yuvImage(:,:,3) < 120;
            
            % Combination of the red and blue segmentation -> binary image
            Mask = redMask | blueMask;
            
            imwrite(Mask,[path_images 'Masks/YUV/' Imgswithoutext...
                '_mask.jpg' ]);
   
         theTime(numImagen) = toc;
        end
        
    case 6
        mkdir([path_images 'Masks/HSV&RGB'])
        for numImagen=1:length(Imgs)
            tic
            
            rgbImage = imread(strcat(path_images,Imgs(numImagen).name));
            Imgswithoutext=strrep(Imgs(numImagen).name,ext,'');
            
            % Convert RGB image to HSV space            
            hsvImage = rgb2hsv(rgbImage);
            hImage = round(hsvImage(:,:,1)*360);% multiplied by 360 because hue is defined as and angle [0,2pi]
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);
            
            % A threshold of the hsv components of pixels must be an interval
            hredInterval = [350 20]; % Range of hue values considered 'red'
            hblueInterval = [200 230]; % Range of hue values considered 'blue'
            
            sInterval = [0.5 1]; % Minimum saturation value to exclude noise
            vInterval = [0.1 1];
            
            % Red segmentation in HSV color space
            redMask = (hImage >= hredInterval(1) | hImage <= hredInterval(2)) & ...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            % Blue segmentation in HSV color space
            blueMask = (hImage >= hblueInterval(1) & hImage <= hblueInterval(2)) &...
                sImage >= sInterval(1) & sImage <= sInterval(2) &...
                vImage >= vInterval(1) & vImage <= vInterval(2);
            
            % Combination of the red and blue segmentation on HSV color
            % space -> binary image
            Maskhsv = redMask | blueMask;

            % RGB
            redThresh = multithresh(rgbImage(:,:,1),2);
            greenThresh = multithresh(rgbImage(:,:,2),2);
            blueThresh = multithresh(rgbImage(:,:,3),2);
            
            % Red segmentation in RGB color space
            redMaskrgb = rgbImage(:,:,1) > redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) < blueThresh(1);
            % Blue segmentation in RGB color space
            blueMaskrgb = rgbImage(:,:,1) < redThresh(1) &...
                rgbImage(:,:,2) < greenThresh(1) &...
                rgbImage(:,:,3) > blueThresh(1);
            
            % Combination of the red and blue segmentation on RGB color
            % space -> binary image
            Maskrgb = redMaskrgb | blueMaskrgb;
            
            %Combination of the HSV and RGB segmentation
            Mask = Maskhsv & Maskrgb;
            
            imwrite(Mask,[path_images 'Masks/HSV&RGB/' Imgswithoutext...
                '_mask.jpg' ]);
            
            theTime(numImagen) = toc;
        end
          
end
time = mean(theTime);
end