##
## plot 2
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make
## a plot answering this question.
##

library(dplyr)

##
## load data, assumes the data is present in the working directory
##
reload <- FALSE

if (reload) {
    NEI <- readRDS("summarySCC_PM25.rds")
}

## filter on Baltimore and extract yearly sums
d <- NEI %>% filter(fips == '24510') %>% group_by(year) %>% summarise(sum(Emissions))

## rename cols
colnames(d) <- c('year', 'emissions')

## write output in a PNG file
png(filename="./plot2.png")

## and plot
barplot(d$emissions, names.arg = d$year, col='red', main='Total PM2.5 Emissions per year for the city of Baltimore', xlab='Year', ylab='Emissions (tons)')

## close PNG file
dev.off()
