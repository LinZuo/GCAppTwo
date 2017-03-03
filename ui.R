# ui.R
# Combined App!

shinyUI(navbarPage("Navbar!",
tabPanel("Industry View",
         titlePanel("S&P 500 Companies"
         ),
         
         sidebarLayout(
           sidebarPanel(
             # This uiOutput command prints out user interface created in the server.R file.
             # It is created in server since there are reactive components to it.
             uiOutput("select"),
             # selectInput("industry", label = h5("Select an industry"), 
             #             choices = levels(SICSCOPY$Industry), 
             #             selected = 1),
             # I copy and pasted all of these widgets from the shiny gallery
             # The only one that required some specialization was the selectInput
             # I wanted a dropdown with all the industries, and didn't want to type out 80 something names
             # The "choices =" argument allows me to put in all the levels of the the SICS$Industry vector
             # Reminder, the levels function returns the unique factors found in that vector
             # selectInput("industry", label = h5("Select an industry"), 
             #             choices = levels(SICS$Industry), 
             #             selected = 1),
             radioButtons("radio", label = h5("Select a type of plot to display"),
                          choices = list("histogram of CEO pay ratio" = 1, 
                                         "scatter plot of CEO pay ratio vs. total revenue" = 2), 
                          selected = 1),
             helpText("Download the data used in the creation of this page"),
             selectInput("dataset", "Choose a dataset to download:",
                         choices = c("Sics", "Fundamentals", "Compensation")),
             downloadButton('downloadData', 'Download')
           ),
           
           mainPanel(
             # Simple outputs
             h2("Industry Overview:"),
             tableOutput('table'),
             plotOutput("SwitchPlot"),
             plotOutput("FullPlot")
           )
         )
         ),
tabPanel("Company View",
         titlePanel("S&P 500 Companies"
         ),
         
         sidebarLayout(
           sidebarPanel(
             # Text input, prompts user to type ticker
             textInput("text", label = h5("Please enter ticker symbol:"), value = NULL),
             # Now includes a sumbit button
             actionButton("submit", "Fetch!"),
             br(),
             br(),
             # Insert the link to look up ticker symbol
             a(href="https://www.bloomberg.com/markets/symbolsearch", "Bloomberg's ticker lookup", target = "_blank")
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
             tableOutput("tablerank")
           )
         )
)
))