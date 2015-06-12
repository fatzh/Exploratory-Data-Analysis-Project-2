##
## plot 4
## Across the United States, how have emissions from coal combustion-related
## sources changed from 1999-2008?
##

library(dplyr)
library(ggplot2)
##
## load data, assumes the data is present in the working directory
##
reload <- TRUE

if (reload) {
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
}

## filter the SCC data to include only the coal combustion-related information
t <- SCC %>%
    filter(grepl("Coal", EI.Sector))

## filter on Baltimore and extract yearly sums
d <- NEI %>% 
    left_join(t, by="SCC") %>%
    group_by(year) %>%
    summarise(sum(Emissions))

## rename cols
##colnames(d) <- c('year', 'type', 'emissions')

## use year and type as factor
d$year <- as.factor(d$year)

## write output in a PNG file
##png(filename="./plot3.png")

## and plot
#ggplot(d, aes(x=year, y=emissions)) 
#      + geom_bar(stat='identity') 
#      + ylab('Emissions (tons)') 
#      + xlab('Year')
#      + ggtitle("Total PM2.5 Emissions per year per source type")
#      + facet_wrap(~ type)


## close PNG file
##dev.off()
