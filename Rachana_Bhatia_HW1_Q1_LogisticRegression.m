clc;
clear all;
path(path,'C:\Users\Rachana\Documents\Rutgers-MBS\Analytics_Practicum\Assignment_1');
load('HW1Dataset (1).mat');


%% Normallizing the data
M= mean(data);  %% Calculating the mean of each column
S =std(data);   %% Calculating the standard deviation of each column  

%% Normallizing the data with the mean 0 and std 1
for i= 1: 23040
    for j= 1:8
        dataN(i,j)=(data(i,j) - M(1,j))/S(1,j);
    end
end

%% Converting the labels to 1(for negative) and 2 (for positive) class
labelsLR(labels==1)=2;
labelsLR(labels==0)=1;

%%(Converting back to the row vector)
labelsLR = transpose(labelsLR); 



%% Looping over the range of cvind for 10 cross fold validation
for k = 1:10
    
    %% Partioning the the data in training and test data (9:1) by keeping the data 
    %% with the having indices referring to the kth value of cvind in the test and rest in the 
    %% training data set
    
     x= find(cvind~=k);
     y= find(cvind==k);

    %% Partioning the the data in training and test data (9:1) by keeping the data 
    %% with the having indices referring to the kth value of cvind in the test and rest in the 
    %% training data set

    dataTrain= dataN(x,:);
    dataTest= dataN(y,:);

    %% Partioning the labels as well

    labelsTrain = labelsLR(x);
    labelsTest= labelsLR(y);

  
   
    %% Fitting the multinomial logistic regression and predicting on the odds of the classes for training labesls

    lrM= mnrfit(dataTrain,labelsTrain);
    lrP= mnrval(lrM,dataTrain);

    %% Classifying the predicting Training labels based on the greater value of the probablity predicted

    for i=1:length(labelsTrain)
        if (lrP(i,1)>lrP(i,2))
            labelTrainPredict(i,1)=1;
        else labelTrainPredict(i,1)= 2;
        end
    end
    
    %% Getting the class performance for the training data set
    cp = classperf(labelsTrain,'Positive',2, 'Negative', 1);  %% Initialling it with the traing labels
    cp= classperf(cp,labelTrainPredict);

    %% Extracting the values of accuracy , Senstivity and Specificity  for each of the 10 folds and string in a vector of size 10
     accuracy(k)=cp.CorrectRate;
     sensitivity(k)= cp.Sensitivity;
     specificity(k)=cp.Specificity;

   %% predicting on the odds of the classes for test data

    lrP2= mnrval(lrM,dataTest);

   %% Classifying the predicted Test labels based on the greater value of the probablity predicted
    for i=1:length(labelsTest)
        if (lrP2(i,1)>=lrP2(i,2))
            labelTestPredict(i,1)=1;
        else labelTestPredict(i,1)= 2;
        end
    end
    
    %% Evaluating the perdiction performance on the test set
    cpTestI = classperf(labelsTest,'Positive',2, 'Negative', 1);
    cpTest= classperf(cpTestI,labelTestPredict);

     %% Extracting the values of accuracy , Senstivity and Specificity  for each of the 10 folds and storing in a vector of size 10
       accuracy2(k)=cpTest.CorrectRate;
       sensitivity2(k)= cpTest.Sensitivity;
       specificity2(k)=cpTest.Specificity;

end

%% Taking the mean of accuracy ,Senstivity and Specificity for the training set over all the 10 folds

accLR= mean(accuracy);
SensitivityLR= mean(sensitivity);
specificityLR = mean(specificity);

%% Taking the mean of accuracy ,Senstivity and Specificity for the training set over all the 10 folds
accLR2= mean(accuracy2);
SensitivityLR2= mean(sensitivity2);
specificityLR2 = mean(specificity2);
