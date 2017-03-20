# ui.R
# Combined App!

shinyUI(navbarPage("Navbar!",
tabPanel("Industry View",
         titlePanel("S&P 500 Companies"),
         sidebarLayout(
           sidebarPanel(
             # This uiOutput command prints out user interface created in the server.R file.
             # It is created in server since there are reactive components to it.
             uiOutput("select"),
             # I copy and pasted all of these widgets from the shiny gallery
             radioButtons("radio", label = h5("Select a type of plot to display"),
                          choices = list("histogram of CEO pay ratio" = 1, 
                                         "scatter plot of CEO pay ratio vs. total revenue" = 2), 
                          selected = 1)
           ),
           mainPanel(
             # Simple outputs
             h2("Industry Overview:"),
             tableOutput('table'),
             plotOutput("switch.plot"),
             plotOutput("full.plot")
           )
         )
),
tabPanel("Company View",
         titlePanel("S&P 500 Companies"),
         sidebarLayout(
           sidebarPanel(
             # Text input, prompts user to type ticker
             textInput("text", label = h5("Please enter ticker symbol:"), value = NULL),
             # Now includes a sumbit button
             actionButton("submit", "Fetch!"),
             br(),
             br(),
             # Insert the link to look up ticker symbol
             a(href="https://www.bloomberg.com/markets/symbolsearch", 
               "Bloomberg's ticker lookup", target = "_blank")
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
             tableOutput("table.rank")
           )
         )
      ),
tabPanel("Data Explorer",
            titlePanel("Explore Our Data!"),
            sidebarLayout(
              sidebarPanel(
                helpText("View and download the data used in the creation of this page"),
                selectInput("dataset", "Choose a dataset to explore:",
                            choices = c("sics500", "fundamentals500", "compensation","Full Table")),
                conditionalPanel('input.dataset=="Full Table"',
                                 helpText("Full Table is a combination of the three individual sets"),
                                 checkboxGroupInput('show.vars', 'Columns in the full table to show:',
                                                    names(table.copy), selected = names(table.copy))),
                downloadButton('download.data', 'Download')
              ),
              mainPanel(
                dataTableOutput("table.explore")
              )
            )
        )
))