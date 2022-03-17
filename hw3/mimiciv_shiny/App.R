# Load packages ----
library(shiny)
library(shinythemes)
library(tidyverse)
library(dplyr)
library(readr)

# Load data
icu_cohort <- readRDS("icu_cohort.rds")

#select demographics, lab measurements, vitals
icu_cohort <- icu_cohort %>% 
  select(c(5,6,9,10,11,12,17:23,27:43))
icu_cohort$thirty_day_mort <- as.character(icu_cohort$thirty_day_mort)


# Define UI
ui <- fluidPage(
  theme = shinytheme("journal"),
  
  titlePanel("Summary Statistics & Graphs for ICU cohort"),
  
    sidebarLayout(
      sidebarPanel(
        helpText("Select a variable to have a deeper understanding."),
        varSelectInput("variable",
                       "Choose a variable:",
                       icu_cohort,
                       selected = "marital_status"),
        hr(),
        helpText("Data from Medical Information Mart for Intensive Care(MIMIC)")
      ),
      # Show a bar plot or box plot and summary stat
      mainPanel(
        
        plotOutput("Plot"),
        tableOutput("Contents"),
        verbatimTextOutput("Summary")
        
      )
    )
)

# Define server function
server <- function(input, output){
  
  var <- reactive({
    var_select <- icu_cohort %>%
      select(input$variable)
  })
  
  output$Plot <- renderPlot({
    if (summary(var())[2] == "Class :character  "){
      ggplot(data = icu_cohort) + 
        geom_bar(mapping = aes_string(x = input$variable, 
                                      fill = input$variable))
                     
    }else {
      ## revise
      ggplot(data = icu_cohort) + 
        geom_boxplot(mapping = aes_string(x = input$variable), 
                     color = "burlywood2", 
                     outlier.shape = NA) +
        coord_cartesian(xlim = c(boxplot.stats(var()[,1])[[1]][1],
                                 boxplot.stats(var()[,1])[[1]][5]))
    }
    
  })
  
  
  output$Contents <- renderTable({
    #show head of data
    head(var())
  })
  
  output$Summary <- renderPrint({
    if (summary(var())[2] == "Class :character  "){
      #if it's character then we use table to summarize
      table(var())
    }else{
      #if it's continuous data then we use summary()
      summary(var())
    }
  })
  
 
}

# Create Shiny object
shinyApp(ui = ui, server = server)