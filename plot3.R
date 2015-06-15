##
## plot 3
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City ?
## Which have seen increases in emissions from 1999-2008?
## Use ggplot2 plotting system to male a plot answer this question.
##

library(dplyr)
library(ggplot2)

##
## load data, assumes the data is present in the working directory
##
reload <- TRUE

if (reload) {
    NEI <- readRDS("summarySCC_PM25.rds")
}

## filter on Baltimore, group on years and type, then extract yearly sums
d <- NEI %>% 
    filter(fips == '24510') %>% 
    group_by(year, type) %>%
    summarise(emissions = sum(Emissions)) %>%
    ## then group by source type
    group_by(type) %>% 
    ## and calculate % change for each source type
    mutate(emissions = (emissions/first(emissions)) * 100)

## use year and type as factor
d$year <- as.factor(d$year)
d$type <- as.factor(d$type)

## write output in a PNG file
png(filename="./plot3.png")

## and plot
print(
  ggplot(d, aes(x=year, y=emissions, group=type, colour=type)) 
      + geom_line()
      + geom_point()
      + ylab('Emissions (%)') 
      + xlab('Year')
      + ggtitle("Change in PM2.5 Emissions per year per source type in Baltimore")
)
     

## close PNG file
dev.off()
