PATH<-"/home/khodgins/om62_scratch/simulations_del2_full/"
RNAME<-"FILE"

R<-strsplit(as.character(RNAME), "_",fixed = TRUE)
pollen<-as.data.frame( sapply (R, "[[", 2))

x<-as.data.frame( sapply (R, "[[", 3))
x<-strsplit (as.character(as.vector(x[,1])),split = "SD")
sd<-as.data.frame( sapply (x, "[[", 2))

x<-as.data.frame( sapply (R, "[[", 4))
x<-strsplit (as.character(as.vector(x[,1])),split = "S")
self<-as.data.frame( sapply (x, "[[", 2))

rep<-as.data.frame( sapply (R, "[[", 5))

pollen<-as.numeric(as.character(unlist(pollen)))
sd <- as.numeric(as.character(unlist(sd)))
self <- as.numeric(as.character(unlist(self))) 
rep <- rep


name<-paste(PATH, RNAME, "/ind_phenotype.txt", sep="")
t<-read.table(name, header=F)
header <- c("population", "individual", "phenotype")
colnames(t)<-header

t$optimum<-ifelse(t$population=="p1", 1, -1)

#determine the deviation from the optimum for each individual
t$deviations = t$optimum - t$phenotype
	
#fitness function max (to scale between 0 and 1
fitnessFunctionMax = dnorm(0.0, 0.0, sd)
	
#how far the individual is off the max fitness - on the optimum give adaptation value of 1 while further away gives values closer to 0
adaptation = dnorm(t$deviations, 0.0, sd) / fitnessFunctionMax
	
#a perfectly adapted individual will have a fitness on 1 while a completely mal adapted inidividual will have a fitness floor of .1 to allow the population to be maintained
inds.fitnessScaling = 0.1 + (adaptation * 0.9)

t$pop<-ifelse(t$population=='p1',1,2)
t$group<-paste(RNAME, t$pop, sep="_")

fit<-tapply(inds.fitnessScaling, t$group, mean, na.rm=TRUE)
load<-tapply((1-inds.fitnessScaling), t$group, mean, na.rm=TRUE)


mean<-cbind(self, pollen, sd, fit, load)
out<-paste(PATH, RNAME, "/fitness_scaling.txt", sep="")
write.table(inds.fitnessScaling, out, append = FALSE, quote = FALSE,  col.names =FALSE)

out2<-paste(PATH,RNAME, "/mig_load.txt", sep="")
write.table(mean, out2, append = FALSE, quote = FALSE, col.names =FALSE)


