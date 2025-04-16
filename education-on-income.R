library(dplyr)
library(car)
library(DoubleML)
library(mlr3)
library(mlr3learners)
library(data.table)
library(ggplot2)
library(splines)

setwd("/Users/mekaadegbola/Desktop/Data Sci Applications")

#question2
data<-read.csv("zaid2010.csv")

data2 <- data %>% filter(!income %in% c(-1, -2,-3, -4, -5))
data2<-data2 %>% filter(!family.income %in% c(-1, -2,-3, -4, -5))
data2<-data2 %>% filter(!degree %in% c(-1, -2,-3, -4, -5))

library(psych)
describe(data2)

data2 <- data2 %>%
  mutate(degree = ifelse(degree <= 3, 0, 1))

#data2 <- data2 %>%
 # mutate(degree = as.factor(degree))

data2<-data2 %>% filter(!father.grade %in% c(-1, -2,-3, -4, -5))
data2<-data2 %>% filter(!mother.grade %in% c(-1, -2,-3, -4, -5))
data2<-data2 %>% filter(!gpa %in% c(-1, -2,-3, -4, -5))
data2<-data2 %>% filter(!age %in% c(-1, -2,-3, -4, -5))

data2<-data2 %>% filter(!piat %in% c(-1, -2,-3, -4, -5))


# test<-lm(income~degree+family.income+gpa+age+res.grade+father.grade+mother.grade+siblings+sex+gross.income+piat+month+year+hh.size+sex+under18, data=data2)
# summary(test)
# vif(lm(income~degree+family.inc+father.grade+mother.grade+gpa+age+siblings+race+piat.perc+sex, data=data2))
# vif(test)
# 
# test<-lm(income~degree+family.inc+gpa+age+piat.perc+sex, data=data2)
# summary(test)
# 
# test<-lm(income~degree, data=data2)
# summary(test)


model1<-lm(income~degree, data=data2)
summary(model1)

model2<-lm(income~degree+family.income+gpa+age+res.grade+father.grade+mother.grade+siblings+sex+gross.income+piat+month+year+hh.size+sex+under18, data=data2)
summary(model2)

model3<-lm(income~degree+bs(family.income, degree=2, df=8)+poly(gpa,2)+poly(age,2)+poly(res.grade,2)+poly(father.grade,2)+poly(mother.grade,2)+poly(siblings,2)+poly(sex,1.5)+poly(gross.income,3)+poly(piat,2)+month+year+poly(hh.size,3, raw=TRUE)+poly(under18,3, raw=TRUE), data=data2)
summary(model3)



formula_flex = formula(" ~ -1+ bs(family.income, degree=2, df=8)+
                       poly(gpa,2)+
                       poly(age,2)+
                       poly(res.grade,2)+
                       poly(father.grade,2)+
                       poly(mother.grade,2)+
                       poly(siblings,2)+
                       poly(sex,1.5)+
                       poly(gross.income,3)+
                       poly(piat,2)+
                       month+year+
                       poly(hh.size,3)+
                       poly(under18,3)")

features_flex = data.frame(model.matrix(formula_flex, data2))

model_data = data.table("income" = data2$income,
                       "degree" = data2$degree,
                       features_flex)
# Initialize DoubleMLData (data-backend of DoubleML)
data_dml_flex = DoubleMLData$new(model_data,
                                 y_col = "income",
                                 d_cols = "degree")

data_dml_flex


set.seed(123)
lasso = lrn("regr.cv_glmnet", alpha=1, nfolds = 10, s = "lambda.min")
lasso_class = lrn("classif.cv_glmnet", alpha=1, nfolds = 10, s = "lambda.min")


# Initialize DoubleMLPLR model
dml_plr_lasso = DoubleMLPLR$new(data_dml_flex,
                                ml_l = lasso,
                                ml_m = lasso_class,
                                n_folds = 5)
dml_plr_lasso$fit()
dml_plr_lasso$summary()



# Random Forest
randomForest = lrn("regr.ranger", max.depth = 7,
                   mtry = 4, min.node.size = 5)
randomForest_class = lrn("classif.ranger", max.depth = 7,
                         mtry = 4, min.node.size = 5)

set.seed(123)
dml_plr_forest = DoubleMLPLR$new(data_dml_flex,
                                 ml_l = randomForest,
                                 ml_m = randomForest_class,
                                 n_folds = 5)

dml_plr_forest$fit()
dml_plr_forest$summary()

library(dagitty)
DAG = dagitty("dag{ 
                  degree->income}")
plot(DAG)
adjustmentSets(DAG, exposure="degree", outcome="income") 


### Age pie chart
data2 <- data2 %>%
  mutate(dummy_age = case_when(
    age >= 26 & age <= 27 ~ 1,  # Ages 26-27 → Dummy 1
    age >= 27 & age <= 28 ~ 2,  # Ages 27-28 → Dummy 2
    age >= 29 & age <= 31 ~ 3,  # Ages 29-31 → Dummy 3
    TRUE ~ 0  # All other ages → 0 (optional)
  ))

data2=data2 %>% 
  mutate(dummy_income = case_when(
    income >= 0 & income <= 30000 ~ 1,
    income >= 30001 & income <= 60000 ~ 2,
    income >= 60001 & income <= 150000 ~ 3,
    TRUE~0
  ))  

frame = data.frame(y=dummy_income, x=dummy_age)
library(ggplot2)

ggplot(frame, aes(x="", y=dummy_income, fill=dummy_age))+
  geom_bar(stat="identity", width=1)+
  coord_polar(theta="y")+
  labs(title="Age Distribution")+
  theme_void()




