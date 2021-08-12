
#### POST-HOC Analyses --------------------------

library(emmeans)
#E <- emmeans(m1, specs = pairwise ~ Register | Chord)
m3$Register <- factor(m2$Register,levels = -3:3,labels = (-3:3)+4)
m3$Chord <- factor(m2$Chord,levels = c("3-11B","3-7A","4-20","4-19A"))
table(m3$Register)
table(m3$Chord)

#m0 <- lmer(Rating ~ Chord * Register * Expertise + (1|participant),data=m3)
m0 <- lmer(Rating ~ Chord * Register + (1|participant),data=m3)
summary(m0,correlation=FALSE)
R <- emmeans(m0, specs = pairwise ~ Register,adjust='Tukey')
R
# All significant except 4 - 5, 4 - 6, 4 - 7, 5 - 6, 6 - 7


# Hypothesis 2
Low_Register =   c(1, 1, 0, 0, 0, 0, 0)
High_Register =  c(0, 0, 1, 1, 1, 1, 1)
R <- emmeans(m0, specs = ~ Register,adjust='Tukey')
R
# This is Between Low and High Register (H2)                 estimate     SE df t.ratio p.value
contrast(R,method=list(High_Register - Low_Register))#        22.7 0.626 194 36.330  <.0001
S1<-dplyr::summarise(dplyr::filter(m3,Register=='1' | Register=='2'),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S2<-dplyr::summarise(dplyr::filter(m3,Register=='3' | Register=='4' | Register=='5' | Register=='6' | Register=='7'),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S1
S2

# Hypothesis 3
High_Register =   c(0, 0, 0, 0, 0, 1, 1)
Middle_Register =  c(0, 0, 0, 1, 1, 0, 0)
# This is Between Low and High Register (H2)                 estimate     SE df t.ratio p.value
contrast(R,method=list(Middle_Register - High_Register))#     0.795 0.357 1539 2.225   0.0263

m3$Register
tmp<-filter(m3,Register=='3' | Register=='4' | Register=='5')
table(tmp$Register)

S1<-dplyr::summarise(dplyr::filter(m3,Register=='4' | Register=='5'),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S2<-dplyr::summarise(dplyr::filter(m3,Register=='6' | Register=='7'),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S1
S2
S<-dplyr::summarise(group_by(m3,Register),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S


# Hypothesis 3
High_Register =   c(0, 0, 0, 0, 0, 1, 1)
Middle_Register =  c(1, 1, 0, 0, 0, 0, 0)
# This is Between Low and High Register (H2)                 estimate     SE df t.ratio p.value
contrast(R,method=list(High_Register - Middle_Register))#     0.795 0.357 1539 2.225   0.0263

m3$Register
tmp<-filter(m3,Register=='3' | Register=='4' | Register=='5')
table(tmp$Register)

S1<-dplyr::summarise(dplyr::filter(m3,Register=='4' | Register=='5'),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S2<-dplyr::summarise(dplyr::filter(m3,Register=='6' | Register=='7'),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S1
S2
S<-dplyr::summarise(group_by(m3,Register),M=mean(Rating),SE=sd(Rating)/sqrt(55))
S



# All significant at p<.001 except 3-7A (power chord) vs 4-20 (maj 7), closest on pre-ratings 8.1 vs 6.0

#m0 <- lmer(Rating ~ Chord * Expertise + (1|participant),data=m3)
#E <- emmeans(m0, specs = pairwise ~ Expertise | Chord, adjust='Tukey')
#E

#E_means<-dplyr::summarise(dplyr::group_by(m3,Chord,Expertise),M=mean(Rating),SE=sd(Rating)/sqrt(55))
#E_means

# None of the chords are rated significantly different by groups differing in expertise
#m0 <- lmer(Rating ~ Register * Expertise + (1|participant),data=m3)
#ER <- emmeans(m0, specs = pairwise ~ Expertise | Register, adjust='Tukey')
#ER
#ER_means<-dplyr::summarise(dplyr::group_by(m3,Register,Expertise),M=mean(Rating),SE=sd(Rating)/sqrt(55))
#ER_means

# no differences in registers 3 above, but in the lowest two registers, musicians are giving
# significantly lower ratings (M=2.80, SE=0.231) and nonmusicians (M=1.32, SE 0.414), t(310)=3.118  p =0.0020

# no differences in registers 3 above, but in the lowest two registers, musicians are giving
# significantly lower ratings (M=2.59, SE=0.414) and nonmusicians (M=3.62, SE 0.231), t(310)=2.166, p=0.0311

# Hypothesis 5
mi <- lmer(Rating ~ Chord * Register + (1|participant),data=m2)
RC <- emmeans(mi, specs = pairwise ~ Chord | Register,adjust='Tukey')
RC
#plot(RC)
# significance varies across the register, lowest 2, nothing is significant, but from R3 upwards the chords are significantly different from each
# Summary, lower register, low consonance, no differences, mid octave, 3-5 differences are clear, 6-7


#### U - curve? emmeans style --------------------------------
m3$RegisterNum <-as.numeric(m3$Register)-4
#model.quad <- lm(Rating ~ RegisterNum + I(RegisterNum^2), data = m3)
#model.quad <- lm(Rating ~ Register, data = m3)
#emmeans(model.quad, "Register")
#summary(model.quad)

library(MuMIn)

model.lin <- lmer(Rating ~ Chord + poly(RegisterNum,1,raw = TRUE) + (1|participant),data=m3)
summary(model.lin,correlation=FALSE)
#rand(model.quad)           # Id ***
r.squaredGLMM(model.lin) #  0.1392507 0.2209149
round(AIC(model.lin))    # 8021

model.quad <- lmer(Rating ~ Chord + poly(RegisterNum,2,raw = TRUE) + (1|participant),data=m3)
summary(model.quad,correlation=FALSE)
#rand(model.quad)           # Id ***
r.squaredGLMM(model.quad) #  0.1865379 0.2699034
round(AIC(model.quad))    # 7926

model.quad2 <- lmer(Rating ~ Chord + poly(RegisterNum,3,raw = TRUE) + (1|participant),data=m3)
summary(model.quad2,correlation=FALSE)
#rand(model.quad)           # Id ***
r.squaredGLMM(model.quad2) #  0.1911959 0.2746844
round(AIC(model.quad2))    # 7924

anova(model.lin,model.quad) # 103.75  1  < 2.2e-16 ***
anova(model.quad,model.quad2) # 10.772  1   0.001031 **
confint(model.quad)
confint(model.quad2)

#-------------------------------------------
m3$RegisterNum <- as.numeric(m3$Register)-4

model.lin <-lm(Rating ~ RegisterNum,data=m3)
mo1<-papaja::apa_print(summary(model.lin)) # "$R^2 = .14$, 90\\% CI $[0.11$, $0.17]$, $F(1, 1650) = 267.50$, $p < .001$"
mo1
model.quad <- lm(Rating ~ poly(RegisterNum,2),data=m3)
mo2<-papaja::apa_print(summary(model.quad)) # "$R^2 = .19$, 90\\% CI $[0.16$, $0.22]$, $F(2, 1649) = 189.59$, $p < .001$"
mo2
modelfit <-as.character(mo2$estimate$modelfit[1])

anova(model.lin,model.quad) # ***

model.quad2 <- lm(Rating ~ poly(RegisterNum,3),data=m3)
mo3<-papaja::apa_print(summary(model.quad2)) # Radj = 0.9876 , p=0.0008265
mo3
anova(model.quad,model.quad2) # **
