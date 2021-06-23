# contents
library(dplyr)
library(tidyr)
library(ggplot2)

d <- read.csv('data/data.csv',sep = ",",header=TRUE)
dim(d)
df <-d %>% dplyr::filter(!is.na(repeated_items2.1))
n<-names(df)
n
n[35:62]
m<-pivot_longer(df,n[35:62],names_to = 'Stimuli',values_to = 'Rating')

m2<-dplyr::select(m,!starts_with("repea"))
head(m2)
library(stringr)
table(m2$Stimuli)

m2$Chord<-NA
m2$Chord[str_detect(m2$Stimuli,'1R')]<-'3-11B'
m2$Chord[str_detect(m2$Stimuli,'2R')]<-'3-7A'
m2$Chord[str_detect(m2$Stimuli,'3R')]<-'4-20'
m2$Chord[str_detect(m2$Stimuli,'4R')]<-'4-19A'

m2$Chord

m2$Register<-NA
m2$Register[str_detect(m2$Stimuli,'R0') ]<-0
m2$Register[str_detect(m2$Stimuli,'Rd1')]<- -1
m2$Register[str_detect(m2$Stimuli,'Rd2')]<- -2
m2$Register[str_detect(m2$Stimuli,'Rd3')]<- -3 
m2$Register[str_detect(m2$Stimuli,'Ru1')]<- +1
m2$Register[str_detect(m2$Stimuli,'Ru2')]<- +2 
m2$Register[str_detect(m2$Stimuli,'Ru3')]<- +3

m2$Register

m2$Register<-factor(m2$Register,levels = c('-3','-2','-1','0','1','2','3'))
m2$Register
m2$Chord <-factor(m2$Chord)
head(m2)

m2$Register

#### Summarise -------

S <- m2 %>%
  dplyr::group_by(Register,Chord) %>%
  dplyr::summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE)) %>%
  dplyr::mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 
S

source('~/Documents/computational/R/theme_fs.R')
custom_theme_size <- theme_fs(12)
library(RColorBrewer)
pal<-brewer.pal(3, name="Set1")

S
pd<-position_dodge(.3)
g1 <- ggplot(S,aes(x=Register,y=m,colour=Chord,group=Chord))+
  geom_point(position = pd,size=4,shape=22)+
  geom_line(position = pd)+
  geom_errorbar(aes(x=Register,ymin=LCI,ymax=UCI,colour=Chord), width=0.50,position = pd,show.legend = FALSE)+
#  geom_col(position = pd,show.legend = TRUE,colour='black')+
  scale_fill_brewer(type = 'qual', palette = 'Set1',name="Chord")+
  ylab('Consonance')+
  ylab('Register')+
  theme_bw()
g1

##
library(lme4)
library(lmerTest)

head(m2)

m1 <- lmer(Rating ~ Chord * Register + (1|participant),data=m2)
summary(m1)
m1num <- lmer(Rating ~ as.numeric(Chord) * as.numeric(Register) + activemusician.1 + (1|participant),data=m2)
summary(m1num,correlation=FALSE)

m1num2 <- lmer(Rating ~ as.numeric(Chord) * as.numeric(Register) + activemusician.1 + activemusician.1:as.numeric(Chord) + activemusician.1:as.numeric(Register) + (1|participant),data=m2)
summary(m1num2,correlation=FALSE)

m1num2 <- lmer(Rating ~ as.numeric(Chord) * as.numeric(Register) * factor(activemusician.1) + (1|participant),data=m2)
summary(m1num2,correlation=FALSE)

m1num2 <- lmer(Rating ~ Chord * Register * factor(activemusician.1) + (1|participant),data=m2)
summary(m1num2,correlation=FALSE)


m2$activemusician.1 

S$n
tail(S)

#### Regression of mean -------------

S2 <- m2 %>%
  dplyr::group_by(Register) %>%
  dplyr::summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE)) %>%
  dplyr::mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 
S2


S2$RegisterNum <-as.numeric(S2$Register)-4
S2$RegisterNum

g2<-ggplot(S2,aes(x=RegisterNum,y=m))+
  geom_point()+
  geom_smooth()+
  scale_x_continuous(breaks = seq(-3,3,by=1))+
  ylab('Consonance rating')+
  xlab('Register')+
  theme_bw()
print(g2)

S2

model.lin <-lm(m ~ RegisterNum,data=S2)
summary(model.lin) # Radj=0.628, p=0.02061

model.quad <- lm(m ~ poly(RegisterNum,2),data=S2)
summary(model.quad) # Radj = 0.9641, p=0.0005724

model.quad2 <- lm(m ~ poly(RegisterNum,3),data=S2)
summary(model.quad2) # Radj = 0.9876 , p=0.0008265

head(S)
model.lin2 <-lm(m ~ poly(as.numeric(Register),2) * Chord,data=S)
summary(model.lin2)

head(S)

S$RegisterNum <- as.numeric(S$Register)-4
S
S$x<-S$m
S$y<-S$RegisterNum

g3 <- ggplot(S,aes(x=RegisterNum,y=m,colour=Chord))+
  geom_point(size=4)+
#  geom_smooth(method='lm',formula = y ~ poly(x, 3,raw = TRUE),se = FALSE)+
  geom_smooth(se = FALSE,method='loess')+
  scale_x_continuous(breaks = seq(-3,3,by=1))+
  ylab('Consonance rating')+
  xlab('Register')+
  theme_bw()

print(g3)

g4 <- ggplot(S,aes(x=RegisterNum,y=m,colour=Chord))+
  geom_point(size=4)+
  geom_smooth(method='lm',formula = y ~ poly(x, 3,raw = TRUE),se = FALSE)+
#  geom_smooth(se = FALSE,method='loess')+
  scale_x_continuous(breaks = seq(-3,3,by=1))+
  ylab('Consonance rating')+
  xlab('Register')+
  theme_bw()

print(g4)

