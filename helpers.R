# helpers.R
# Winter break part II


# These four lines read in the sics500.csv file and store it as two data frames
# The filter command removes companies that don't have an industry
# SICSCOPY is identical to SICS
SICS <- read.csv("Data/sics500.csv",header = T, stringsAsFactors = F)
SICS <- filter(SICS,!Industry==".Security currently not part of a SICS industry")
SICSCOPY<- read.csv("Data/sics500.csv", header = TRUE, stringsAsFactors = F)
SICSCOPY <- filter(SICSCOPY,!Industry==".Security currently not part of a SICS industry")
# SICSCOPY is slightly altered to make columns 3 & 4 factors, as opposed to characters
SICSCOPY[,3] <- as.factor(SICS[,3])
SICSCOPY[,4] <- as.factor(SICS[,4])
# Loads the fundamentals500.csv into the df FUND
FUND <- read.csv("Data/fundamentals500.csv",header = T, stringsAsFactors = F)
# Change the name of the third column of FUND to 'Total Revenue'
names(FUND)[3]<-"Total Revenue"
# The next four lines load compensation.csv and change column names
COMP <- read.csv("Data/compensation.csv",header = T, stringsAsFactors = F)
names(COMP)[20]<-"CEO Pay Ratio"
names(COMP)[21]<-"F/M Pay Ratio of Salaried Employees"
names(COMP)[22]<-"F/M Pay Ratio of Hourly Employees"
# This line trims FUND to only include the 1-3 columns, removing the extras
FUND <- FUND[,c(1:3)]
# Fund includes info from 3 years of financial data, this filters only the 2015 data
FUND <- filter(FUND,Year==2015)
# This trims the COMP frame similar to how the FUND frame was
COMP <- COMP[,c(2,20,21,22)]
# TheTable is a data frame that is a composition of the SICS, FUND, and COMP data frames
TheTable <- left_join(SICS,FUND,"Ticker") %>% left_join(COMP,"Ticker")
# Once again, a copy is made for future use. Note below, TableCopy undergoes format changes while TheTable doesn't
TableCOPY <- TheTable
# Next four lines help format the table created in server.R
# This line removes decimals from the CEO pay ratio column
TableCOPY$`CEO Pay Ratio` <- floor(TableCOPY$`CEO Pay Ratio`)
# The next two lines trim the last nine decimal places off the F/M ratio columns
TableCOPY$`F/M Pay Ratio of Salaried Employees` <- sub(".........$", "", TableCOPY$`F/M Pay Ratio of Salaried Employees`)
TableCOPY$`F/M Pay Ratio of Hourly Employees` <- sub(".........$", "", TableCOPY$`F/M Pay Ratio of Hourly Employees`)
# This line changes the revenue numbers into dollar formatted nubmers ($1,000,000.00 vs. 1000000.0000)
TableCOPY$`Total Revenue` <- dollar_format()(TableCOPY$`Total Revenue`)
# Metric is a simple variable to be used in one column of the table
Metric <- c('2015 Revenue','CEO Pay Ratio','Gender Pay Ratio (salaried)','Gender Pay Ratio (hourly)')
