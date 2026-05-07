#Remotely Close Associations:
#Openness to Experience and Semantic Memory Structure
#Alexander P. Christensen, University of North Carolina at Greensboro
#Yoed N. Kenett, University of Pennsylvannia
#Katherine N. Cotter, University of North Carolina at Greensboro
#Roger E. Beaty, Harvard University
#Paul J. Silvia, University of North Carolina at Greensoboro

#read in data
#FINAL fluency.csv
raw <- read.csv(file.choose(),as.is=TRUE)

#load SemNetCleaner package
library(SemNetCleaner)

#automated cleaning function
cleaned <- semnetcleaner(raw, miss = 99)

#grab cleaned responses and binary data
resp <- cleaned$responses
bin <- cleaned$binary

#de-string using binary data
#set char to determine character length to de-string
de <- autoDeStr(binary, char = 10)

#SAVED FILE AS: de-stringed.csv


#converge using de-stringed binary data
con <- autoConverge(de)

#SAVED FILE AS: Cleaning File.Rdata

#need to converge catefrog to "cat" and "frog"
#catefrog into cat and frog
#find column
which(colnames(con)=="catefrog")
#find participant who gave response
which(con[,55]!=0)
#credit response for cat and frog
con[314,c("cat","frog")]<-1
#remove catefrog
con[,-55]

#SAVED FILE AS: FINAL Cleaning File.Rdata

#check for missing cases
which(rowSums(con)==0)
raw[386,2]
#manual input for case 386
con[386,c("cat","dog","fish","elephant","tiger","zebra","monkey","giraffe","lion","dolphin","chicken","squirrel")]<-1
#check for missing cases
which(rowSums(con)==0)
raw[499,2]
#manual input for case 499
con[499,c("dog","cat","mouse","moose","horse","lion","tiger","bear","deer","pig","cow")]<-1

#SAVED FINAL Cleaning File.Rdata

finalFull <- con

#pair IDs to responses
IDedResp <- cbind(raw[,1],finalFull)

#load latent variable
#FINAL open.csv
latent <- read.csv(file.choose())

#grab Cronbach's alpha
library(psych)
bfasOpen <- latent[,10:19]
bfasInt <- latent[,20:29]
neo <- latent[,30:41]

alpha(bfasOpen)$total[2]
alpha(bfasInt)$total[2]
alpha(neo)$total[2]

#combine latent variable with responses
comb <- as.data.frame(cbind(latent$no_int,IDedResp))
#changes column names
colnames(comb)[1:2] <- c("latent","id")

#create groups
low <- comb[order(comb$latent),][1:258,]
high <- comb[order(comb$latent),][259:516,]

#remove latent variable and ids
deLow <- low[,-c(1,2)]
deHigh <- high[,-c(1,2)]

#unique responses
onlyH <- deHigh[,which(colSums(deHigh)>=1)]
onlyL <- deLow[,which(colSums(deLow)>=1)]

uniH <- colnames(onlyH)
uniL <- colnames(onlyL)

#count of unique responses not given by the other group
length(setdiff(uniH,uniL))
length(setdiff(uniL,uniH))

#total unique responses across both groups
uniT <- unique(c(uniH,uniL))
#total number of unique responses
length(uniT)

#unique response given by each group
oneH <- match(uniT,uniH)
oneL <- match(uniT,uniL)

#create matrix for mcnemar test
chitest <- matrix(0,nrow=length(uniT),ncol=2)

#give '1' for a response and '0' if not
chitest[,1] <- ifelse(!is.na(oneH),1,0)
chitest[,2] <- ifelse(!is.na(oneL),1,0)

#number of unique responses by group
colSums(chitest)

#mcnemar test
mcnemar.test(chitest[,1],chitest[,2])
#effect size
sqrt(mcnemar.test(chitest[,1],chitest[,2])$statistic/length(uniT))

#correlate number of responses with Openness to Experience
sumAll <- rowSums(comb[,-c(1,2)])
cor.test(sumAll,comb$latent)

#get low and high participant sum responses
sumLow <- rowSums(deLow)
sumHigh <- rowSums(deHigh)

#t-test for group differences
t.test(sumHigh,sumLow,var.equal = TRUE)

#remove responses given by one or no participants
finLow <- finalize(deLow)
finHigh <- finalize(deHigh)

#equate nodes
eq <- equate(finLow,finHigh)

low <- eq$rmatA
high <- eq$rmatB

#network analysis
#load NetworkToolbox package
library(NetworkToolbox)

#cosine similarity matrices
cosLow <- cosine(low, addConstant = .01)
cosHigh <- cosine(high, addConstant = .01)

#change diagonals to 1
diag(cosHigh) <- 1
diag(cosLow) <- 1

#create networks
netLow <- TMFG(cosLow)$A
netHigh <- TMFG(cosHigh)$A

#semantic network measures
semnetmeas(netLow, swm = "rand")
semnetmeas(netHigh, swm = "rand")

#check when responses of 1 are included
lowOne <- deLow[which(colSums(deLow)>=1)]
highOne <- deHigh[which(colSums(deHigh)>=1)]

#check when not equated
noEqLow <- semnetmeas(TMFG(cosine(lowOne))$A,swm="rand")
noEqHigh <- semnetmeas(TMFG(cosine(highOne))$A,swm="rand")


#check when equated
eq2 <- equate(lowOne,highOne)

eq2Low <- eq2$rmatA
eq2High <- eq2$rmatB

cosLow1 <- cosine(eq2Low, addConstant = .01)
cosHigh1 <- cosine(eq2High, addConstant = .01)

netLow1 <- TMFG(cosLow1)$A
netHigh1 <- TMFG(cosHigh1)$A

semnetmeas(netLow1, swm = "rand")
semnetmeas(netHigh1, swm = "rand")

#partial network bootstrapped approach
#nodedrop list
nodedrop <- list()
#iterations = 1000
iter <- 1000

nodedrop$fifty <- partboot(high,low,n=ncol(high)*.50,iter=iter,corr="cosine",cores=4,weighted=TRUE)
nodedrop$sixty <- partboot(high,low,n=ncol(high)*.60,iter=iter,corr="cosine",cores=4)
nodedrop$seventy <- partboot(high,low,n=ncol(high)*.70,iter=iter,corr="cosine",cores=4)
nodedrop$eighty <- partboot(high,low,n=ncol(high)*.80,iter=iter,corr="cosine",cores=4)
nodedrop$ninety <- partboot(high,low,n=ncol(high)*.90,iter=iter,corr="cosine",cores=4)

#partial network bootstrapped tests
partboot.test(nodedrop$ninety)
partboot.test(nodedrop$eighty)
partboot.test(nodedrop$seventy)
partboot.test(nodedrop$sixty)
partboot.test(nodedrop$fifty)

#plot partial network bootstrapped approach
#labels
labs <- c("50High","50Low",
          "60High","60Low",
          "70High","70Low",
          "80High","80Low",
          "90High","90Low")

#create plots
plots <- partboot.plot(nodedrop,paired=TRUE,labels=labs)

#view plots
#ASPL
plots$aspl$plot
#CC
plots$cc$plot
#Q
plots$q$plot
#S
plots$s$plot

#create Cytoscape input
highCyto <- convert2cytoscape(netHigh)
lowCyto <- convert2cytoscape(netLow)

#write file to input to Cytoscape
write.csv(highCyto,"high_open_cyto.csv",row.names=FALSE)
write.csv(lowCyto,"low_open_cyto.csv",row.names=FALSE)