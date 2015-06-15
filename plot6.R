##
## plot 6
##
## Compare emissions from motor vehicle sources in Baltimore City
## with emissions from motor vehicle sources in Los Angeles County, California
## (fips == 06037). Which city has seen greater changes over time in
## motor vehicle emissions?
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


d <- NEI %>%
  ## filter for baltimore and calfornia,
  filter(fips == '24510' | fips == '06037') %>% 
  ## then filter for sources related to vehicles.
  filter(SCC %in% subset_SCC$SCC) %>%
  ## Then group by year and place (fips)
  group_by(year, fips) %>%
  ## and sum.
  summarise(emissions = sum(Emissions)) %>%
  ## then group by location
  group_by(fips) %>% 
  ## and calculate % change for each location
  mutate(emissions = (emissions/first(emissions)) * 100)

## use year and fips as factor
d$year <- as.factor(d$year)
d$fips <- as.factor(d$fips)

## make fips human readable
levels(d$fips) <- c("Los Angeles", "Baltimore")
  
## write output in a PNG file
png(filename="./plot6.png")

## and plot
print(
  ggplot(d, aes(x=year, y=emissions, group=fips, colour=fips)) 
      + geom_line()
      + geom_point()
      + ylab('Emissions (%)') 
      + xlab('Year')
      + scale_y_continuous(breaks = seq(0,100,by = 10))
      + ggtitle("Change in PM2.5 Emissions in % (Vehicles)")
)


## close PNG file
dev.off()