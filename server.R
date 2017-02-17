#THis is a test
# server.R
# winter break assignment part 2

# load packages (download using "install.packages" function if not yet installed)
library(shiny)
library(XML)
library(stringr)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(scales)



# Source file called helpers.R - should be in the same working directory as the app
source("helpers.R")

# This line is the structure of a server.R file. Always included, copy and paste from previous apps if you can't remember it
shinyServer(function(input, output) {
## The following renderText lines use the 'which' function to filter SICS
## to only display company info for whichever company the user types in (by their ticker)
## This is the "Quick Hitters" section of the UI
  output$name <- renderText({
    ## This, and all following, 'toupper' lines change the user's input to all CAPS, 
    ## and store it as the variable TheTicker. This line must be repeated inside of every render___ call.
    TheTicker <- toupper(input$text)
    # More detail added to the above explanation: the which command and logical expression find where/what location
    # TheTicker is equal to the ticker of a company in the SICS data frame. This location is a number.
    # Then, SICS[], returns the whole row corresponding to that location. [2] pulls the 2nd entry, 
    # the name, from the row of data in SICS - open SICS to see this. as. character makes it a character string.
    ## In summary, this command finds the company its looking for, and returns it's name as a string.
    as.character(SICS[which(SICS$Ticker == TheTicker),][2])
  })
  output$sector <- renderText({
    TheTicker <- toupper(input$text)
    # This line works the same way as the one previous except [3] pulls the 3rd entry, sector name, instead of company name
    as.character(SICS[which(SICS$Ticker == TheTicker),][3])
  })
  output$industry <- renderText({
    TheTicker <- toupper(input$text)
    # Again, this works the same, but [4] pulls the industry name...
    as.character(SICS[which(SICS$Ticker == TheTicker),][4])
  })
  output$number <- renderText({
    TheTicker <- toupper(input$text)
    # These two lines both use a which command, one after the other. In brief, the first identifies the industry of the company
    # that the user types in and stores this industry in the variable called 'industry'.
    # Then, the second line takes that industry, goes back to the SICS data frame and pulls out all of the companies
    # in said industry. It stores the information/rows of data about all the companies in the said industry into the variable called
    # industrycompanies
    industry <- as.character(SICS[which(SICS$Ticker == TheTicker),][4])
    industrycompanies <- SICSCOPY[which(SICSCOPY$Industry == industry),][,1]
    # Lastly, this returns the length of 'industrycompanies' aka. the number of companies in the industry
    length(industrycompanies)
  })
## This is where the table is created:
  output$table <- renderTable({
    TheTicker <- toupper(input$text)
    # TableCOPY is a dataframe created in helpers.R and is a refined conjoinment of sics500, compensation, and fundamentals500
    # The next four which commands work very similarly to the ones above but are now searching through TableCOPY
    # The commands return the 6,7,8 & 9th value of TableCOPY, which are 2015 Revenue, CEO Pay Ratio,
    # F/M pay ratio among salaried employees, and F/M ratio of hourly workers, respectively
    # The four strings are stores in the variable 'Value'
    # Value will be one of three columns put together to form the whole table
    Value <- c(as.character(TableCOPY[which(TableCOPY$Ticker == TheTicker),][6]),
               as.character(TableCOPY[which(TableCOPY$Ticker == TheTicker),][7]),
               as.character(TableCOPY[which(TableCOPY$Ticker == TheTicker),][8]),
               as.character(TableCOPY[which(TableCOPY$Ticker == TheTicker),][9]))
    # industrycompanies is a matrix created by filtering TheTable by only companies in the same industry
    # as the user-selected company - using the same/a similar which command as before
    industrycompanies <- TheTable[which(TheTable$Industry == as.character(SICS[which(SICS$Ticker == TheTicker),][4])),]
    # The following four rank functions assign a rank to each company in the industrycompanies matrix
    # This is completed in four steps, one for each column to be ranked in industrycompanies, 
    # the results stores in their own variable.
    # At the moment, 'rank' gives the lowest number a rank of 1
    RevRank <- rank(industrycompanies[,6])
    CEORank <- rank(industrycompanies[,7])
    SalRank <- rank(industrycompanies[,8])
    HrlyRank <- rank(industrycompanies[,9])
    # The final table requires just the rank of the company of interest, not all the companies in the industrycompanies matrix
    # Thus this line identifies where in the industrycompanies the company is located, so we can print out
    # the desired ranking
    Position <- which(industrycompanies$Ticker==TheTicker)
    # This line stores the four rankings as one column to be put into the final table
    TempRank <- c(RevRank[Position],CEORank[Position],SalRank[Position],HrlyRank[Position])
    # The rank function assigns the lowest value the rank of 1... This line reverses it,
    # giving the highest number a rank of 1.
    Rank <- as.integer(length(RevRank)-TempRank+1)
    # Put the three columns together and BAM! you got a table
    # Disclaimer: The Metric column was created in Helpers.R
    BeautifulTable <- data_frame(Metric,Value,Rank)
  })
})