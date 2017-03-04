# helpers.R
# Combined App!


# These four lines read in the sics500.csv file and store it as two data frames
# The filter command removes companies that don't have an industry
# sics.copy is identical to sics
sics <- read.csv("Data/sics500.csv",header = T, stringsAsFactors = F)
sics <- filter(sics,!Industry==".Security currently not part of a SICS industry")
sics.copy<- read.csv("Data/sics500.csv", header = TRUE, stringsAsFactors = F)
sics.copy <- filter(sics.copy,!Industry==".Security currently not part of a SICS industry")
# sics.copy is slightly altered to make columns 3 & 4 factors, as opposed to characters
sics.copy[,3] <- as.factor(sics[,3])
sics.copy[,4] <- as.factor(sics[,4])
# Loads the fundamentals500.csv into the df fund
fund <- read.csv("Data/fundamentals500.csv",header = T, stringsAsFactors = F)
# Change the name of the third column of fund to 'Total Revenue'
names(fund)[3]<-"Total Revenue"
# The next four lines load compensation.csv and change column names
comp <- read.csv("Data/compensation.csv",header = T, stringsAsFactors = F)
names(comp)[20]<-"CEO Pay Ratio"
names(comp)[21]<-"F/M Pay Ratio of Salaried Employees"
names(comp)[22]<-"F/M Pay Ratio of Hourly Employees"
# This line trims fund to only include the 1-3 columns, removing the extras
fund <- fund[,c(1:3)]
# Fund includes info from 3 years of financial data, this filters only the 2015 data
fund <- filter(fund,Year==2015)
# This trims the comp frame similar to how the fund frame was
comp <- comp[,c(2,20,21,22)]
# the.table is a data frame that is a composition of the sics, fund, and comp data frames
the.table <- left_join(sics.copy,fund,"Ticker") %>% left_join(comp,"Ticker")
# Once again, a copy is made for future use. 
# Note below, table.copy undergoes format changes while the.table doesn't
table.copy <- the.table
# Conver the Total Revenue value from dollars to millions of dollars
table.copy$`Total Revenue` <- (table.copy$`Total Revenue`)/1000000
# Next four lines help format the table created in server.R
# This line removes decimals from the CEO pay ratio column
table.copy$`CEO Pay Ratio` <- floor(table.copy$`CEO Pay Ratio`)
# The next two lines trim the last nine decimal places off the F/M ratio columns
table.copy$`F/M Pay Ratio of Salaried Employees` <- 
  sub(".........$", "",table.copy$`F/M Pay Ratio of Salaried Employees`)
table.copy$`F/M Pay Ratio of Hourly Employees` <- 
  sub(".........$", "", table.copy$`F/M Pay Ratio of Hourly Employees`)
# This line changes the revenue numbers into dollar formatted nubmers
table.copy$`Total Revenue` <- dollar_format()(table.copy$`Total Revenue`)
# metric is a simple variable to be used in one column of the table
metric <- c('2015 Revenue [million USD]','CEO Pay Ratio',
            'Female/Male Pay Ratio (salaried)','Female/Male Pay Ratio (hourly)')
