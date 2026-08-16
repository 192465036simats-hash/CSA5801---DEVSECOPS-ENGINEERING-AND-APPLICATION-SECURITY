install.packages("shiny")
install.packages("ggplot2")
install.packages("DT")
install.packages("corrplot")
library(shiny)
library(ggplot2)
library(DT)
library(corrplot)

ui <- fluidPage(
  
  titlePanel("DevSecOps Vulnerability Analysis Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3("Vulnerability Analysis"),
      
      numericInput(
        "records",
        "Number of Applications",
        value = 1000,
        min = 100,
        max = 5000
      ),
      
      actionButton(
        "generate",
        "Analyze Vulnerabilities"
      ),
      
      br(),
      br(),
      
      downloadButton(
        "download",
        "Download Report"
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
          "Risk Distribution",
          plotOutput("riskPlot")
        ),
        
        tabPanel(
          "Vulnerability Trend",
          plotOutput("trendPlot")
        ),
        
        tabPanel(
          "Performance Dashboard",
          plotOutput("performancePlot")
        ),
        
        tabPanel(
          "Correlation Heatmap",
          plotOutput("heatmapPlot")
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
  
  security_data <- eventReactive(input$generate, {
    
    set.seed(123)
    
    n <- input$records
    
    df <- data.frame(
      
      App_ID = 1:n,
      
      Vulnerabilities = sample(0:20,n,replace=TRUE),
      
      SAST_Issues = sample(0:15,n,replace=TRUE),
      
      DAST_Issues = sample(0:15,n,replace=TRUE),
      
      Dependency_Risk = sample(1:10,n,replace=TRUE),
      
      Security_Score = sample(70:100,n,replace=TRUE)
      
    )
    
    df$Risk_Score <-
      (df$Vulnerabilities * 0.4) +
      (df$SAST_Issues * 0.2) +
      (df$DAST_Issues * 0.2) +
      (df$Dependency_Risk * 0.2)
    
    df$Severity <- ifelse(
      df$Risk_Score > 15,
      "Critical",
      ifelse(
        df$Risk_Score > 10,
        "High",
        ifelse(
          df$Risk_Score > 5,
          "Medium",
          "Low"
        )
      )
    )
    
    df
    
  })
  
  output$table <- renderDT({
    
    datatable(
      security_data(),
      options = list(pageLength = 10)
    )
    
  })
  
  output$severityPlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        Severity,
        fill = Severity
      )
    ) +
      geom_bar() +
      theme_minimal(base_size = 15) +
      labs(
        title = "Vulnerability Severity Analysis",
        x = "Severity",
        y = "Count"
      )
    
  })
  
  output$riskPlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        Risk_Score
      )
    ) +
      geom_histogram(
        bins = 20,
        fill = "tomato",
        color = "black"
      ) +
      theme_minimal(base_size = 15) +
      labs(
        title = "Risk Score Distribution",
        x = "Risk Score",
        y = "Frequency"
      )
    
  })
  
  output$trendPlot <- renderPlot({
    
    trend <- aggregate(
      Vulnerabilities ~ App_ID,
      data = security_data(),
      mean
    )
    
    ggplot(
      trend[1:100,],
      aes(
        App_ID,
        Vulnerabilities
      )
    ) +
      geom_line(color = "blue") +
      theme_minimal(base_size = 15) +
      labs(
        title = "Vulnerability Trend",
        x = "Application ID",
        y = "Vulnerability Count"
      )
    
  })
  
  output$performancePlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        Security_Score,
        Risk_Score
      )
    ) +
      geom_point(
        color = "darkgreen",
        size = 3
      ) +
      geom_smooth(
        method = "lm",
        color = "red",
        se = FALSE
      ) +
      theme_minimal(base_size = 15) +
      labs(
        title = "Security Performance Dashboard",
        x = "Security Score",
        y = "Risk Score"
      )
    
  })
  
  output$heatmapPlot <- renderPlot({
    
    corr_data <- cor(
      security_data()[,
                      c("Vulnerabilities",
                        "SAST_Issues",
                        "DAST_Issues",
                        "Dependency_Risk",
                        "Security_Score",
                        "Risk_Score")]
    )
    
    corrplot(
      corr_data,
      method = "color"
    )
    
  })
  
  output$summary <- renderPrint({
    
    df <- security_data()
    
    cat("====================================\n")
    cat(" DEVSECOPS VULNERABILITY ANALYSIS\n")
    cat("====================================\n\n")
    
    cat("Total Applications :",
        nrow(df), "\n\n")
    
    cat("Critical :",
        sum(df$Severity=="Critical"), "\n")
    
    cat("High :",
        sum(df$Severity=="High"), "\n")
    
    cat("Medium :",
        sum(df$Severity=="Medium"), "\n")
    
    cat("Low :",
        sum(df$Severity=="Low"), "\n\n")
    
    cat("Average Risk Score :",
        round(mean(df$Risk_Score),2), "\n")
    
    cat("Average Security Score :",
        round(mean(df$Security_Score),2), "\n")
    
  })
  
  output$download <- downloadHandler(
    
    filename = function() {
      "Vulnerability_Report.csv"
    },
    
    content = function(file) {
      
      write.csv(
        security_data(),
        file,
        row.names = FALSE
      )
      
    }
    
  )
  
}

shinyApp(ui = ui, server = server)