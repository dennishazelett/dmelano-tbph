setwd("/Users/hazelettd/Desktop/projects/dmelano-tbph/")
library(ggplot2)
library(grid)

datafiles <- read.delim2("inventory.txt",  header = TRUE)
datafiles <- subset(datafiles, experiment=="EJPs", drop = TRUE)
records   <- read.delim2("recordings.txt", header = TRUE)


# expand recordings to include file metadata
records$genotype <- character(nrow(records))
records$electrode.resistance <- numeric(nrow(records))
records$input.resistance <- numeric(nrow(records))
records$calcium  <- numeric(nrow(records))
records$muscle   <- numeric(nrow(records))
records$sex      <- numeric(nrow(records))

# only for recordings logged in file inventory
usethis <- records$File %in% datafiles$File

# populate data from inventory.txt into recordings dframe
for (i in 1:length(usethis)) {
  if (isTRUE(usethis[i])) {
    matchrows <- subset(datafiles, File == as.character(records$File[i,drop=TRUE]))
    records$genotype[i]             <- as.character(matchrows$Genotype[1])
    records$electrode.resistance[i] <- matchrows$Electrode.Resistance..MOhm.[1]
    records$input.resistance[i]     <- matchrows$Input.Resistance..MOhm.[1]
    records$calcium[i]              <- matchrows$Calcium[1]
    records$muscle[i]               <- matchrows$Muscle[1]
    records$sex[i]                  <- matchrows$Sex[1]
  }
}

sum(is.na(records$genotype))/nrow(records)

ggplot(data=subset(records, calcium==3), aes(x=as.numeric(max_Vm))) + geom_density(fill="grey65") + facet_wrap(~genotype) + ylim(c(0,6e-3))

