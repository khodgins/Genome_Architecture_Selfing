PATH<-"/home/khodgins/om62_scratch/simulations_del2/"
#RNAME<-/files_set4/M_0.9_SD3.0_S0.01_R7
RNAME<-"FILE"
name<-paste(PATH, RNAME, "/fst_out_100.txt", sep="")
t<-read.table(name, header=F)
j<-0
m<-matrix(0,1,16)

for (i in 1:2){
        sum<-as.data.frame(table(t[,i], t[,29]))
        sumy<-sum[sum$Var1 == 'Y',]
        sum<-cbind(sumy, table(t$V29))
        p<-sum(sumy$Freq)/sum(sum[,5])
        q9999<-qbinom(.999,sum[,5],p)
        sumy$Freq>q9999
        sum[sumy$Freq>q9999,]
        m2<-unique(t$V29[t$V21 == 'm2' ])
        T<-length(m2)
        m[j+1]<-length(m2[unique(m2) %in% sum[sumy$Freq>q9999,2]]) #TP
        P<-length(sum[sumy$Freq>q9999,2])
        all<-dim(sum)[1]
        m[j+2]<-P-m[j+1] #FP
        N<-all-P
        m[j+3]<-T-m[j+1] #FN
        m[j+4]<-all-m[j+1]-m[j+2]-m[j+3] #TN
        j<-j+4
}

for (i in 3:4){
        sum<-as.data.frame(table(t[,i], t[,29]))
        sumy<-sum[sum$Var1 == 'Y',]
        sum<-cbind(sumy, table(t$V29))
        p<-sum(sumy$Freq)/sum(sum[,5])
        q9999<-qbinom(.999,sum[,5],p)
        sumy$Freq>q9999
        sum[sumy$Freq>q9999,]
	m2<-unique(t$V29[t$V21 == 'm2' & t$V16 > 0.05])
        T<-length(m2)
        m[j+1]<-length(m2[unique(m2) %in% sum[sumy$Freq>q9999,2]]) #TP
        P<-length(sum[sumy$Freq>q9999,2])
        all<-dim(sum)[1]
        m[j+2]<-P-m[j+1] #FP
        N<-all-P
        m[j+3]<-T-m[j+1] #FN
        m[j+4]<-all-m[j+1]-m[j+2]-m[j+3] #TN
        j<-j+4

}

header<-c("TP_1", "FP_1", "FN_1", "TN_1", "TP_5", "FP_5", "FN_5", "TN_5", "TP_1c", "FP_1c", "FN_1c", "TN_1c", "TP_5c", "FP_5c", "FN_5c", "TN_5c")

print(header)
print(m)

f10<-as.data.frame(m)
colnames(f10)<-header
rownames(f10)<-RNAME

out10<-paste(PATH, "/fst_power_10.txt", sep="")
write.table(f10, out10, append = TRUE, quote = FALSE)

j<-0
m<-matrix(0,1,16)
for (i in 1:2){
	sum<-as.data.frame(table(t[,i], t[,30]))
	sumy<-sum[sum$Var1 == 'Y',]
	sum<-cbind(sumy, table(t$V30))
	p<-sum(sumy$Freq)/sum(sum[,5])
	q9999<-qbinom(.999,sum[,5],p)
	sumy$Freq>q9999
	sum[sumy$Freq>q9999,]
	m2<-unique(t$V30[t$V21 == 'm2' ])
        T<-length(m2)
	m[j+1]<-length(m2[unique(m2) %in% sum[sumy$Freq>q9999,2]]) #TP
	P<-length(sum[sumy$Freq>q9999,2])
	all<-dim(sum)[1]
	m[j+2]<-P-m[j+1] #FP
	N<-all-P
	m[j+3]<-T-m[j+1] #FN
	m[j+4]<-all-m[j+1]-m[j+2]-m[j+3] #TN
	j<-j+4
}

for (i in 3:4){
	sum<-as.data.frame(table(t[,i], t[,30]))
	sumy<-sum[sum$Var1 == 'Y',]
	sum<-cbind(sumy, table(t$V30))
	p<-sum(sumy$Freq)/sum(sum[,5])
	q9999<-qbinom(.999,sum[,5],p)
	sumy$Freq>q9999
	sum[sumy$Freq>q9999,]
	m2<-unique(t$V30[t$V21 == 'm2' & t$V16 > 0.05])
        T<-length(m2)
	m[j+1]<-length(m2[unique(m2) %in% sum[sumy$Freq>q9999,2]]) #TP
	P<-length(sum[sumy$Freq>q9999,2])
	all<-dim(sum)[1]
	m[j+2]<-P-m[j+1] #FP
	N<-all-P
	m[j+3]<-T-m[j+1] #FN
	m[j+4]<-all-m[j+1]-m[j+2]-m[j+3] #TN
	j<-j+4
}

header<-c("TP_1", "FP_1", "FN_1", "TN_1", "TP_5", "FP_5", "FN_5", "TN_5", "TP_1c", "FP_1c", "FN_1c", "TN_1c", "TP_5c", "FP_5c", "FN_5c", "TN_5c")

print(header)
print(m)

f20<-as.data.frame(m)
colnames(f20)<-header
rownames(f20)<-RNAME

out20<-paste(PATH, "/fst_power_20.txt", sep="")
write.table(f20, out20, append = TRUE, quote = FALSE)


