##
## plot 4
## Across the United States, how have emissions from coal combustion-related
## sources changed from 1999-2008?
##

library(dplyr)
library(ggplot2)

## avoid printing exp.. just for clarity
options(scipen=999)

##
## load data, assumes the data is present in the working directory
##
reload <- FALSE

if (reload) {
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
}

## extract the Coal related sources. I assume that a refernce to the
## word "coal" in the source name.
l <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
subset_SCC <- SCC[l,]

## filter for sources related to Coal emissions.
## Then group by year 
## and sum.
d <- NEI %>%
    filter(SCC %in% subset_SCC$SCC) %>%
    group_by(year) %>%
    summarise(sum(Emissions))

## rename cols
colnames(d) <- c('year', 'emissions')

## use year as factor
d$year <- as.factor(d$year)

## write output in a PNG file
png(filename="./plot4.png")

## and plot
print(ggplot(d, aes(x=year, y=emissions)) 
      + geom_bar(stat='identity') 
      + ylab('Emissions (tons)') 
      + xlab('Year')
      + ggtitle("US Total PM2.5 Emissions per year (Coal combustion)"))


## close PNG file
dev.off()