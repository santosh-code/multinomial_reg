import pandas as pd
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
prgm=pd.read_csv("C:/Users/USER/Desktop/multinomial_reg/mdata.csv")
drp_prgm=prgm.drop(['Unnamed: 0','id'],axis='columns')
drp_prgm.columns="prog","ses","schtyp","gender","read","write","math","science","honors"
c = drp_prgm.columns
drp_prgm[[c[0], c[3]]] = drp_prgm[[c[3], c[0]]]
dum1=pd.get_dummies(drp_prgm.honors)
dum2=pd.get_dummies(drp_prgm.gender)
dum3=pd.get_dummies(drp_prgm.ses)
dum4=pd.get_dummies(drp_prgm.schtyp)
merged=pd.concat([drp_prgm,dum1,dum2,dum3,dum4],axis='columns')
merged.columns
final=merged.drop(['ses','schtyp','gender','honors','middle'],axis='columns')

train,test = train_test_split(final,test_size = 0.2)
model = LogisticRegression(multi_class="multinomial",solver="newton-cg").fit(train.iloc[:,1:],train.iloc[:,0])


train_predict = model.predict(train.iloc[:,1:]) # Train predictions 
test_predict = model.predict(test.iloc[:,1:])

accuracy_score(train.iloc[:,0],train_predict) # 69.8%
# Test accuracy 
accuracy_score(test.iloc[:,0],test_predict) # 67.032%



