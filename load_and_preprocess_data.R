# load_and_preprocess_data
verbose<-FALSE
if(verbose==TRUE){
  print('load and preprocess data')
}
library(dplyr)
library(tidyr)
#### Read data ----------------------------
d <- read.csv('data/data.csv',sep = ",",header=TRUE)
dim(d)

#### Headphone check fails?
HeadPhoneCheckFails <- d$check.1[d$check.1<4]
if(verbose==TRUE){
  print(paste('Headphone check Fails:',length(HeadPhoneCheckFails)))
}
d<-d[which(!d$check.1<4),]

#### Quality check 1: Eliminate non responders
QC1 <- is.na(d$repeated_items2.1)
if(verbose==TRUE){
  print(paste('Quality Criteria 1 Fails:',sum(QC1)))
}
df <-d %>% dplyr::filter(!is.na(repeated_items2.1))
#### Quality check 2: Repeated items
repeated_items <- pivot_longer(df,c('repeated_items1.1','repeated_items2.1','repeated_items3.1'),names_to = 'Repeated_items',values_to = 'Difference')

tmp<-data.frame(PID=repeated_items$participant,Error=repeated_items$Difference,Item=repeated_items$Repeated_items)
tmp$Item<-factor(tmp$Item)
tmp$PID<-factor(tmp$PID)

S <- dplyr::summarise(group_by(tmp,PID),ErrorMean=mean(abs(Error)))

if(verbose==TRUE){
  print(paste('M=',round(mean(S$ErrorMean),2),'SD=',round(sd(S$ErrorMean),2)))
}
QC2 <- S$ErrorMean >= 4

if(verbose==TRUE){
  print(paste('Quality Criteria 2 Fails:',sum(QC2)))
}
df <- dplyr::filter(df,participant!=as.character(S$PID[QC2]))

#### Quality check 3: Correlation
n <- names(df)
m <- tidyr::pivot_longer(df,n[35:62],names_to = 'Stimuli',values_to = 'Rating')
rat <- df[35:62]
rat2<-t(rat)
colnames(rat2)<-paste0('S',1:ncol(rat2))
a <- suppressWarnings(suppressMessages(psych::alpha(rat2,warnings = FALSE)))
#a$item.stats
QC3 <- a$item.stats$raw.r < 0
if(verbose==TRUE){
  print(paste('Quality Criteria 3 Fails:',sum(QC3)))
}
df <- df[!QC3,]

# 5 dropped in total. 

#### Actual analysis ---------------------------------------
library(stringr)
m2 <- dplyr::select(m,!starts_with("repea"))
#table(m2$Stimuli)

m2$Chord<-NA
m2$Chord[str_detect(m2$Stimuli,'1R')]<-'3-11B'
m2$Chord[str_detect(m2$Stimuli,'2R')]<-'3-7A'
m2$Chord[str_detect(m2$Stimuli,'3R')]<-'4-20'
m2$Chord[str_detect(m2$Stimuli,'4R')]<-'4-19A'

m2$Register<-NA
m2$Register[str_detect(m2$Stimuli,'R0') ]<-0
m2$Register[str_detect(m2$Stimuli,'Rd1')]<- -1
m2$Register[str_detect(m2$Stimuli,'Rd2')]<- -2
m2$Register[str_detect(m2$Stimuli,'Rd3')]<- -3 
m2$Register[str_detect(m2$Stimuli,'Ru1')]<- +1
m2$Register[str_detect(m2$Stimuli,'Ru2')]<- +2 
m2$Register[str_detect(m2$Stimuli,'Ru3')]<- +3

m2$Register<-factor(m2$Register,levels = c('-3','-2','-1','0','1','2','3'))
m2$Chord <-factor(m2$Chord)
