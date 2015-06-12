##
## plot 3
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City ?
## Which have seen increases in emissions from 1999-2008?
## Use ggplot2 plotting system to male a plot answer this question.
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

## filter on Baltimore and extract yearly sums
d <- NEI %>% 
    filter(fips == '24510') %>% 
    left_join(SCC, by="SCC") %>%
    group_by(year, type) %>%
    summarise(sum(Emissions))

## rename cols
colnames(d) <- c('year', 'type', 'emissions')

## use year and type as factor
d$year <- as.factor(d$year)
d$type <- as.factor(d$type)

## write output in a PNG file
png(filename="./plot3.png")

## and plot
print(ggplot(d, aes(x=year, y=emissions)) 
      + geom_bar(stat='identity') 
      + ylab('Emissions (tons)') 
      + xlab('Year')
      + ggtitle("Total PM2.5 Emissions per year per source type")
      + facet_wrap(~ type))
     

## close PNG file
dev.off()
