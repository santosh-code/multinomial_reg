library(readr)
library(plyr)
install.packages("fastDummies")
library(fastDummies)
prgrm<-read.csv(file.choose())
View(prgrm)
colnames(prgrm)
colnames(prgrm)<-c("X","id","gender","ses","schtyp","prog","read","write","math","science","honors")
dum_gender<-as.data.frame(dummy_cols(prgrm$gender))
dum_ses<-as.data.frame(dummy_cols(prgrm$ses))
dum_schtyp<-as.data.frame(dummy_cols(prgrm$schtyp))
dum_honor<-as.data.frame(dummy_cols(prgrm$honors))
prgrm1<-cbind(prgrm,dum_gender,dum_ses,dum_schtyp,dum_honor)
colnames(prgrm1)
final<-prgrm1[,-c(1,2,3,4,5,11,12,15,19,22,16)]
model<-multinom(prog~.,data = final)
summary(model)
###p-value
z <- summary(model)$coefficients / summary(model)$standard.errors
p_value <- (1-pnorm(abs(z),0,1))*2

summary(model)$coefficients
p_value

exp(coef(model))
#########prob###
prob <- fitted(model)
prob
##########
class(prob)
prob <- data.frame(prob)
View(prob)
prob["pred"] <- NULL

# Custom function that returns the predicted value based on probability
get_names <- function(i){
  return (names(which.max(i)))
}

pred_name <- apply(prob,1,get_names)
prob$pred <- pred_name
View(prob)
table(pred_name,prgrm1$prog)
############plot
barplot(table(pred_name,prgrm1$prog),beside = T,col=c("red","lightgreen","blue","orange"),legend=c("bus","car","carpool","rail"),main = "Predicted(X-axis) - Legends(Actual)",ylab ="count")
mean(pred_name==prgrm1$prog)
####accuracy=0.62