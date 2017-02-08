# ui.R
# winter break assignment part 2

shinyUI(fluidPage(
  titlePanel("S&P 500 Companies"
  ),
  
  sidebarLayout(
    sidebarPanel(
      # Text input, prompts user to type ticker
      textInput("text", label = h5("Type ticker symbol here:"), value = "AAPL"),
      # Now includes a sumbit button
      submitButton("Fetch!")
    ),
    
    mainPanel(
      h2("Company Overview"),
      ## Quick-hitters section - simple text outputs to display name, sector, industry, and number, all generated in server.R
      h3("Quick-Hitters:"),
      h5("Name:"),
      textOutput("name"),
      h5("Sector:"),
      textOutput("sector"),
      h5("Industry:"),
      textOutput("industry"),
      h5("Number of Companies in the Industry:"),
      textOutput("number"),
      ## Table with rankings printed
      h3("Table"),
      tableOutput("table")
    )
  )
))