install.packages("shiny")
install.packages("ggplot2")
install.packages("DT")
library(shiny)
library(ggplot2)
library(DT)

ui <- fluidPage(
  
  titlePanel("DevSecOps Security Verification Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      h3("Security Verification"),
      
      numericInput(
        "apps",
        "Number of Applications",
        value = 1000,
        min = 100,
        max = 5000
      ),
      
      actionButton(
        "generate",
        "Run Verification"
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
          "DAST Results",
          plotOutput("dastPlot",height="500px")
        ),
        
        tabPanel(
          "SCA Results",
          plotOutput("scaPlot",height="500px")
        ),
        
        tabPanel(
          "Verification Status",
          plotOutput("verifyPlot",height="500px")
        ),
        
        tabPanel(
          "Risk Analysis",
          plotOutput("riskPlot",height="500px")
        ),
        
        tabPanel(
          "Risk Distribution",
          plotOutput("piePlot",height="500px")
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
    
    n <- input$apps
    
    df <- data.frame(
      
      App_ID = 1:n,
      
      Open_Ports = sample(1:20,n,replace=TRUE),
      
      Dependency_Risk = sample(1:10,n,replace=TRUE),
      
      SQL_Injection = sample(0:5,n,replace=TRUE),
      
      XSS = sample(0:5,n,replace=TRUE),
      
      Broken_Auth = sample(0:5,n,replace=TRUE),
      
      Vulnerable_Libraries = sample(0:10,n,replace=TRUE)
      
    )
    
    df$DAST_Score <-
      df$SQL_Injection +
      df$XSS +
      df$Broken_Auth
    
    df$DAST_Result <- ifelse(
      df$DAST_Score > 6,
      "Failed",
      "Passed"
    )
    
    df$SCA_Result <- ifelse(
      df$Dependency_Risk > 5 |
        df$Vulnerable_Libraries > 5,
      "Risky",
      "Safe"
    )
    
    df$Risk_Score <-
      (df$DAST_Score * 0.6) +
      (df$Dependency_Risk * 0.4)
    
    df$Verification_Status <- ifelse(
      df$DAST_Result == "Failed" |
        df$SCA_Result == "Risky",
      "Not Verified",
      "Verified"
    )
    
    df
    
  })
  
  output$table <- renderDT({
    
    datatable(
      security_data(),
      options = list(pageLength = 10)
    )
    
  })
  
  output$dastPlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        DAST_Result,
        fill = DAST_Result
      )
    ) +
      geom_bar() +
      theme_minimal(base_size = 15) +
      labs(
        title = "DAST Security Testing Results",
        x = "DAST Result",
        y = "Count"
      )
    
  })
  
  output$scaPlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        SCA_Result,
        fill = SCA_Result
      )
    ) +
      geom_bar() +
      theme_minimal(base_size = 15) +
      labs(
        title = "Software Composition Analysis",
        x = "SCA Status",
        y = "Count"
      )
    
  })
  
  output$verifyPlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        Verification_Status,
        fill = Verification_Status
      )
    ) +
      geom_bar() +
      theme_minimal(base_size = 15) +
      labs(
        title = "Application Verification Status",
        x = "Status",
        y = "Count"
      )
    
  })
  
  output$riskPlot <- renderPlot({
    
    ggplot(
      security_data(),
      aes(
        Dependency_Risk,
        Risk_Score,
        color = Verification_Status
      )
    ) +
      geom_point(size = 3) +
      theme_minimal(base_size = 15) +
      labs(
        title = "Risk Score Analysis",
        x = "Dependency Risk",
        y = "Risk Score"
      )
    
  })
  
  output$piePlot <- renderPlot({
    
    pie_data <- as.data.frame(
      table(
        security_data()$Verification_Status
      )
    )
    
    ggplot(
      pie_data,
      aes(
        x = "",
        y = Freq,
        fill = Var1
      )
    ) +
      geom_bar(
        stat = "identity",
        width = 1
      ) +
      coord_polar("y") +
      theme_void() +
      labs(
        title = "Verification Distribution"
      )
    
  })
  
  output$summary <- renderPrint({
    
    df <- security_data()
    
    cat("====================================\n")
    cat(" DEVSECOPS SECURITY VERIFICATION\n")
    cat("====================================\n\n")
    
    cat("Total Applications :",
        nrow(df), "\n\n")
    
    cat("DAST Passed :",
        sum(df$DAST_Result=="Passed"), "\n")
    
    cat("DAST Failed :",
        sum(df$DAST_Result=="Failed"), "\n\n")
    
    cat("Safe Dependencies :",
        sum(df$SCA_Result=="Safe"), "\n")
    
    cat("Risky Dependencies :",
        sum(df$SCA_Result=="Risky"), "\n\n")
    
    cat("Verified Applications :",
        sum(df$Verification_Status=="Verified"), "\n")
    
    cat("Not Verified Applications :",
        sum(df$Verification_Status=="Not Verified"), "\n\n")
    
    cat("Average Risk Score :",
        round(mean(df$Risk_Score),2), "\n")
    
  })
  
  output$download <- downloadHandler(
    
    filename = function() {
      "Security_Verification_Report.csv"
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