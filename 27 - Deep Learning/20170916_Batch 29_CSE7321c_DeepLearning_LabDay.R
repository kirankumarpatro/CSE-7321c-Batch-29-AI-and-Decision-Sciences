# Remove environment variables
rm(list=ls(all=T))

#working directory
setwd("")

#Importing data
data<-read.csv("germandata.csv",header=F)
head(data)

#Creating train, test data sets
set.seed(123)
trainrows = sample(1:nrow(data),round(0.7*nrow(data)))
train<-data[trainrows,]
test<-data[-trainrows,]

# Load h2o library
library(h2o)

# Initiate h2o process - can assign ip/port/max_mem_size(ram size)/
# nthreads(no. of processor cores; 2-2core;-1 -all cores available)
h2o.init(ip='localhost', port = 54321, max_mem_size = '1g',nthreads = 1)

#Converting R object to an H2O Object
# train.hex <- as.h2o(localh2o, object = train, key = "train.hex")
# test.hex <- as.h2o(localh2o, object = test, key = "test.hex")

train.hex <- as.h2o(train, destination_frame = "train.hex")
test.hex <- as.h2o(test, destination_frame = "test.hex")

#To extract features using autoencoder method
aec <- h2o.deeplearning(x = setdiff(colnames(train.hex), "V21"), 
                        # y = "V21",
                        training_frame = train.hex,
                        autoencoder = T, activation = "RectifierWithDropout", 
                        hidden = c(50),
                        epochs = 100, l1 = 0.01)

# 0.5-0.8 retention (dropout 0.2 to 0.5) allowed to extract features
#Adding features to train and test data sets
# Extract features from train data
features_train <- as.data.frame(h2o.deepfeatures(aec,train.hex[,-21],layer = 1))
# Extract features from test data
features_test <- as.data.frame(h2o.deepfeatures(aec,test.hex[,-21],layer = 1))

# add extracted features with original data to train the model
train <- data.frame(train,features_train)
test <- data.frame(test,features_test)

#Converting new R object(incles features) to an H2O Object
train.hex <- as.h2o(train, destination_frame = "train.hex")
test.hex <- as.h2o(test, destination_frame = "test.hex")

#DeepLearning Model Implementation
model = h2o.deeplearning(x = setdiff(colnames(train.hex), "V21"), 
                         y = "V21",
                         training_frame = train.hex, 
                         # activation =  "Tanh", 
                         hidden = c(10, 10, 10),
                         activation = "RectifierWithDropout",
                         input_dropout_ratio = 0.1, 
                         epochs = 100,seed=123)
# 0.8 0.9 retention allowed for DeepLearning

# Predictions and accuracy check
# makes prediction on test data
prediction = h2o.predict(model, newdata = test.hex)
# Convert prediction from h2o object to R object/dataframe
pred = as.data.frame(prediction)

# Confusion Matrix
a = table(test$V21, pred$predict)

h2o.shutdown(F)
