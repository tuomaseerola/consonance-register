# LMMs_extra.R
library(lme4)
#library(lmerTest)
library(emmeans)

# Reviewer suggestion
m3$Familiarity <- 'NA'
m3$Familiarity[m3$Chord=='3-11B']<-"FHigh"
m3$Familiarity[m3$Chord=='3-7A']<-"FLow"
m3$Familiarity[m3$Chord=='4-20']<-"FHigh"
m3$Familiarity[m3$Chord=='4-19A']<-"FLow"

m3$Roughness <- 'NA'
m3$Roughness[m3$Chord=='3-11B']<-"RLow"
m3$Roughness[m3$Chord=='3-7A']<-"RLow"
m3$Roughness[m3$Chord=='4-20']<-"RHigh"
m3$Roughness[m3$Chord=='4-19A']<-"RHigh"
#table(m3$Roughness,m3$Familiarity)

m1extra <- lmer(Rating ~ Familiarity * Roughness + (1|participant),data=m3)
#print(summary(m1extra,corr=FALSE))

R <- emmeans(m1extra, specs = pairwise ~ Familiarity*Roughness,adjust='Tukey')
print(knitr::kable(R$emmeans,digits = 2)) #

#### Musical expertise

m3$MusicalExpertise<-factor(m3$OMSI.1,levels = 1:5,labels = c('Non-musician','Non-musician','Musician','Musician','Musician'))
#print(table(m3$OMSI.1)/28)
print(knitr::kable(table(m3$MusicalExpertise)/28,caption = 'Musical Expertise'))

m1expertise <- lmer(Rating ~ as.numeric(Chord) * as.numeric(Register) * MusicalExpertise + (1|participant),data=m3)
s<-summary(m1expertise,corr=FALSE)
print(knitr::kable(s$coefficients,digits = 2))

m1expertise <- lmer(Rating ~ Chord * Register * MusicalExpertise + (1|participant),data=m3)
Expertise_Register <- emmeans(m1expertise, specs = pairwise ~ MusicalExpertise | Register, adjust='Tukey')
print(knitr::kable(Expertise_Register$emmeans,digits = 2)) #
Expertise_Chord <- emmeans(m1expertise, specs = pairwise ~ MusicalExpertise | Chord, adjust='Tukey')
print(knitr::kable(Expertise_Chord$emmeans,digits = 2)) #
