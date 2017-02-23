rm(list=ls())

#get the packages going
packages <- c('plyr', 'ggplot2', 'MASS', 'plyr')
lapply(packages, library, character.only = TRUE)

d<-read.csv("Data/results3.csv")

#test
m<-glm(correct~composition, data=d, family="binomial")
summary(m)

#create variables
d$other<-d$choice
d$other[d$correct==1]<-"9"
d$other<-d$other %in% c("+","*")
d$single<-!(d$choice %in% c("+","*"))

#test the difference
d1<-ddply(d, ~id, summarize, m1=mean(correct), m2=mean(other), v=var(choice))
t.test(d1$m1-d1$m2, mu=0)
t.test(d1$m1, mu=0.25)
se<-function(x){sd(x)/sqrt(length(x))}

m<-c(mean(d$other), mean(d$correct), mean(d$single)/2, mean(d$single)/2)
s<-c(se(d$other), se(d$correct), se(d$single), se(d$single))
dplot<-data.frame(prop=m, se=s, proposal=c("Alternative\nComposition", "True\n Composition", 
                                           "Single\n Alternative 1", "Single\n Alternative 2"))

limits <- aes(ymax = prop + se, ymin=prop-se)

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
  ggtitle("")+theme_classic() +xlab("\nOption")+ylab("Proportion chosen\n")+
  #change theme
  theme(text = element_text(size=22, family="serif"))+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill=NA, size=2))

pdf("Figures/results3.pdf")
p
dev.off()
