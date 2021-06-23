# regression_acoustic.R 
S$RegisterNum <- as.numeric(S$Register)-4

#### acoustic predictors
a <- read.csv('roughness_and_sharpness.csv',header = TRUE)
a$RegisterNum<-a$Register-4
a$Chord <- factor(a$StimulusName)
SM <- merge(S,a,by = c('RegisterNum','Chord'))# bind
SM <- dplyr::arrange(SM,RegisterNum,Chord)

model1.lin <-lm(m ~ Roughness + Harmonicity + Familiarity + Sharpness, data=SM)
#summary(model1.lin)

model2.lin <-lm(m ~ Roughness+ Familiarity + Sharpness, data=SM)
model2.lin <-lm(m ~ Roughness + Sharpness, data=SM)
summary(model2.lin)
model2.quad <-lm(m ~ poly(Roughness,2,raw = TRUE) + Sharpness, data=SM)
summary(model2.quad)
acoust_lm <- papaja::apa_print(summary(model2.quad))
#print(acoust_lm)
anova(model2.lin,model2.quad)

acoust_lm <- papaja::apa_print(summary(model2.lin))
#print(acoust_lm)
acoust_lm$full_result$modelfit
papaja::apa_table(
  acoust_lm$table
  , caption = "A full regression table."
)
#
#`r acoustic_features$full_result`

#### Partial correlations
library(ppcor)
p1 <- spcor.test(SM$m,SM$Roughness,SM[,c("Sharpness")]) # -0.852
p2 <- spcor.test(SM$m,SM$Sharpness,SM[,c("Roughness")]) # -0.226
print(knitr::kable(p1,caption = 'Semi partial correlation between Consonance and Roughness (Sharpness partialled out)'))
print(knitr::kable(p2,caption = 'Semi partial correlation between Consonance and Sharpness (Roughness partialled out)'))


#r <-lm(m ~ Roughness, data=SM)
#summary(r)
#r <-lm(m ~ Sharpness, data=SM)
#summary(r)
