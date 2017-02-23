#Plotting an example of kernel composition

#House keeping
rm(list=ls())

#get the packages going
packages <- c('ggplot2', 'MASS')
lapply(packages, library, character.only = TRUE)

#linear kernel
lin<-function(x1, x2){
  y<-(x1-2)*(x2+2)
  return(y)
}

rbf<-laplacedot( sigma=1)


sqe<-function(x1, x2){
   d<-abs(x1-x2)
   y<-exp(-(d)/0.001)
  return(y)
}
x2<-seq(0,10,0.1)
#periodic
per<-function(x1, x2){
  d<-abs(x1-x2)
  y<-exp(-2*(sin(d*pi*0.3))^2)
  return(y)
}

#kernel function
kernel<-function(f, X1, X2){
  Sigma <- matrix(rep(0, length(X1)*length(X2)), nrow=length(X1))
  for (i in 1:nrow(Sigma)) {
    for (j in 1:ncol(Sigma)) {
      Sigma[i,j] <- f(X1[i],X2[j])
    }
  }
  return(Sigma)
}

#sample function
samplegp<-function(mu, sigma, n){
  mat<-matrix(0, nrow=length(mu), ncol=n)
  for (i in 1:n) {
    mat[,i] <- mvrnorm(1, mu, sigma)
  }
  return(mat)
}

nsample<-4
plot(s5[,2])
#per+lin
s1<-samplegp(rep(0, 101), kernel(function(x1,x2){per(x1,x2)+lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 500)
s1<-s1[,apply(s1,2,function(x){cor(1:101,x)})>0]
s1<-s1[,1:nsample]
#per+sqe
s2<-samplegp(rep(0, 101), kernel(function(x1,x2){per(x1,x2)+sqe(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), nsample)
#sqe+lin
s3<-samplegp(rep(0, 101), kernel(function(x1,x2){sqe(x1,x2)+lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 500)
s3<-s3[,apply(s3,2,function(x){cor(1:101,x)})>0]
s3<-s3[,1:nsample]
#ALL MULTIPLICATIONS
#perxlin
s4<-samplegp(rep(0, 101), kernel(function(x1,x2){per(x1,x2)*lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 500)
s4<-s4[,apply(s4,2,function(x){cor(1:101,x)})>0]
s4<-s4[,1:nsample]
#perxsqe
s5<-samplegp(rep(0, 101), kernel(function(x1,x2){per(x1,x2)*sqe(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), nsample)
#sqexlin
s6<-samplegp(rep(0, 101), kernel(function(x1,x2){sqe(x1,x2)*lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 500)
s6<-s6[,apply(s6,2,function(x){cor(1:101,x)})>0]
s6<-s6[,1:nsample]


dplot<-data.frame(y=c(as.vector(s1),as.vector(s2),as.vector(s3),as.vector(s4),as.vector(s5),as.vector(s6)),
                  x=rep(seq(0,10,0.1), nsample*6), 
                  kernel=rep(c("Linear+Periodic", "RBF+Periodic", "Linear+RBF", "Linear x Periodic", "RBF x Periodic", "Linear x RBF"), each=nsample*101),
                  group=rep(rep(1:nsample, each=101),6))

dplot$kernel<-factor(dplot$kernel, levels=c("Linear+Periodic", "RBF+Periodic", "Linear+RBF", "Linear x Periodic", "RBF x Periodic", "Linear x RBF"))
p <- ggplot(dplot, aes(x=x, y=y, group=group)) + 
  geom_line(col="darkred")+
  #point size
  ggtitle("")+theme_classic() +xlab("Condition")+ylab("Mean Estimates")+
  #adjust text size
  theme(text = element_text(size=24, family="serif"))+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text =element_blank(),
        axis.line = element_line(colour = "black"),
        title=element_blank(),
        plot.title=element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=2))+
  facet_wrap(~kernel, scales="free")
p

pdf("compexamples.pdf")
p
dev.off()

p1<-samplegp(rep(0, 101), kernel(function(x1,x2){lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 1)
p2<-samplegp(rep(0, 101), kernel(function(x1,x2){per(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 1)
p3<-samplegp(rep(0, 101), kernel(function(x1,x2){per(x1,x2)+lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 1)
p4<-samplegp(rep(0, 101), kernel(function(x1,x2){lin(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 1)
p5<-samplegp(rep(0, 101), kernel(function(x1,x2){sqe(x1,x2)}, seq(0,10,0.1), seq(0,10,0.1)), 1)

dplot<-data.frame(x=rep(seq(0,10,0.1),5), y=c(p4,p2,p3,p1,p5),
                  plant=rep(c("Plant 1\n (Feature 1)", "Plant2\n (Feature 2)", "Plant3\n (Feature 1 and 2)",
                              "Plant 4\n (Feature 4)", "Plant 5\n (Feature 5)"), each=101))
d6<-data.frame(x=c(-2,-1), y=c(0,0), plant=rep("Plant 6\n (Feature 4 and 5)",2))
dplot<-rbind(dplot, d6)

question<-data.frame(x=5, y=0, text="?", plant="Plant 6\n (Feature 4 and 5)")
p <- ggplot(dplot, aes(x=x, y=y, group=plant)) + 
  geom_line(col="darkred")+
  #point size
  ggtitle("")+theme_classic() +xlab("Condition")+ylab("Mean Estimates")+
  #adjust text size
  theme(text = element_text(size=24, family="serif"))+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        axis.text =element_blank(),
        axis.line = element_line(colour = "black"),
        title=element_blank(),
        plot.title=element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=2))+
  geom_text(data=question, aes(x=x,y=y, label=text), size=70)+
  xlim(c(0,10))+
  facet_wrap(~plant, scales="free")
p
pdf("expexample.pdf")
p
dev.off()
