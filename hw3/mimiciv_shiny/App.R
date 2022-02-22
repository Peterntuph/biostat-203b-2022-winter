# Load packages ----
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Load data
icu_cohort <- readRDS("hw3/mimiciv_shiny/icu_cohort.rds")

# Define UI
ui <- fluidPage(
  theme = shinytheme("journal"),
  
  titlePanel("Summary Statistics & Graphs for ICU cohort"),
    sidebarLayout(
      sidebarPanel(
        helpText("Select a variable to have a deeper understanding."),         
        selectInput("region", "Region:", 
                    choices=colnames(WorldPhones)),
        hr(),
        helpText("Data from Medical Information Mart for Intensive Care")
      ),
      


# Define server function











# Create Shiny object
shinyApp(ui = ui, server = server)