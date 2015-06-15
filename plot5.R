##
## plot 5
##
## How have emissions from motor vehicle sources changed from 1999-2008 
## in Baltimore City
##

library(dplyr)
library(ggplot2)

## avoid printing exp.. just for clarity
options(scipen=999)

##
## load data, assumes the data is present in the working directory
##
reload <- TRUE

if (reload) {
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

## to find the interesting sources, I selected the sources with the
## word "vehicle" in their name
l <- grepl("vehicle", SCC$Short.Name, ignore.case = TRUE)
subset_SCC <- SCC[l,]

## filter for baltimore,
## then for sources related to vehicles.
## Then group by year 
## and sum.
d <- NEI %>%
  filter(fips == '24510') %>% 
  filter(SCC %in% subset_SCC$SCC) %>%
  group_by(year) %>%
  summarise(emissions = sum(Emissions))

## use year as factor
d$year <- as.factor(d$year)

## write output in a PNG file
png(filename="./plot5.png")

## and plot
print(ggplot(d, aes(x=year, y=emissions)) 
      + geom_bar(stat='identity') 
      + ylab('Emissions (tons)') 
      + xlab('Year')
      + ggtitle("Baltimore Total PM2.5 Emissions per year (Vehicles)"))


## close PNG file
dev.off()
