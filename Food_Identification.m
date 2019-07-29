%% Fine Tuning A Deep Neural Network
% This example shows how to fine tune a pre-trained deep convolutional
% neural network (CNN) for a new recognition task.
%% Load Image Data
% Data is 5 different categories of food
% Create an imageDataStore to read images
% Please download the categories of objects you want to use
% a good source of data can be found here:
% http://www.vision.ee.ethz.ch/datasets_extra/food-101/

location = 'F:\downloads\TrainData1\TrainData';%Êý¾Ý¼¯Â·¾¶
imds = imageDatastore(location,'IncludeSubfolders',1,...
    'LabelSource','foldernames');
tbl = countEachLabel(imds);


%% Load Pre-trained CNN
% The CNN model is saved in MatConvNet's format [3]. Load the MatConvNet
% network data into |convnet|, a |SeriesNetwork| object from Neural Network
% Toolbox(TM), using the helper function |helperImportMatConvNet|. A
% SeriesNetwork object can be used to inspect the network architecture,
% classify new data, and extract network activations from specific layers.

% Location of pre-trained "AlexNet"
cnnURL = 'http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat';
% Store CNN model in a temporary folder
cnnMatFile = fullfile(tempdir, 'imagenet-caffe-alex.mat');

if ~exist(cnnMatFile, 'file') % download only once
    disp('Downloading pre-trained CNN model...');
    websave(cnnMatFile, cnnURL);
end

net = helperImportMatConvNet(cnnMatFile);

%% Look at structure of pre-trained network
% Notice the last layer performs 1000 object classification
net.Layers

%% Perform net surgery
% The pre-trained layers at the end of the network are designed to classify
% 1000 objects. But we need to classify different objects now. So the
% first step in transfer learning is to replace the last 3 layers of the
% pre-trained network with a set of layers that can classify 5 classes.

% Get the layers from the network. the layers define the network
% architecture and contain the learned weights. Here we only need to keep
% everything except the last 3 layers.
layers = net.Layers(1:end-3);

% %optional, Add new fully connected layer for 2 categories.
layers(end+1) = fullyConnectedLayer(64, 'Name', 'special_2');
layers(end+1) = reluLayer;

% introduce another layer : adding non-linearity 

% improving the network's ability to handle data
% Not enough training 1.2 million (total)

layers(end+1) = fullyConnectedLayer(height(tbl), 'Name', 'fc8_2');

% Add the softmax layer and the classification layer which make up the
% remaining portion of the networks classification layers.
layers(end+1) = softmaxLayer;
layers(end+1) = classificationLayer();

% Modify image layer to add randcrop data augmentation. This increases the
% diversity of training images. The size of the input images is set to the
% original networks input size.
layers(1) = imageInputLayer([227 227 3]);


%% Setup learning rates for fine-tuning
% For fine-tuning, we want to changed the network ever so slightly. How
% much a network is changed during training is controlled by the learning
% rates. Here we do not modify the learning rates of the original layers,
% i.e. the ones before the last 3. The rates for these layers are already
% pretty small so they don't need to be lowered further. You could even
% freeze the weights of these early layers by setting the rates to zero.
%
% Instead we boost the learning rates of the new layers we added, so that
% they change faster than the rest of the network. This way earlier layers
% don't change that much and we quickly learn the weights of the newer
% layer.

% fc 8 - bump up learning rate for last layers
layers(end-2).WeightLearnRateFactor = 10;
layers(end-2).WeightL2Factor = 1;
layers(end-2).BiasLearnRateFactor = 20;
layers(end-2).BiasL2Factor = 0;

% we want the last layer to train faster than the other layers because 
% bias the training proces to quickly improve the last layer and keep the
% other layers relatively unchanged

% could have set the learning rates to 0, but this is faster
% other layers are not getting updated as much

%% Equalize number of images of each class in training set
minSetCount = min(tbl{:,2}); % determine the smallest amount of images in a category
%Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount);

% Notice that each set now has exactly the same number of images.
countEachLabel(imds)
[trainingDS, testDS] = splitEachLabel(imds, 0.7,'randomize');
% Convert labels to categoricals
trainingDS.Labels = categorical(trainingDS.Labels);
trainingDS.ReadFcn = @readFunctionTrain;

% Setup test data for validation
testDS.Labels = categorical(testDS.Labels);
testDS.ReadFcn = @readFunctionValidation;


%% Fine-tune the Network

miniBatchSize = 128; % lower this if your GPU runs out of memory.
numImages = numel(trainingDS.Files);

% Run training for 5000 iterations. Convert 20000 iterations into the
% number of epochs this will be.
maxEpochs = 5; % one complete pass through the training data
% batch size is the number of images it processes at once. Training
% algorithm chunks into manageable sizes. 
lr = 0.001;
opts = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'none',...
    'InitialLearnRate', lr,... 
    'MaxEpochs', maxEpochs, ...
    'MiniBatchSize', miniBatchSize);

net = trainNetwork(trainingDS, layers, opts);
 save('C:\Users\Administrator\trainedNet.mat','net')
 save('C:\Users\Administrator\testDS.mat','testDS')



