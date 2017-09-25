rm(list=ls())

library(rstan)
library(plyr)

setwd("/home/hanshalbe/Desktop/oneshotcomp/Code")

logit2prob <- function(logit){
  odds <- exp(logit)
  prob <- odds / (1 + odds)
  return(prob)
}

d <- read.csv("/home/hanshalbe/Desktop/oneshotcomp/Data/results2.csv")
head(d)
dd<-ddply(d, ~id, summarize, x=sum(correct), y=sum(other), z=sum(single), k=length(correct))

y <- dd$x
K <- dd$k
N <- length(y)
K_new <- rep(0, N)
y_new <- rep(0.0, N)
fit_comp_hier_logit1 <- stan("hier-logit.stan", data = c("N", "K", "y", "K_new", "y_new"))

y <- dd$y
fit_comp_hier_logit2 <- stan("hier-logit.stan", data = c("N", "K", "y", "K_new", "y_new"))


y <- round(dd$z/2)
fit_comp_hier_logit3 <- stan("hier-logit.stan", data = c("N", "K", "y", "K_new", "y_new"))

  
pm1<-logit2prob(summary(fit_comp_hier_logit1, pars = c("mu"), probs = c(0.1, 0.9))$summary)
pm2<-logit2prob(summary(fit_comp_hier_logit2, pars = c("mu"), probs = c(0.1, 0.9))$summary)
pm3<-logit2prob(summary(fit_comp_hier_logit3, pars = c("mu"), probs = c(0.1, 0.9))$summary)
  
mu_summary1 <- summary(fit_comp_hier_logit1, pars = c("theta"), probs = c(0.1, 0.9))$summary
dplot1<-as.data.frame(mu_summary1[,c(1,4,5)])
names(dplot1)<-c("estimate", "lb", "ub")
dplot1$level<-paste0("P",1:50)
dplot1$level<-factor(dplot1$level, levels=paste0("P",1:50)[order(dplot1$estimate)])

mu_summary2 <- summary(fit_comp_hier_logit2, pars = c("theta"), probs = c(0.1, 0.9))$summary
dplot2<-as.data.frame(mu_summary2[,c(1,4,5)])
names(dplot2)<-c("estimate", "lb", "ub")
dplot2$level<-paste0("P",1:50)
dplot2$level<-factor(dplot2$level, levels=paste0("P",1:50)[order(dplot1$estimate)])


mu_summary3 <- summary(fit_comp_hier_logit3, pars = c("theta"), probs = c(0.1, 0.9))$summary
dplot3<-as.data.frame(mu_summary3[,c(1,4,5)])
names(dplot3)<-c("estimate", "lb", "ub")
dplot3$level<-paste0("P",1:50)
dplot3$level<-factor(dplot3$level, levels=paste0("P",1:50)[order(dplot1$estimate)])

dplot<-rbind(dplot1, dplot2, dplot3)
dplot$Option<-rep(c("True composition", "Other composition", "Single component"), each=50)
dplot$Option<-factor(dplot$Option, levels=c("Single component","Other composition","True composition"))

g1 <- ggplot(dplot, aes(estimate,level,xmin=lb,xmax=ub, col=Option))+
    geom_errorbarh(height=0.25, alpha=0.3)+
    geom_vline(xintercept=pm1[1],lty=1, col="darkblue")+
    geom_vline(xintercept=pm1[4],lty=2, col="darkblue")+
    geom_vline(xintercept=pm1[5],lty=2, col="darkblue")+
    geom_vline(xintercept=pm2[1],lty=1, col="darkgreen")+
    geom_vline(xintercept=pm2[4],lty=2, col="darkgreen")+
    geom_vline(xintercept=pm2[5],lty=2, col="darkgreen")+
    geom_vline(xintercept=pm3[1],lty=1, col="darkred")+
    geom_vline(xintercept=pm3[4],lty=2, col="darkred")+
    geom_vline(xintercept=pm3[5],lty=2, col="darkred")+
    geom_point()+theme_classic()+xlab("Estimate")+
    ylab("Participant")+ggtitle("Experiment 2: Bayesian estimates")+
    theme(text = element_text(size=20, family="serif"))+
    theme(panel.background = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.line = element_line(colour = "black"),
          panel.border = element_rect(colour = "black", fill=NA, size=2),
          legend.position = "bottom",
          axis.text.y = element_text(size=10),
          legend.title = element_blank())

  
pdf("exp2.pdf")
g1
dev.off()

getwd()
