###########################################################################
###### Script for summarising MySeq reads into per well composition  #####
###########################################################################

### Clear the workspace
rm(list=ls())

### load the libraries you need
library(reshape2)
library(ggplot2)
library(akima)
library(plyr)
library(dplyr)
library(ggplot2bdc)
library(ggExtra)
library(grid)
library(gridExtra)
library(RColorBrewer)
library(scales)

########################################################################################
################### stacked bar charts of well composition   ###########################
########################################################################################

### read in the data - this is the read count output from metaBEAT, I have manually removed the .biom header line and the taxonomy column as this make live a lot easier in R
#my.reads<-read.csv(file=paste("data2/metaBEAT-by-taxonomy-readcounts_hardTrim.blast.tsv",sep=""), sep="\t", stringsAsFactors=FALSE, header=TRUE)
my.reads<-read.csv(file=paste("data2/Just_BLAST-by-taxonomy-readcounts.blast.tsv",sep=""), sep="\t", stringsAsFactors=FALSE, header=TRUE)

### read in the sample by plate data - this is the querymap file used in metaBEAT with additional columns for PCR plate
my.plates<-read.csv(file="data2/sample_metadata.csv", stringsAsFactors=FALSE, header=TRUE)

### trim the plate data to the necessary columns
my.plates<-my.plates[,1:3]

### greedy regex to split the sample string by the underscore and leave us with a column for nest and a column for indentifier
my.plates<-cbind(my.plates, do.call(rbind, strsplit(as.character(my.plates$sample), "_|_.*_")))

### trim the plate data to the necessary columns (i.e. drop the identifier column)
my.plates<-my.plates[,c(1,2,3,5)]
### name the columns
colnames(my.plates)<-c("sample","plate","plate.numeric","nest")

### set a minimum occurance for an assignment to be trusted - i.e. at this point you can decide that taxa in only one sample might be considered unreliable, in which case set occurance=2
occurance=1

### subset the data frame to drop all assignments occuring fewer than the frequency specified above
my.reads.subs<-my.reads
#my.reads.subs<-subset(my.reads, subset = rowSums(my.reads[2:ncol(my.reads)] > 0) >= occurance)

### transpose the read data
my.reads.trans<-my.reads.subs
#my.reads.trans<-recast(my.reads.subs, variable~OTU_ID)
colnames(my.reads.trans)[1]<-"sample"
#my.reads.trans$sample<-as.character(my.reads.trans$sample)

### use match to add the plate data to the read data
my.reads.trans$plate<-my.plates$plate[match(my.reads.trans$sample,my.plates$sample)]
my.reads.trans$plate.numeric<-my.plates$plate.numeric[match(my.reads.trans$sample,my.plates$sample)]

### use match to add the nest data to the read data
my.reads.trans$nest<-my.plates$nest[match(my.reads.trans$sample,my.plates$sample)]
#my.reads.trans$nest.numeric<-my.plates$nest.numeric[match(my.reads.trans$sample,my.plates$sample)]

my.reads.trans$type<-ifelse(my.reads.trans$nest=="Negative","Negative",
                            ifelse(my.reads.trans$nest=="DNApositive","DNApositive",
                                   ifelse(my.reads.trans$nest=="PCRpositive","PCRpositive","Sample")))

### make sample and plate factors for faceting and ordering
my.reads.trans$sample<-as.factor(my.reads.trans$sample)
my.reads.trans$plate<-as.factor(my.reads.trans$plate)

### total all the reads
my.reads.trans$total<-rowSums(my.reads.trans[c(2:9)])
### calculate the percentage of reads in each well that are OPM
my.reads.trans$Percent.Thau<-ifelse(my.reads.trans$total>0,(my.reads.trans$Thaumetopoea_processionea/my.reads.trans$total)*100,0)

### set a minimum read coverage for accepting an assignment, this will have no effect right now as the minimum read depth in metaBEAT is 50
cutoff<-10

### replace all the species that are less than the cutoff of the total reads with zero
my.reads.trans[,2:9][my.reads.trans[,2:9] < cutoff] <- 0

### subset the data frame to drop all coloumns containing only zeros
my.reads.trans.nozero<-cbind(my.reads.trans[,c(1, 10:15)], subset(my.reads.trans[,c(2:9)], select = colSums(my.reads.trans[,c(2:9)]) !=0))

#Reorder my.reads.trans.drop so that samples are arranged by decreasing %OPM
#my.reads.trans.nozero<-arrange(my.reads.trans.nozero, #what we are arranging
 #                              type, #sort by sample type first
  #                             desc(Percent.Thau),   # then sort by %OPm or you end up splitting out the regular samples without OPM (i.e. fails)
   #                            desc(total)) 

my.reads.trans.nozero<-my.reads.trans.nozero[with(my.reads.trans.nozero, order(-total)), ]
my.reads.trans.nozero<-my.reads.trans.nozero[with(my.reads.trans.nozero, order(-Percent.Thau)), ]
my.reads.trans.nozero<-my.reads.trans.nozero[with(my.reads.trans.nozero, order((Carcelia_iliaca/total))), ]
my.reads.trans.nozero<-my.reads.trans.nozero[with(my.reads.trans.nozero, order(type)), ]
write.csv(my.reads.trans.nozero, file="checking_sorting.csv")

### remove the total variable
my.reads.trans.drop<-my.reads.trans.nozero[,c(1:5,7:15)]

### to remove the positive and negative samples for OTU counting in a barplot, I need to iteratively subset them out using the nest column.
### I've not found a more elegant way of doing this yet
my.reads.trans.samps.only<-my.reads.trans.drop[my.reads.trans$type != "Negative", ]
my.reads.trans.samps.only<-my.reads.trans.samps.only[my.reads.trans.samps.only$type != "DNApositive", ]
my.reads.trans.samps.only<-my.reads.trans.samps.only[my.reads.trans.samps.only$type != "PCRpositive", ]

### order the type for ordering the samples in the plot
my.reads.trans.drop$type <- factor(my.reads.trans.drop$type,
                                   levels=c("Sample","DNApositive","PCRpositive","Negative"))

# Create a plotting order
my.reads.trans.drop$order<-factor(seq(1, nrow(my.reads.trans.drop),1))


### make a panel factor after setting the decreasing OPM order
my.reads.trans.drop$panel<-as.factor(c(rep(1,times=length(my.reads.trans.drop$sample)/4),
                                       rep(2,times=length(my.reads.trans.drop$sample)/4),
                                       rep(3,times=length(my.reads.trans.drop$sample)/4),
                                       rep(4,times=length(my.reads.trans.drop$sample)/4)))

### melt the data into long format
my.reads.melt<-melt(my.reads.trans.drop, id.vars=c("sample","plate", "plate.numeric","Percent.Thau","nest","type","panel","order"))
colnames(my.reads.melt)<-c("Sample","Plate","Plate.numeric","Percent.Thau","Nest","Type","Panel","Order","Species","Reads")
my.reads.melt$Sample<-as.character(my.reads.melt$Sample)

### create an ID variable for the order
#my.reads.melt$level.order<-seq(1, length(my.reads.melt$Percent.Thau),1)

### see what species remain after filtering
#levels(my.reads.melt$Species)

### order the species for plotting the legend
#my.reads.melt$Species <- factor(levels(my.reads.melt$Species)[c("Thaumetopoea_processionea",
 #                                  "Carcelia_iliaca",
  #                                 "Compsilura_concinnata",
   #                                "Tachinidae",
    #                               "Beaveria_bassiana",
     #                              "Ascomycota",
      #                             "Astatotilapia_calliptera",
       #                            "unassigned")])

#my.reads.melt$Species <- factor(my.reads.melt$Species, levels =
 #                                   c("Thaumetopoea_processionea",
  #                                    "Carcelia_iliaca",
   #                                   "Compsilura_concinnata",
    #                                  "Tachinidae",
     #                                 "Beaveria_bassiana",
      #                                "Ascomycota",
       #                               "Astatotilapia_calliptera",
        #                              "unassigned")) ###reorders levels according to this order

### order the species for plotting the legend
#my.colours <- c("#6b0572",
 #               "#085104",
  #              "#0b7205",
   #             "#FDFF00",
    #            "#a30811",
     #           "#0f9207",
      #          "#9a08a3",
       #         "#000000")

### order the samples from highest OPM % to lowest and in increasing plate number
#my.reads.melt$Sample <- reorder(-my.reads.melt$Percent.Thau, my.reads.melt$Plate.numeric)

### create a nice colour scale using colourRampPalette and RColorBrewer
#vivid.colours2<-brewer.pal(length(unique(my.reads.melt$Species)),"Set1")

### count the columns greater than zero and write to a new data frame - this is used for the barplot below the composition diagram
hit.hist<-data.frame(OTUs = rowSums(my.reads.trans.samps.only[c(7:12)] != 0), Type=my.reads.trans.samps.only$type)

########################################################################################
################### make a plot of % composition by PCR plate  ######################################
########################################################################################
svg(file="well_composition_reads_by_plate_Croydon.svg", width=10, height=8)
### set up the ggplot
well.composition<-ggplot(data=my.reads.melt, aes(x=Order, y=Reads, fill=Species)) +
  ### make it a stacked barplot and set the bars to be the same height
  geom_bar(position="fill", stat="identity") +
  ### wrap the plot by plate
  facet_wrap(~Panel, scales="free_x", nrow=4, ncol=1) +
  ### give it a percentage scale
  scale_y_continuous(labels = percent_format()) +
  ### set the colours
 # scale_fill_manual(name="Species",
  #                    values = my.colours) +
  #scale_fill_manual(name="Species", labels=c("Thaumetopoea_processionea",
   #                                         "Carcelia_iliaca",
    #                                        "Compsilura_concinnata",
     #                                       "Tachinidae",
      #                                      "Beaveria_bassiana",
       #                                     "Ascomycota",
        #                                    "Astatotilapia_calliptera",
         #                                   "unassigned"),
          #          values = my.colours) +
  ### add a sensible y axis label
  labs(y = "% of reads per well", x="PCR wells") +
  ### rotate the x-axis labels and resize the text for the svg
  theme(#axis.text.x = element_blank(),
        axis.text.x = element_text(size = rel(0.3), colour = "black", angle=90),
        axis.ticks.x=element_blank(),
        axis.text.y = element_text(size = rel(1.1), colour="black"),
        axis.title.y = element_text(size = rel(1), vjust=2),
        axis.title.x = element_text(size = rel(1), vjust=-1.3),
        legend.text = element_text(size = rel(1), face="italic"),
        legend.title = element_text(size = rel(1)),
        strip.text.x = element_blank(),
        strip.background=element_blank(),
        legend.position = "bottom",
        legend.background = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=0.1),
        plot.margin=unit(c(0.1, 0.1, 1, 1), "lines"))

### Make a ggplot object of our OTU counts
c<- ggplot(hit.hist, aes(factor(reorder(OTUs, -OTUs)))) +
  geom_bar(alpha=0.5, fill="#3399ff") + labs(y = "Frequency", x="OTUs per well") +
  coord_flip() +
  ### rotate the x-axis labels and resize the text for the svg
  theme(axis.text = element_text(size = rel(1.1), colour="black"),
        axis.title.y = element_text(size = rel(1), vjust=2),
        axis.title.x = element_text(size = rel(1), vjust=-1),
        panel.grid.minor = element_blank(),
        axis.line = element_blank(),
        plot.margin=unit(c(0.1, 0.1, 1, 1), "lines"))

grid.arrange(well.composition, c, heights=c(3/4, 1/4), ncol=1)

dev.off()

########################################################################################
# work out percentage parasitism with carcelia #
########################################################################################

### divide the number of well containing Carcelia by all well that are not +ve or -ve to get percentage
percent.cacelia<-(colSums(my.reads.trans[3] > 0)/1152)*100

