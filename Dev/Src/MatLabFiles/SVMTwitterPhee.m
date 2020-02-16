%SVM attemp at Twitter and Phee

PheeFeaturesStruct = load('C:\Git\Fall_2019\SHS598_Project\NEEDED\Models\MODEL23\Normalized\Features_12mfccs_35ms_FULL_pheeCalls.mat');
TwitterFeaturesStruct = load('C:\Git\Fall_2019\SHS598_Project\NEEDED\Models\MODEL23\Normalized\Features_12mfccs_35ms_FULL_twitterCalls.mat');

PheeFeatures = PheeFeaturesStruct.normFeatures;
TwitterFeatures = TwitterFeaturesStruct.normFeatures;

FullData = [PheeFeatures; TwitterFeatures];
theclass = ones(length(FullData),1);
theclass(length(PheeFeatures):end,1)=-1;

[~,pcaData] = pca(FullData,'NumComponents',2);

cl = fitcsvm(FullData,theclass,'KernelFunction','gaussian',...
    'BoxConstraint',Inf,'ClassNames',[-1,1],'NumPrint',1000,'Verbose',1);
testData = [FullData(1:250,:) ; FullData(length(PheeFeatures):length(PheeFeatures)+250,:)];
% Predict scores over the grid
d = 0.02;
[x1Grid,x2Grid] = meshgrid(min(pcaData(:,1)):d:max(pcaData(:,1)),...
    min(pcaData(:,2)):d:max(pcaData(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[label,scores] = predict(cl,testData);

% Plot the data and the decision boundary
figure;
h(1:2) = gscatter(pcaData(:,1),pcaData(:,2),theclass,'rb','.');
hold on
ezpolar(@(x)1);
h(3) = plot(pcaData(cl.IsSupportVector,1),pcaData(cl.IsSupportVector,2),'ko');
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');
legend(h,{'-1','+1','Support Vectors'});
axis equal
hold off
