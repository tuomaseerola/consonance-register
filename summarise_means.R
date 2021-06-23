# summarise_means.R

S <- m2 %>%
  dplyr::group_by(Register,Chord) %>%
  dplyr::summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE)) %>%
  dplyr::mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 

S

source('~/Documents/computational/R/theme_fs.R')
custom_theme_size <- theme_fs(12)
library(RColorBrewer)
pal<-brewer.pal(3, name="Set1")

pd<-position_dodge(.6)
g1 <- ggplot(S,aes(x=Register,y=m,colour=Chord,group=Chord,fill=Chord,shape=Chord))+
  geom_point(position = pd,size=4)+
  geom_line(position = pd)+
  geom_errorbar(aes(x=Register,ymin=LCI,ymax=UCI,colour=Chord), width=0.50,position = pd,show.legend = FALSE)+
  ylab('Consonance')+
  xlab('Register')+
  scale_linetype(name='Chords')+
  scale_color_grey(start = 0.0,end = 0.2,name='Chords')+
  scale_fill_grey(start = 0.0,end = 0.8,name='Chords')+
  scale_shape_manual(values = c(22,23,24,25),name='Chords')+
  scale_x_discrete(breaks = -3:3,labels = c('R1','R2','R3','R4','R5','R6','R7'))+
  theme_bw()+
  scale_y_continuous(breaks = 1:9,limits = c(1,9))+
  labs(fill  = "Chord", linetype = "Chord", shape = "Chord",color="Chord")+
  theme(text=element_text(family="serif"))
print(g1)
