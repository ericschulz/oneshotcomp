rm(list=ls())

library(rstan)
library(plyr)

setwd("/home/hanshalbe/Desktop/oneshotcomp/Code")

logit2prob <- function(logit){
  odds <- exp(logit)
  prob <- odds / (1 + odds)
  return(prob)
}

myplot<-function(k){
  
  d <- read.csv(paste0("/home/hanshalbe/Desktop/oneshotcomp/Data/results",k, ".csv"))
  dd<-ddply(d, ~id, summarize, y=sum(correct), k=length(correct))
  y <- dd$y
  K <- dd$k
  N <- length(y)
  K_new <- rep(0, N)
  y_new <- rep(0.0, N)
  
  fit_comp_hier_logit <- stan("hier-logit.stan", data = c("N", "K", "y", "K_new", "y_new"));
  
  pm<-logit2prob(summary(fit_comp_hier_logit, pars = c("mu"), probs = c(0.1, 0.9))$summary)
  
  
  
  mu_summary1 <- summary(fit_comp_hier_logit, pars = c("theta"), probs = c(0.1, 0.9))$summary
  
  dplot1<-as.data.frame(mu_summary1[,c(1,4,5)])
  names(dplot1)<-c("estimate", "lb", "ub")
  dplot1$level<-paste0("P",1:50)
  dplot1$level<-factor(dplot1$level, levels=paste0("P",1:50)[order(dplot1$estimate)])
  
  
  g1 <- ggplot(dplot1, aes(estimate,level,xmin=lb,xmax=ub))+
    geom_errorbarh(height=0.25)+
    geom_vline(xintercept=0.25,lty=2)+
    geom_vline(xintercept=pm[1],lty=1, col="red")+
    geom_vline(xintercept=pm[4],lty=2, col="red")+
    geom_vline(xintercept=pm[5],lty=2, col="red")+
    geom_point()+theme_classic()+xlab("Estimate")+
    ylab("Participant")+ggtitle(paste("Experiment", k,": Hierarchical Bayesian estimates"))+
    theme(text = element_text(size=16, family="serif"))+
    theme(panel.background = element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          axis.line = element_line(colour = "black"),
          panel.border = element_rect(colour = "black", fill=NA, size=2))

  return(g1)
  
}

p1<-myplot(1)
p2<-myplot(2)
p3<-myplot(3)
p4<-myplot(4)

library(gridExtra)
grid.arrange(p1,p2,p3,p4)
