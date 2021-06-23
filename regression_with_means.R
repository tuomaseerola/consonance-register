# regression_with_means.R
rm(S,S2)
S2 <- m2 %>%
  dplyr::group_by(Register) %>%
  dplyr::summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE)) %>%
  dplyr::mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 


S2$RegisterNum <-as.numeric(S2$Register)-4

head(S2)
dim(S2)
model.lin <-lm(m ~ poly(RegisterNum,1,raw = TRUE),data=S2)
mo1<-papaja::apa_print(summary(model.lin)) # Radj=0.628, p=0.02061
mo1
mo1$estimate$modelfit$r2_adj
as.character(mo1$estimate$modelfit[1])

model.quad <- lm(m ~ poly(RegisterNum,2,raw = TRUE),data=S2)
mo2<-papaja::apa_print(summary(model.quad)) # Radj = 0.9641, p=0.0005724
mo2
modelfit <-as.character(mo2$estimate$modelfit[1])
modelfit
mo2$estimate$modelfit$r2_adj

anova(model.lin,model.quad)

model.quad2 <- lm(m ~ poly(RegisterNum,3,raw = TRUE),data=S2)
mo3<-papaja::apa_print(summary(model.quad2)) # Radj = 0.9876 , p=0.0008265
mo3
mo3$estimate$modelfit$r2_adj

anova(model.quad,model.quad2)


library(latex2exp)
modelfit
TeX(modelfit)
mfit <-mo3$estimate$modelfit$r2_adj
TeX(mfit)

source('~/Documents/computational/R/theme_fs.R')
custom_theme_size <- theme_fs(12)

fig3<-ggplot(S2,aes(x=RegisterNum,y=m))+
  geom_point(size=3,colour='black')+
  geom_smooth(colour='gray40',alpha=0.5,method = 'lm',formula = y ~ poly(x, 3,raw = TRUE),fullrange=TRUE)+
  scale_x_continuous(breaks = seq(-3,3,by=1),limits = c(-3.1,3.1),expand = c(0,0),labels = c('R1','R2','R3','R4','R5','R6','R7'))+
  scale_y_continuous(breaks = seq(1,9,by=1),limits = c(1,7))+
  ylab('Consonance rating')+
  xlab('Register')+
  annotate("text",x=1,y=4.5,label=TeX(mfit),parse=TRUE,family="serif",size = 4)+
  theme_bw()+
  theme(text=element_text(family="serif"))+
  custom_theme_size

#print(fig3)

#### Summarise across Register and Chords ---------------------

S <- m2 %>%
  dplyr::group_by(Register,Chord) %>%
  dplyr::summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE)) %>%
  dplyr::mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 

S


S$RegisterNum <- as.numeric(S$Register)-4

head(S)

apa_table(x=mo1$table,caption = 'xxx')

model.lin1 <-lm(m ~ poly(RegisterNum,1) * Chord,data=S)
summary(model.lin1)

model.lin2 <-lm(m ~ poly(RegisterNum,2) * Chord,data=S)
summary(model.lin2)

model.lin3 <-lm(m ~ poly(RegisterNum,3) * Chord,data=S)
summary(model.lin3)

anova(model.lin1,model.lin2)

anova(model.lin2,model.lin3)


S$RegisterNum <- as.numeric(S$Register)-4

S$x<-S$m
S$y<-S$RegisterNum


# build separate models
chord1model <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='3-11B'))
chord1fit <- papaja::apa_print(summary(chord1model)) # Radj = 0.9641, p=0.0005724
mfit1 <-as.character(chord1fit$estimate$modelfit$r2_adj)

chord1model_c <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='3-11B'))
anova(chord1model,chord1model_c) # ns p0.03664

chord2model <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='3-7A'))
chord2fit <- papaja::apa_print(summary(chord2model)) # Radj = 0.9641, p=0.0005724
mfit2 <-as.character(chord2fit$estimate$modelfit$r2_adj)

chord2model_c <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='3-7A'))
anova(chord2model,chord2model_c) # p 0.247

chord3model <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='4-19A'))
chord3fit <- papaja::apa_print(summary(chord3model)) # Radj = 0.9641, p=0.0005724
mfit3 <-as.character(chord3fit$estimate$modelfit$r2_adj)

chord3model_c <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='4-19A'))
anova(chord3model,chord3model_c) # p=0.5786

chord4model <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='4-20'))
chord4fit <- papaja::apa_print(summary(chord4model)) # Radj = 0.9641, p=0.0005724
mfit4 <-as.character(chord4fit$estimate$modelfit$r2_adj)
#mfit4 <-as.character(chord4fit$estimate$modelfit$r2)

chord4model_c <-lm(m ~ poly(as.numeric(Register),3),data=dplyr::filter(S,Chord=='4-20'))
anova(chord4model,chord4model_c) # p=0.5434

#mfit4 <- as.character(chord4fit$full_result$modelfit$r2)


fig4 <- ggplot(S,aes(x=RegisterNum,y=m,colour=Chord,fill=Chord,shape=Chord,linetype=Chord))+
  geom_point(size=4)+
  geom_smooth(method='lm',formula = y ~ poly(x, 3,raw = TRUE),se = FALSE)+
#  scale_x_continuous(breaks = seq(-3,3,by=1),labels = c('R1','R2','R3','R4','R5','R6','R7'))+
  scale_x_continuous(breaks = seq(-3,3,by=1),limits = c(-3.1,3.1),expand = c(0,0),labels = c('R1','R2','R3','R4','R5','R6','R7'))+
  scale_y_continuous(breaks = seq(1,9,by=1),limits = c(1,9))+
  scale_colour_grey(start = 0.0,end = 0.2,name='Chord')+
  scale_fill_grey(start = 0.0,end = 0.8,name='Chord')+
  scale_shape_manual(values = c(22,23,24,25),name='Chord')+
  scale_linetype(name='Chord')+
  ylab('Consonance rating')+
  xlab('Register')+
  annotate("text",x=2.4,y=8.15,label=TeX(mfit1),parse=TRUE,family="serif",size = 4)+
  annotate("text",x=2.4,y=6.9,label=TeX(mfit2),parse=TRUE,family="serif",size = 4)+
  annotate("text",x=2.4,y=5.7,label=TeX(mfit3),parse=TRUE,family="serif",size = 4)+
  annotate("text",x=2.4,y=4.0,label=TeX(mfit4),parse=TRUE,family="serif",size = 4)+
  theme_bw()+
  labs(fill  = "Chord", linetype = "Chord", shape = "Chord",colour="Chord")+
  theme(legend.justification=c(0,1), legend.position=c(0.025,.85))+
  theme(legend.background=element_blank())+
  theme(text=element_text(family="serif"))+
  custom_theme_size

#fig4

library("cowplot")
G <- plot_grid(fig3,fig4,labels = c("A", "B"), ncol = 1, nrow = 2)
#print(G)

