# server.R
# Combined App!

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

# This line is the structure of a server.R file
shinyServer(function(input, output, session) {
  ### APP 1 ###
  # This output creates the dropdown menu that appears in the sidebar
  # This is created in server.R so that we only have to source helpers.R once,
  # and not every timet he app is used
  output$selectsector <- renderUI({
    selectInput("thesector", label = h5("Select a sector"),
                choices = levels(sics.copy$Sector), selected = levels(sics.copy$Sector)[63])
  })
  output$selectindustry <- renderUI({
    thesector <- input$thesector
    selectInput("industry", label = h5("Select an industry"),
                choices = unique(sics.copy%>%filter(Sector == thesector)%>%select(Industry)))
  })
  # Prints a copy of the.table filtered by whatever industry the user selects
  output$table <- renderTable({
    the.table <- filter(table.copy,Industry==as.character(input$industry))
    final.table <- the.table[,c(1,2,5:9)]
  })
  # Displays either a histogram or a scatter plot - whichever the user selects - 
  # of just the firms in the industry that the user selects
  output$switch.plot <- renderPlot({
    # First, both the histogram and scatter plot are created and stored in separate variables
    # Since these plots only depict the selected industry, the "data =" and "aes" arguments
    # include a filter command to filter the.table by industry
    industry.histo <- ggplot(data=filter(the.table,the.table$Industry==as.character(input$industry)), 
        aes(filter(the.table,the.table$Industry==as.character(input$industry))$`CEO Pay Ratio`)) +
      geom_histogram(breaks=seq(0,700, by = 25),col="red",aes(fill=..count..)) +
      labs(title = "Histogram for CEO Pay Ratio") +
      labs(x = "Firms",y = "Count")
    industry.scatter <- ggplot(data=filter(table.copy,the.table$Industry==as.character(input$industry)), 
                               aes(x = `Total Revenue`, y = `CEO Pay Ratio`, label = Company)) +
      geom_point(aes(color = "red")) +
      labs(title="Scatter Plot") +
      labs(x="Total Revenue", y="CEO Pay Ratio") +
      geom_text(size = 2, vjust = -0.75, fontface = "bold") +
      geom_smooth(method=lm)
    # This if structure tells R which plot to display on the UI based on which one the user picks
    # The if tree looks at the value of the radio buttons, the first button corresponds to 
    # the histogram, thus if input$radio==1, the tree returns the histogram, 
    # If the second button is selected, then scatter is returned
    if (input$radio==1) {
      industry.histo
    } else {
      industry.scatter
    }
  })
  # Simple renderPlot function, using the ggplot of a histogram from past exercises
  # This histogram is of all the firms in all industries
  output$full.plot <- renderPlot({
    ggplot(data=the.table, aes(the.table$`CEO Pay Ratio`)) +
      geom_histogram(breaks=seq(0,700, by = 25),col="red",aes(fill=..count..)) +
      labs(title = "Histogram for CEO Pay Ratio of All Firms") +
      labs(x = "Firms",y = "Count")
  })
  
  ### APP 2 ###
  # This line uses the action button. The action button stores its value as input$submit,
  # whenever the user changes the value of the text, and presses submit, the second argument runs:
  # it stores the ticker symbol as a character in upper case letters to "submitTicker"
  submit.ticker <- eventReactive(input$submit, {
    as.character(toupper(input$text))
  })
## The following renderText lines use the 'which' function to filter sics
## to only display company info for whichever company the user types in (by their ticker)
## This is the "Quick Hitters" section of the UI
  output$name <- renderText({
    # More detail added to the above explanation: the which command and logical 
    # expression find where/what location the.ticker is equal to the ticker of 
    # a company in the sics data frame. This location is a number.
    # Then, sics[], returns the whole row corresponding to that location. 
    # [2] pulls the 2nd entry, the name, from the row of data in sics
    # as.character makes it a character string.
    ## In summary, this command finds the company its looking for, 
    # and returns it's name as a string.
    as.character(sics[which(sics$Ticker == submit.ticker()),][2])
  })
  output$sector <- renderText({
    # This line works the same way as the one previous except [3] pulls 
    # the 3rd entry, sector name, instead of company name
    as.character(sics[which(sics$Ticker == submit.ticker()),][3])
  })
  output$industry <- renderText({
    # Again, this works the same, but [4] pulls the industry name...
    as.character(sics[which(sics$Ticker == submit.ticker()),][4])
  })
  output$number <- renderText({
    # These two lines both use a which command, one after the other. In brief, 
    # the first identifies the industry of the company that the user types in 
    # and stores this industry in the variable called 'industry'.
    # Then, the second line takes that industry, goes back to the sics data frame
    # and pulls out all of the companies in said industry. It stores the information/rows 
    # of data about all the companies in the said industry into 
    # the variable called industry.companies
    industry <- as.character(sics[which(sics$Ticker == submit.ticker()),][4])
    industry.companies <- sics.copy[which(sics.copy$Industry == industry),][,1]
    # Lastly, this returns the length of 'industrycompanies' aka. the number of companies in the industry
    length(industry.companies)
  })
## This is where the table is created:
  output$table.rank <- renderTable({
    # vector indicating the polarity of the metrics contained in the table
    polarity <- c("+", "-", "+", "+")
    # table.copy is a dataframe created in helpers.R and is a refined conjoinment 
    # of sics500, compensation, and fundamentals500. The next four which commands 
    # work very similarly to the ones above but are now searching through table.copy
    # The commands return the 6,7,8 & 9th value of table.copy, which are 2015 Revenue, CEO Pay Ratio,
    # F/M pay ratio among salaried employees, and F/M ratio of hourly workers, respectively
    # The four strings are stores in the variable 'Value'
    # Value will be one of three columns put together to form the whole table
    value <- c(as.character(table.copy[which(table.copy$Ticker == submit.ticker()),][6]),
               as.character(as.integer(table.copy[which(table.copy$Ticker == submit.ticker()),][7])),
               as.character(round(as.numeric(table.copy[which(table.copy$Ticker == submit.ticker()),][8]), 2)),
               as.character(round(as.numeric(table.copy[which(table.copy$Ticker == submit.ticker()),][9]), 2)))
    # industrycompanies is a matrix created by filtering the.table by only companies in the same industry
    # as the user-selected company - using the same/a similar which command as before
    industry.companies <- the.table[which(the.table$Industry == as.character(
      sics[which(sics$Ticker == submit.ticker()),][4])),]
    # The following four rank functions assign a rank to each company in the industrycompanies matrix
    # This is completed in four steps, one for each column to be ranked in industrycompanies, 
    # the results stores in their own variable.
    rev.rank <- rank(-industry.companies[,6])
    ceo.rank <- rank(industry.companies[,7])
    sal.rank <- rank(-industry.companies[,8])
    hrly.rank <- rank(-industry.companies[,9])
    # The final table requires just the rank of the company of interest, not all 
    # the companies in the industrycompanies matrix. Thus this line identifies 
    # where in the industrycompanies the company is located, so we can print out
    # the desired ranking
    position <- which(industry.companies$Ticker==submit.ticker())
    # This line stores the four rankings as one column to be put into the final table
    rank <- as.integer(c(rev.rank[position],ceo.rank[position],sal.rank[position],hrly.rank[position]))
    # Put the three columns together and BAM! you got a table
    # Disclaimer: The Metric column was created in Helpers.R
    beautiful.table <- data_frame(metric, polarity, value, rank)
  })
  
  ### Data Explorer Tab ###
  ## These two following sections enable the data download feature
  # the reactive switch statement assigns datasetInput to be whichever matrix/dataframe
  # the user chooses from the drop-down menu
  datasetInput <- reactive({
    switch(input$dataset,
           "sics500" = sics,
           "fundamentals500" = fund,
           "compensation" = comp,
           "Full Table" = table.copy)
  })
  output$check <- renderUI({
    checkboxGroupInput('show.vars', 'Columns in the full table to show:',
                       names(table.copy), selected = names(table.copy))
  })
  # This section I copied straight from the shiny gallery.
  # The first part creates the filename, and the last part creates the data file to be downloaded
  output$download.data <- downloadHandler(
    filename = function() {
      paste(input$dataset, '.csv', sep='')
    },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )
  output$table.explore <- renderDataTable({
    if (input$dataset=="Full Table") {
      table.copy[, input$show.vars, drop = FALSE]
    } else {
      datasetInput()
    }
  },options = list(lengthMenu = c(10, 30, 50), pageLength = 10, orderClasses = T))
})