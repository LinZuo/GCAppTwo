# ui.R
# winter break assignment part 2

shinyUI(fluidPage(
  titlePanel("S&P 500 Companies"
  ),
  
  sidebarLayout(
    sidebarPanel(
      # Text input, prompts user to type ticker
      textInput("text", label = h5("Please enter ticker symbol:"), value = "AAPL"),
      # Now includes a sumbit button
      submitButton("Submit")
    ),
    
    mainPanel(
      h3("Company Overview"),
      br(),
      h5("Name:"),
      textOutput("name"),
      h5("Sector:"),
      textOutput("sector"),
      h5("Industry:"),
      textOutput("industry"),
      h5("Number of Companies in the Industry:"),
      textOutput("number"),
      br(),
      ## Table with rankings printed
      h3("Data Table"),
      br(),
      tableOutput("table")
    )
  )
))