# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np
import pandas
from nltk.corpus import stopwords
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.utils.np_utils import to_categorical
from sklearn.model_selection import train_test_split

from keras.layers import Embedding
from keras.layers import Dense, Input, Flatten, LSTM, Dropout,Activation
from keras.layers import Conv1D, MaxPooling1D, Embedding, Merge, Dropout,Convolution2D, MaxPooling2D, AveragePooling2D, ZeroPadding2D, Flatten
from keras.models import Model
from keras.models import Sequential 


data=pandas.read_csv("E:\\INSOFE\\Cute 4\\data.csv")

#data.drop(['fileid'],axis=1,inplace=True)

data['converse'] = data['converse'].astype('str')

MAX_SEQUENCE_LENGTH = 529
MAX_NB_WORDS = 20000
EMBEDDING_DIM = 100
VALIDATION_SPLIT = 0.2

datalenth=len(data)

##Write a function to clean the conversations
def clean_converse(raw_converse):
    #Convert the words to lower and split
    words = raw_converse.lower().split()
    #Stopwords
    stop = set(stopwords.words('english'))
    #Remove stop words
    words = [w for w in words if w not in stop]
    #Get the cleaned review
    return(" ".join(words))


count=0
texts=[]
labels=[]

while(count<=datalenth-1):
    #print(count)
    if((data['converse'][count])=='nan'):
        data=data.drop(data.fileid[count])
    else:
        texts.append(clean_converse(data.converse[count].encode('ascii','ignore')))
        labels.append(data.categories[count])
        
        #count=count+1
        #datalenth-1
    count=count+1
    
    
tokenizer = Tokenizer(20000)
tokenizer.fit_on_texts(texts)
sequences = tokenizer.texts_to_sequences(texts)

word_index = tokenizer.word_index
print('Found %s unique tokens.' % len(word_index))

data_pad = pad_sequences(sequences, maxlen=MAX_SEQUENCE_LENGTH)

labels = pandas.Categorical(labels)

labels.codes

labels = to_categorical(np.asarray(labels.codes))
#model = Word2Vec(sentences, size=100, window=5, min_count=5, workers=4)

x_train_1d,x_test_1d,y_train,y_test = train_test_split(data_pad,labels,test_size = 0.2)

x_train = [[] for row in range(x_train_1d.shape[0])]

for i in range(x_train_1d.shape[0]):
    x_train[i] = x_train_1d[i].reshape(1,23,23)
    
x_train = np.asarray(x_train)
print x_train.shape

x_test = [[] for row in range(x_test_1d.shape[0])]

for i in range(x_test_1d.shape[0]):
    x_test[i] = x_test_1d[i].reshape(1,23,23)

x_test = np.asarray(x_test)
print x_test.shape
   
model = Sequential()
model.add(Convolution2D(20, 3, 1, activation='relu', input_shape=(1,23,23)))
model.add(MaxPooling2D(pool_size=(2,2)))

model.add(Convolution2D(10, 3, 1, activation='relu'))
model.add(MaxPooling2D(pool_size=(2,2)))

model.add(Flatten())
#model.add(Dropout(0.2))

model.add(Dense(128, init='uniform', activation='relu'))
#model.add(Dropout(0.4))

model.add(Dense(6, activation='softmax'))
model.compile(loss = "categorical_crossentropy",
              optimizer = 'Adam',
              metrics = ['accuracy'])
print(model.summary())
       
       
model.fit(x_train, y_train, nb_epoch=15, batch_size=128)

score = model.evaluate(x_test, y_test)
print score[1]*100

