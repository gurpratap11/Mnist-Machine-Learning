library(keras)
mnist <-dataset_mnist()
str(mnist)

trainx <- mnist$train$x
trainy <- mnist$train$y
testx <- mnist$test$x
testy <- mnist$test$y

table(mnist$train$y, mnist$train$y)
table(mnist$test$y, mnist$test$y)

#plot images
par(mfrow = c(3,3))
for( i in 1:9) plot(as.raster(trainx[i,,], max = 255))
par(mfrow = c(1,1))
trainx[1,,]

# Reshape and rescale
trainx <- array_reshape(trainx, c(nrow(trainx), 784))
testx <- array_reshape(testx, c(nrow(testx), 784))
trainx <- trainx /255
testx <- testx / 255
hist(trainx[1,])

# one hot ending
trainy <- to_categorical(trainy, 10)
testy <- to_categorical(testy, 10)
head(trainy) 

# model
model <- keras_model_sequential()
model %>% 
  layer_dense(units = 512, activation = 'relu',input_shape = c(784)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 256, activation = 'relu') %>% 
  layer_dropout(rate = 0.3) %>% 
  layer_dense(units = 10, activation = 'softmax')

# compile
model %>%
  compile(loss = 'categorical_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics = 'accuracy')

# fit model
history <- model %>% 
  fit(trainx,
      trainy,
      epochs = 30,
      batch_size = 32,
      validation_split = 0.2)
plot(history)


library(EBImage)
setwd("C:/Users/hp/Documents/Downloads")
temp = list.files(pattern = "*.jpg")
mypic <- list()
for( i in 1:length(temp)) {mypic[[i]] <- readImage(temp[[i]])}

par(mfrow = c(3,2))
for(i in 1:length(temp)) plot(mypic[[i]])
str(mypic)

for(i in 1:length(temp)) {colorMode(mypic[[i]])<-Grayscale}
for(i in 1:length(temp)) {mypic[[i]]<- resize(mypic[[i]],28,28)}
for(i in 1:length(temp)) {mypic[[i]] <- array_reshape(mypic[[i]], c(28,28,3))}
new <- NULL
for(i in 1:length(temp)) {new <- rbind(new, mypic[[i]])}
newx <- new[,1:784]
new <-  c(7,5,2,0,5,3)

#Prediction
pred <-model %>% predict_classes(newx) 
table(Predict = pred, Actual = newy)
