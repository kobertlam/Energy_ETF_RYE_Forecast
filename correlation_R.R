library(tidyverse)

install.packages("ggpubr")
library(ggpubr)

head(Data_Consolidated)

colnames(Data_Consolidated)[colnames(Data_Consolidated) == 'Close'] <- 'RYE_Close'

plt <- ggplot(Data_Consolidated,aes(x=RYE_Close,y=Oil_Close))
plt + geom_point()

cor(Data_Consolidated$RYE_Close,Data_Consolidated$Oil_Close)

lm(Oil_Close ~ RYE_Close, Data_Consolidated)

summary(lm(Oil_Close ~ RYE_Close, Data_Consolidated))

model <- lm(Oil_Close ~ RYE_Close, Data_Consolidated) #create linear model
yvals <- model$coefficients['RYE_Close']*Data_Consolidated$RYE_Close + model$coefficients['(Intercept)'] #determine y-axis values from linear model

plt <- ggplot(Data_Consolidated,aes(x=RYE_Close,y=Oil_Close)) #import dataset into ggplot2
plt + geom_point() + geom_line(aes(y=yvals), color = "red") #plot scatter and linear model

sp <- ggscatter(Data_Consolidated, x = "RYE_Close", y = "Oil_Close",
                add = "reg.line",  # Add regressin line
                add.params = list(color = "red", fill = "lightgray"), # Customize reg. line
                conf.int = TRUE # Add confidence interval
)
sp + stat_cor(aes(label = ..r.label..), label.x = 3)
