# LMMs.R
library(lme4)
library(lmerTest)

m3 <- m2
#m3$Chord <- factor(m3$Chord,levels = c("3-11B","3-7A","4-19A","4-20"),labels = c("High Cons.","High Cons.","Low Cons.","Low Cons."))
m3$Chord <- factor(m3$Chord,levels = c("3-11B","3-7A","4-20","4-19A"))
m3$Chord <- as.numeric(m3$Chord) # This is coded as a linear factor with decreasing levels of consonance
m3$Register <- as.numeric(m3$Register)
m3$Expertise <- factor(m2$activemusician.1,levels = c(1,2),labels = c('Non-Mus.','Mus.'))

table(m3$Chord)
table(m3$Register)
table(m3$Expertise)
m1num2 <- lmer(Rating ~ Chord * Register + (1|participant),data=m3)
#m1num2 <- lmer(Rating ~ Chord * Register * Expertise + (1|participant),data=m3)
summary(m1num2,corr=FALSE)
#lmm_table <- apa_print(m1num2)
