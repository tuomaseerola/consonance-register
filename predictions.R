
midiToFreq <- function(midi)
{
  440*2^((midi-69)/12)
}

x <- seq(0, 104, by = 1)
# Choose the mean as 2.5 and standard deviation as 0.5.
y <- dnorm(x, mean = 63, sd = 10)
#plot(x,y,type='l')
df<-data.frame(midi=x,Ampl=y)

df$Ampl<-scales::rescale(df$Ampl,to=c(0,1))
df$hz<-midiToFreq(df$midi)
df$Bark<-tuneR::hz2bark(df$hz)
#df<-dplyr::select(df,-midi)

oct <- c(60-12*3,60-12*2,60-12*1,60-12*0,60+12*1,60+12*2,60+12*3)
oct_in_hz <-midiToFreq(oct)
reg <- c("C1","C2","C3","C4","C5","C6","C7")
reg_in_hz <-midiToFreq(oct)

invisible(library(ggplot2))


# 27    34    40
# 37    44    50
# 47    54    60
# 57    64    70
# 67    74    80
# 77    84    90
# 87    94   100


chords4 <- read.csv('tetrads_4.csv',header = FALSE)
chords4<-chords4-3*12

min_chord <- min((as.vector(unlist(chords4))))
mean_chord <- mean(as.vector(unlist(chords4)))
max_chord <- max((as.vector(unlist(chords4))))
oct_width<-10

set_low<-NULL
set_high<-NULL
set_mean<-NULL
for (k in 1:7) {
  set_low <- c(set_low,min_chord + k * oct_width)
  set_high <- c(set_high,max_chord + k * oct_width)
  set_mean <- c(set_mean,mean_chord + k * oct_width)
}

invisible(library(dplyr))
set_y <- df$Ampl[which(df$midi %in% round((set_low + set_high)/2))]

df$hz<-midiToFreq(df$midi)
oct_in_hz <-midiToFreq(oct)


df$bark<-tuneR::hz2bark(df$hz)
oct_in_bark <- tuneR::hz2bark(oct_in_hz)

lowlim <- tuneR::hz2bark(midiToFreq(set_low))
highlim <- tuneR::hz2bark(midiToFreq(set_high))
meanlim <- tuneR::hz2bark(midiToFreq(set_mean))

fig1<-ggplot(df,aes(x=bark,y=Ampl))+
  geom_line()+
  geom_vline(xintercept=oct_in_bark,colour='gray60')+
  annotate("text",x=oct_in_bark,y=rep(0.25,length(oct_in_bark)),label=reg,size=5)+
  annotate("text",x=oct_in_bark,y=rep(0.100,length(oct_in_bark)),label=paste(round(reg_in_hz,1),'Hz'),size=2.6)+
  #  annotate("rect", xmin = tuneR::hz2bark(midiToFreq(set_low)), xmax = tuneR::hz2bark(midiToFreq(set_high)),ymin = 0, ymax = set_y+0.001, alpha=0.5,fill='grey50')+
  annotate("pointrange", x = meanlim[1], xmin = lowlim[1], xmax = highlim[1],y = 0.35, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("pointrange", x = meanlim[2], xmin = lowlim[2], xmax = highlim[2],y = 0.40, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("pointrange", x = meanlim[3], xmin = lowlim[3], xmax = highlim[3],y = 0.50, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("pointrange", x = meanlim[4], xmin = lowlim[4], xmax = highlim[4],y = 0.55, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("pointrange", x = meanlim[5], xmin = lowlim[5], xmax = highlim[5],y = 0.50, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("pointrange", x = meanlim[6], xmin = lowlim[6], xmax = highlim[6],y = 0.40, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("pointrange", x = meanlim[7], xmin = lowlim[7], xmax = highlim[7],y = 0.35, alpha=0.75,fill='black',shape=22,size=2.5)+
  annotate("text", x = meanlim[1], y = 0.35, alpha=.95,label='R1',size=4,colour='white')+
  annotate("text", x = meanlim[2], y = 0.40, alpha=.95,label='R2',size=4,colour='white')+
  annotate("text", x = meanlim[3], y = 0.50, alpha=.95,label='R3',size=4,colour='white')+
  annotate("text", x = meanlim[4], y = 0.55, alpha=.95,label='R4',size=4,colour='white')+
  annotate("text", x = meanlim[5], y = 0.50, alpha=.95,label='R5',size=4,colour='white')+
  annotate("text", x = meanlim[6], y = 0.40, alpha=.95,label='R6',size=4,colour='white')+
  annotate("text", x = meanlim[7], y = 0.35, alpha=.95,label='R7',size=4,colour='white')+
  scale_x_continuous(breaks = round(oct_in_bark,1),limits = tuneR::hz2bark(midiToFreq(c(20,107))),expand = c(0,0),trans = 'log')+
  scale_y_continuous(limits = c(0,1),expand = c(0,0))+
  xlab('Frequency (Bark)')+
  ylab('Density')+
  theme_bw()+
  theme(text=element_text(family="serif"))


#print(fig1)


invisible(library(incon))
invisible(library(reshape2))

chords4 <- read.csv('tetrads_4.csv',header = FALSE)
chords4<-chords4-3*12
oct_width<-10

rough <- NULL
harm <- NULL
fami<-NULL
comp<-NULL
mean_pitch <-NULL

i<-1
for (l in 1:4) {
  tmp <- as.numeric(chords4[l,])
  for (k in 1:7) {
    tmp2<- tmp + k * oct_width
    rough[i]<-incon(tmp2,model="hutch_78_roughness")
    harm[i]<-incon(tmp2,model="stolz_15_periodicity")
    fami[i]<-incon(tmp2,model="har_19_corpus")
    comp[i]<-incon(tmp2,model="har_19_composite")
    mean_pitch[i] <- mean(tmp2)
    i<-i+1
  }
}

df2 <- data.frame(Roughness=rough,Harmonicity=harm,Familiarity=fami,Composite_Model=comp,mean_pitch)
df2$Register<-rep(1:7,4)
df2$Stimuli<-c(rep(1,7),rep(2,7),rep(3,7),rep(4,7))
df2$StimulusName<-c(rep('3-11B',7),rep('3-7A',7),rep('4-20',7),rep('4-19A',7))
df2$StimulusName<-factor(df2$StimulusName)
df2$Register<-factor(df2$Register)
s<-read.csv('../acoustic_analysis/Sharpness.txt',header = FALSE)
df2$Sharpness <- s$V1
#write.csv(df2,file = 'roughness_and_sharpness.csv')
m<-melt(df2,id.vars = c('StimulusName','Register'),measure.vars = c('Roughness','Sharpness'))

# Plot
theme_fs <- function(fs=13){
  tt <- theme(axis.text = element_text(size=fs-1, colour=NULL)) + 
    theme(legend.text = element_text(size=fs, colour=NULL)) + 
    theme(legend.title = element_text(size=fs, colour=NULL)) + 
    theme(axis.title = element_text(size=fs, colour=NULL)) + 
    theme(legend.text = element_text(size=fs, colour=NULL))
  return <- tt
}
custom_theme_size <- theme_fs(11)


fig2 <- ggplot(m,aes(x=Register,y=value,fill=StimulusName,colour=StimulusName,group=StimulusName,shape=StimulusName))+
  geom_point(size=2)+
  geom_line()+
  scale_linetype(name='Chords')+
  scale_color_grey(start = 0.0,end = 0.8,name='Chords')+
  scale_fill_grey(start = 0.0,end = 0.8,name='Chords')+
  scale_shape_manual(values = c(22,23,24,25),name='Chords')+
  scale_x_discrete(breaks = 1:7,labels = c('R1','R2','R3','R4','R5','R6','R7'))+
  facet_wrap(.~variable,scales = 'free',nrow = 2)+
  theme_bw()+
  custom_theme_size+
  theme(strip.text.x = element_text(size = 13))+
  theme(legend.justification=c(0,1), legend.position=c(0.025,.40))+
  theme(legend.text = element_text(size = 10))+
  theme(strip.background = element_blank(),
        panel.border = element_rect(colour = "black", fill = NA))+
  theme(legend.background=element_blank())+
  labs(fill  = "Chord", linetype = "Chord", shape = "Chord",color="Chord")+
  theme(text=element_text(family="serif"))
#print(fig2)

library("cowplot")
G <- plot_grid(fig1,fig2,labels = c("A", "B"), ncol = 2, nrow = 1,rel_widths = c(2, 1))
#print(G)

