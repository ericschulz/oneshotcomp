#House keeping
rm(list=ls())

#get the packages going
packages <- c('plyr', 'ggplot2','MASS', 'plyr')
lapply(packages, library, character.only = TRUE)

setwd("/home/hanshalbe/Desktop/oneshotcomp")

d<-read.csv("Data/results2.csv")

m<-glm(correct~composition, data=d, family="binomial")
summary(m)

#choosing other composition
d$other<-d$choice
d$other[d$correct==1]<-"9"
d$other<-d$other %in% c("+","*")

#choosing single composition
d$single<-!(d$choice %in% c("+","*"))

#grand t-test
t.test(d$other, d$correct)

#test the difference
d1<-ddply(d, ~id, summarize, m1=mean(correct), m2=mean(other), v=var(choice))
t.test(d1$m1-d1$m2, mu=0)
t.test(d1$m1, mu=0.25)

#function for standard error
se<-function(x){sd(x)/sqrt(length(x))}
#mean and se
m<-c(mean(d$other), mean(d$correct), mean(d$single)/2, mean(d$single)/2)
s<-c(se(d$other), se(d$correct), se(d$single), se(d$single))

#plot data frame
dplot<-data.frame(prop=m, se=s, proposal=c("Other\nComposition", "True\n Composition", 
                                           "Single\n Component 1", "Single\n Component 2"))

#limits
limits <- aes(ymax = prop + se, ymin=prop-se)
#plots
p <- ggplot(dplot, aes(y=prop, x=proposal)) + 
  #bars
  geom_bar(position="dodge", stat="identity", col="darkred")+
  geom_hline(yintercept = 0.25)+
  ylim(c(0,0.5)) + 
  #golden ratio error bars
  geom_errorbar(limits, position="dodge", width=0.31)+
  #point size
  geom_point(size=3)+
  #title
  ggtitle("Experiment 2: Results")+theme_classic() +xlab("Option")+ylab("Proportion chosen")+
  #change theme
  theme(text = element_text(size=20, family="serif"))+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2))

#store as pdf
pdf("Figures/results2.pdf")
p
dev.off()
