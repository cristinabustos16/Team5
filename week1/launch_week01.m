
%Names of the different methods we have used for the segmentation
colorSpaces = {'OtsuRGB' 'HSV' 'Lab' 'HSV&RGB' 'RGBManual' 'Yuv'};
colorSp = [         1       2     3      4           5     6];
%We create the colorSp vector because the switch works better with numbers
metrix_methods = zeros(10, 6);
%Compute the files of the train set
[ files_train ] = task2block1(  );
%Evaluate all methods ans save its metrices
for i = 3:6
    i
    pixel_method = colorSp(i);
    metr_method = SignDetection(pixel_method , files_train );
    metrix_methods(:, i) = metr_method;
end
metrix_methods(:, i) = metr_method;