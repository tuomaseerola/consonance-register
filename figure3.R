
#mi <- lmer(Rating ~ Chord * Register + (1|participant),data=m2)
#summary(mi)
#RC <- emmeans(mi, specs = pairwise ~ Chord | Register,adjust='Tukey')
#RC
m3 <- m2
m3$Chord <- factor(m3$Chord,levels = c("3-11B","3-7A","4-20","4-19A"))
m3$Chord
#m3$Chord <- as.numeric(m3$Chord) # This is coded as a linear factor with decreasing levels of consonance
#m3$Register <- as.numeric(m3$Register)
library(dplyr)
library(ggplot2)
options(dplyr.summarise.inform = FALSE)
S <- m3 %>%
  dplyr::group_by(Register,Chord) %>%
  dplyr::summarise(n=n(),m=mean(Rating,na.rm = TRUE),sd=sd(Rating,na.rm = TRUE)) %>%
  dplyr::mutate(se=sd/sqrt(n),LCI=m+qnorm(0.025)*se,UCI=m+qnorm(0.975)*se) 
#S$Register<-as.numeric(S$Register)
S
pd<-position_dodge(.5)
g1 <- ggplot(S,aes(x=Register,y=m,colour=Chord,group=Chord,fill=Chord,shape=Chord))+
  geom_point(position = pd,size=4)+
#  geom_line(position = pd)+
  geom_errorbar(aes(x=Register,ymin=LCI,ymax=UCI,colour=Chord), width=0.50,position = pd,show.legend = FALSE)+
  ylab('Mean Consonance Rating ± 95% CI')+
  xlab('Register')+
  scale_linetype(name='Chords')+
  scale_color_grey(start = 0.0,end = 0.2,name='Chords')+
  scale_fill_grey(start = 0.0,end = 0.8,name='Chords')+
  scale_shape_manual(values = c(22,23,24,25),name='Chords')+
  scale_x_discrete(breaks = -3:3,labels = c('R1','R2','R3','R4','R5','R6','R7'))+
  theme_bw()+
  scale_y_continuous(breaks = 1:9,limits = c(1,9))+
  labs(fill  = "Chord", linetype = "Chord", shape = "Chord",color="Chord")+
  theme(legend.justification=c(0,0), legend.position=c(0.05,0.6))+
  theme(legend.background=element_rect(fill = ggplot2::alpha("white", 0.5)))+
  annotate('segment',x = 0.8,xend = 1.2,y=3.8,yend=3.8,size=0.25)+
  annotate('text',x = 1,y=3.8+0.2,size=2.5,label='ns')+
  annotate('segment',x = 1.7,xend = 2.3,y=4.75,yend=4.75,size=0.25)+
  annotate('text',x = 2,y=4.75+0.2,size=2.5,label='ns')+
  # R3
  annotate('segment',x = 2.8,xend = 2.95,y=8.00-0.00,yend=8.00-0.00,size=0.25)+
  annotate('segment',x = 2.8,xend = 3.05,y=8.00-0.20,yend=8.00-0.20,size=0.25)+
  annotate('segment',x = 2.8,xend = 3.2,y=8.00-0.40,yend=8.00-0.40,size=0.25)+
  annotate('segment',x = 2.95,xend = 3.05,y=3.30-0.60,yend=3.30-0.60,size=0.25)+
  annotate('segment',x = 2.95,xend = 3.2,y=3.30-0.80,yend=3.30-0.80,size=0.25)+
  annotate('segment',x = 3.05,xend = 3.2,y=3.30-1.00,yend=3.30-1.00,size=0.25)+
  
  annotate('text',x = (2.80+2.95)/2,y=8.00-0.00+0.07,size=2.5,label='***')+
  annotate('text',x = (2.80+3.05)/2,y=8.00-0.20+0.07,size=2.5,label='***')+
  annotate('text',x = (2.80+3.20)/2,y=8.00-0.40+0.07,size=2.5,label='***')+
  annotate('text',x = (2.95+3.05)/2,y=3.30-0.60+0.09,size=2.0,label='ns')+
  annotate('text',x = (2.95+3.20)/2,y=3.30-0.80+0.09,size=2.0,label='ns')+
  annotate('text',x = (3.05+3.20)/2,y=3.30-1.00+0.07,size=2.5,label='*')+  
# R4
  annotate('segment',x = 3.8,xend = 3.95,y=8.60-0.00,yend=8.60-0.00,size=0.25)+
  annotate('segment',x = 3.8,xend = 4.05,y=8.60-0.20,yend=8.60-0.20,size=0.25)+
  annotate('segment',x = 3.8,xend = 4.2,y=8.60-0.40,yend=8.60-0.40,size=0.25)+
  annotate('segment',x = 3.95,xend = 4.05,y=3.50-0.60,yend=3.50-0.60,size=0.25)+
  annotate('segment',x = 3.95,xend = 4.2,y=3.50-0.80,yend=3.50-0.80,size=0.25)+
  annotate('segment',x = 4.05,xend = 4.2,y=3.50-1.00,yend=3.50-1.00,size=0.25)+
  
  annotate('text',x = (3.80+3.95)/2,y=8.60-0.00+0.07,size=2.5,label='***')+
  annotate('text',x = (3.80+4.05)/2,y=8.60-0.20+0.07,size=2.5,label='***')+
  annotate('text',x = (3.80+4.20)/2,y=8.60-0.40+0.07,size=2.5,label='***')+
  annotate('text',x = (3.95+4.05)/2,y=3.50-0.60+0.09,size=2.0,label='ns')+
  annotate('text',x = (3.95+4.20)/2,y=3.50-0.80+0.07,size=2.5,label='***')+
  annotate('text',x = (4.05+4.20)/2,y=3.50-1.00+0.07,size=2.5,label='***')+
    
# R5
  annotate('segment',x = 4.8,xend = 4.95,y=8.90-0.00,yend=8.90-0.00,size=0.25)+
  annotate('segment',x = 4.8,xend = 5.05,y=8.90-0.20,yend=8.90-0.20,size=0.25)+
  annotate('segment',x = 4.8,xend = 5.2,y=8.90-0.40,yend=8.90-0.40,size=0.25)+
  annotate('segment',x = 4.95,xend = 5.05,y=3.70-0.60,yend=3.70-0.60,size=0.25)+
  annotate('segment',x = 4.95,xend = 5.2,y=3.70-0.80,yend=3.70-0.80,size=0.25)+
  annotate('segment',x = 5.05,xend = 5.2,y=3.70-1.00,yend=3.70-1.00,size=0.25)+
  
  annotate('text',x = (4.80+4.95)/2,y=8.90-0.00+0.09,size=2.0,label='ns')+
  annotate('text',x = (4.80+5.05)/2,y=8.90-0.20+0.07,size=2.5,label='***')+
  annotate('text',x = (4.80+5.20)/2,y=8.90-0.40+0.07,size=2.5,label='***')+
  annotate('text',x = (4.95+5.05)/2,y=3.70-0.60+0.07,size=2.5,label='***')+
  annotate('text',x = (4.95+5.20)/2,y=3.70-0.80+0.07,size=2.5,label='***')+
  annotate('text',x = (5.05+5.20)/2,y=3.70-1.00+0.07,size=2.5,label='**')+
  
# R6
  annotate('segment',x = 5.8,xend = 5.95,y=8.80-0.00,yend=8.80-0.00,size=0.25)+
  annotate('segment',x = 5.8,xend = 6.05,y=8.80-0.20,yend=8.80-0.20,size=0.25)+
  annotate('segment',x = 5.8,xend = 6.2,y=8.80-0.40,yend=8.80-0.40,size=0.25)+
  annotate('segment',x = 5.95,xend = 6.05,y=5.00-0.60,yend=5.00-0.60,size=0.25)+
  annotate('segment',x = 5.95,xend = 6.2,y=5.00-0.80,yend=5.00-0.80,size=0.25)+
  annotate('segment',x = 6.05,xend = 6.2,y=5.00-1.00,yend=5.00-1.00,size=0.25)+
  
  annotate('text',x = (5.80+5.95)/2,y=8.80-0.00+0.07,size=2.5,label='**')+
  annotate('text',x = (5.80+6.05)/2,y=8.80-0.20+0.07,size=2.5,label='***')+
  annotate('text',x = (5.80+6.20)/2,y=8.80-0.40+0.07,size=2.5,label='***')+
  annotate('text',x = (5.95+6.05)/2,y=5.00-0.60+0.09,size=2.0,label='ns')+
  annotate('text',x = (5.95+6.20)/2,y=5.00-0.80+0.07,size=2.5,label='*')+
  annotate('text',x = (6.05+6.20)/2,y=5.00-1.00+0.09,size=2.0,label='ns')+
  
# R7
  annotate('segment',x = 6.8,xend = 6.95,y=8.00-0.00,yend=8.00-0.00,size=0.25)+
  annotate('segment',x = 6.8,xend = 7.05,y=8.00-0.20,yend=8.00-0.20,size=0.25)+
  annotate('segment',x = 6.8,xend = 7.2,y=8.00-0.40,yend=8.00-0.40,size=0.25)+
  annotate('segment',x = 6.95,xend = 7.05,y=4.00-0.60,yend=4.00-0.60,size=0.25)+
  annotate('segment',x = 6.95,xend = 7.2,y=4.00-0.80,yend=4.00-0.80,size=0.25)+
  annotate('segment',x = 7.05,xend = 7.2,y=4.00-1.00,yend=4.00-1.00,size=0.25)+
  
  annotate('text',x = (6.80+6.95)/2,y=8.00-0.00+0.09,size=2.0,label='ns')+
  annotate('text',x = (6.80+7.05)/2,y=8.00-0.20+0.07,size=2.5,label='***')+
  annotate('text',x = (6.80+7.20)/2,y=8.00-0.40+0.07,size=2.5,label='***')+
  annotate('text',x = (6.95+7.05)/2,y=4.00-0.60+0.07,size=2.5,label='*')+
  annotate('text',x = (6.95+7.20)/2,y=4.00-0.80+0.07,size=2.5,label='***')+
  annotate('text',x = (7.05+7.20)/2,y=4.00-1.00+0.09,size=2.0,label='ns')+
  theme(text=element_text(family="serif"))
print(g1)

#ggsave(filename = 'figure3.pdf',g1,width = 9,height = 4.75,device = 'pdf')
