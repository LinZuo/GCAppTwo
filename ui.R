# ui.R
# Combined App!

shinyUI(navbarPage("Navbar!",
tabPanel("Home",
         titlePanel("Welcome!"),
         h3("About Greener Change:"),
         p("Greener Change is a database for impact investing. Financials are important, 
           but we want you to consider the triple bottom line of a company before you 
           invest your support in them."),
         p("We have collected data on companies in the S&P 500. Feel free to consider 
           one industry at a time under the 'Industry View' tab. To look closer into one 
           company, search by ticker symbol in the 'Company View' tab. Lastly, we included 
           the data that we used to create this page under the last tab. View and download at 
           your convenience.")
         ),
tabPanel("Industry View",
         titlePanel("S&P 500 Companies"),
         sidebarLayout(
           sidebarPanel(
             # This uiOutput command prints out user interface created in the server.R file.
             # It is created in server since there are reactive components to it.
             uiOutput("selectsector"),
             uiOutput("selectindustry"),
             #selectInput("industry", "Select an industry", ""),
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
                                 uiOutput("check")),
                downloadButton('download.data', 'Download')
              ),
              mainPanel(
                dataTableOutput("table.explore")
              )
            )
        )
))