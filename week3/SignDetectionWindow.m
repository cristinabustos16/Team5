function [ metrix_method ] = SignDetectionWindow( window_method, files_train, directory, path_images_write )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  Module 1 Block 3 Task 4  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Add folders of functions to path
addpath('./evaluation')

load('../Results/week_01/Sign_characteristics_train');

files = size(files_train, 1);

TP_images = zeros(files, 1);
FP_images = zeros(files, 1);
FN_images = zeros(files, 1);


Precision_images = zeros(files, 1);
Accuracy_images = zeros(files, 1);
Sensitivity_images = zeros(files, 1);
FMeasure_images = zeros(files, 1);
  
     
switch window_method
    case 1
        path = strcat(path_images_write, '/week_03/train_result/HSV_CCL/');
    case 2
        path = strcat(path_images_write, '/week_03/train_result/HSV&RGB_CCL/');
    case 3
        path = strcat(path_images_write, '/week_03/train_result/HSV_SW/');
    case 4
        path = strcat(path_images_write, '/week_03/train_result/HSV&RGB_SW/');
    case 5
        path = strcat(path_images_write, '/week_03/train_result/HSV_II/');
    case 6
        path = strcat(path_images_write, '/week_03/train_result/HSV&RGB_II/');
       

end

%Generate the masks for the given method
% average_time = Task3block1(path_images, List_of_images, path_images_write, window_method);

for i = 1:files
    index_SC=not(cellfun('isempty', strfind(SC_train(:,1), files_train(i).name(1:end-9))));
    SC_current_image=SC_train(index_SC,:);
    windowAnnotations = SC_current_image{:,6};
    
    load(strcat(path,files_train(i).name));
    if ~isempty(windowCandidates(1).x)
    	[windowTP, windowFN, windowFP] = PerformanceAccumulationWindow(windowCandidates, windowAnnotations);
    else
        windowTP=0;
        windowFN=size(windowAnnotations,2);
        windowFP=0;
    end
    [windowPrecision, windowAccuracy,windowSensitivity, windowFMeasure] = PerformanceEvaluationWindow(windowTP, windowFN, windowFP);
    if isnan(windowPrecision)
        windowPrecision=0;
    end
    if isnan(windowFMeasure)
        windowFMeasure=0;
    end
    TP_images(i) = windowTP;
    FP_images(i) = windowFP;
    FN_images(i) = windowFN;
    Precision_images(i) = windowPrecision;
    Accuracy_images(i) = windowAccuracy;
    Sensitivity_images(i) = windowSensitivity;
    FMeasure_images(i) = windowFMeasure;
end

average_TP = mean(TP_images);
average_FP = mean(FP_images);
average_FN = mean(FN_images);


% Precision_images(isnan(Precision_images))=0;
average_Precision = mean(Precision_images);
average_Accuracy = mean(Accuracy_images);
average_sensitivity = mean(Sensitivity_images);
average_FMeasure = mean(FMeasure_images);


% The vector metrix_method contains the measures of the method
% 1 average_Precision
% 2 average_Accuracy
% 3 average_sensitivity 
% 4 average_FMeasure 
% 5 average_Specificit
% 6 average_TP
% 7 average_FP
% 8 average_FN
% 9 average_TN
% 10 average_time

metrix_method = [average_Precision; average_Accuracy; average_sensitivity; average_FMeasure];% average_Specificit];
metrix_method = [metrix_method; average_TP; average_FP; average_FN];% average_TN; average_time];
end

