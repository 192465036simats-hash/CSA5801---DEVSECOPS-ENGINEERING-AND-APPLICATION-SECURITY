library(shiny)
library(ggplot2)
library(DT)

ui <- fluidPage(
  
  titlePanel("DevSecOps SAST Simulation Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3("Generate Synthetic Data"),
      
      numericInput(
        "records",
        "Number of Applications",
        value = 1000,
        min = 100,
        max = 5000
      ),
      
      actionButton(
        "generate",
        "Generate Dataset"
      ),
      
      br(),
      br(),
      
      downloadButton(
        "downloadData",
        "Download CSV"
      )
      
    ),
    
    mainPanel(
      
      tabsetPanel(
        
        tabPanel(
          "Dataset",
          DTOutput("table")
        ),
        
        tabPanel(
          "Severity Analysis",
          plotOutput("severityPlot")
        ),
        
        tabPanel(
          "SAST Simulation",
          plotOutput("sastPlot")
        ),
        
        tabPanel(
          "Risk Score",
          plotOutput("riskPlot")
        ),
        
        tabPanel(
          "Summary",
          verbatimTextOutput("summary")
        )
        
      )
      
    )
    
  )
  
)

server <- function(input, output) {
  
  data <- eventReactive(input$generate, {
    
    set.seed(123)
    
    n <- input$records
    
    df <- data.frame(
      App_ID = 1:n,
      Vulnerability_Count = sample(0:20,n,replace=TRUE),
      Dependency_Risk = sample(1:10,n,replace=TRUE),
      Code_Complexity = sample(1:100,n,replace=TRUE),
      SAST_Issues = sample(0:15,n,replace=TRUE)
    )
    
    df$Risk_Score <-
      df$Vulnerability_Count*0.5 +
      df$Dependency_Risk*0.3 +
      df$SAST_Issues*0.2
    
    df$Severity <- ifelse(
      df$Risk_Score > 12,
      "High",
      ifelse(
        df$Risk_Score > 7,
        "Medium",
        "Low"
      )
    )
    
    df$SAST_Result <- ifelse(
      df$SAST_Issues > 8,
      "Failed",
      "Passed"
    )
    
    df
    
  })
  
  output$table <- renderDT({
    data()
  })
  
  output$severityPlot <- renderPlot({
    
    ggplot(
      data(),
      aes(
        x = Severity,
        fill = Severity
      )
    ) +
      geom_bar() +
      labs(
        title = "Severity Analysis",
        x = "Severity",
        y = "Count"
      )
    
  })
  
  output$sastPlot <- renderPlot({
    
    ggplot(
      data(),
      aes(
        x = SAST_Result,
        fill = SAST_Result
      )
    ) +
      geom_bar() +
      labs(
        title = "SAST Simulation Results",
        x = "Result",
        y = "Count"
      )
    
  })
  
  output$riskPlot <- renderPlot({
    
    ggplot(
      data(),
      aes(
        Risk_Score
      )
    ) +
      geom_histogram(
        bins = 20
      ) +
      labs(
        title = "Risk Score Distribution"
      )
    
  })
  
  output$summary <- renderPrint({
    
    df <- data()
    
    cat("Total Applications :", nrow(df), "\n")
    cat("High Severity :", sum(df$Severity=="High"), "\n")
    cat("Medium Severity :", sum(df$Severity=="Medium"), "\n")
    cat("Low Severity :", sum(df$Severity=="Low"), "\n")
    cat("SAST Failed :", sum(df$SAST_Result=="Failed"), "\n")
    cat("SAST Passed :", sum(df$SAST_Result=="Passed"), "\n")
    
  })
  
  output$downloadData <- downloadHandler(
    
    filename = function() {
      "security_dataset.csv"
    },
    
    content = function(file) {
      write.csv(
        data(),
        file,
        row.names = FALSE
      )
    }
    
  )
  
}

shinyApp(ui = ui, server = server)