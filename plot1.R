##
## plot 1
## Have total emissions from PM2.5 decreased in the United States
## from 1999 to 2008? Using the base plotting system, make a plot
## showing the total PM2.5 emission from all sources for each of
## the years 1999, 2002, 2005, and 2008.
##

library(dplyr)

##
## load data, assumes the data is present in the working directory
##
reload <- FALSE

if (reload) {
    NEI <- readRDS("summarySCC_PM25.rds")
}

## extract yearly sums
d <- NEI %>% group_by(year) %>% summarise(sum(Emissions))

## rename cols
colnames(d) <- c('year', 'emissions')

## write output in a PNG file
png(filename="./plot1.png")

## and plot
barplot(d$emissions, names.arg = d$year, col='red', main='Total PM2.5 Emissions per year', xlab='Year', ylab='Emissions (tons)')

## close PNG file
dev.off()



