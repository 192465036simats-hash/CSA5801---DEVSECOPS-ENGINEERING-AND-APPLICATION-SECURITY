library(shiny)
library(bslib)
library(DT)
library(ggplot2)
library(reshape2)

# Set seed for reproducible synthetic generation
set.seed(123)

# Archetype Color Palette
PALETTE <- c(
  "Cluster 1" = "#10b981", # Emerald Green
  "Cluster 2" = "#f59e0b", # Warm Amber
  "Cluster 3" = "#ef4444"  # Vibrant Red
)

APP_TITLE <- "DebtDynamics: System Dynamics Simulation of Security Debt in Agile DevSecOps"

app_theme <- bs_theme(
  version = 5,
  bootswatch = "zephyr",
  primary = "#4f46e5",
  secondary = "#06b6d4",
  success = "#10b981",
  base_font = font_google("Inter"),
  code_font = font_google("Fira Code")
)

ui <- fluidPage(
  theme = app_theme,
  
  tags$head(
    tags$style(HTML("
      body {
        background-color: #f1f5f9;
        font-family: 'Inter', sans-serif;
      }
      .app-header {
        background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #312e81 100%);
        color: #ffffff;
        padding: 24px 30px;
        border-radius: 16px;
        margin-top: 15px;
        margin-bottom: 25px;
        box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.25);
        border-left: 6px solid #6366f1;
      }
      .app-header h2 {
        margin: 0;
        font-weight: 700;
        font-size: 22px;
        letter-spacing: -0.3px;
        color: #f8fafc;
      }
      .app-header p {
        margin-top: 6px;
        margin-bottom: 0;
        color: #cbd5e1;
        font-size: 13px;
      }
      .sidebar-panel {
        background: #ffffff !important;
        border: 1px solid #e2e8f0 !important;
        border-radius: 16px !important;
        padding: 24px !important;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03) !important;
        border-top: 4px solid #4f46e5 !important;
      }
      .btn-generate {
        background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%) !important;
        color: white !important;
        font-weight: 600 !important;
        border: none !important;
        border-radius: 10px !important;
        padding: 12px !important;
        width: 100% !important;
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25) !important;
        transition: all 0.2s ease !important;
      }
      .btn-generate:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(79, 70, 229, 0.4) !important;
      }
      .nav-tabs {
        border-bottom: 2px solid #e2e8f0;
      }
      .nav-tabs .nav-link {
        font-weight: 600;
        color: #64748b;
        border: none !important;
        padding: 12px 20px;
        border-radius: 10px 10px 0 0 !important;
        transition: all 0.2s ease;
      }
      .nav-tabs .nav-link.active {
        color: #4f46e5 !important;
        background-color: #ffffff !important;
        border-bottom: 3px solid #4f46e5 !important;
        box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.02);
      }
      .main-content-card {
        background: #ffffff;
        border-radius: 16px;
        padding: 24px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        border: 1px solid #e2e8f0;
        min-height: 580px;
      }
      .summary-card {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 16px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.02);
      }
      .summary-card h4 {
        color: #475569;
        font-size: 13px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 8px;
      }
      .summary-card .stat-val {
        color: #1e293b;
        font-size: 24px;
        font-weight: 700;
      }
      .risk-cat-card {
        background: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 18px;
        margin-bottom: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.02);
      }
      .risk-badge {
        display: inline-block;
        padding: 6px 14px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 13px;
        margin-right: 8px;
      }
      .risk-low { background: #d1fae5; color: #065f46; }
      .risk-mod { background: #fef3c7; color: #92400e; }
      .risk-crit { background: #fee2e2; color: #991b1b; }
      .plot-container {
        background: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 15px;
        margin-bottom: 25px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.02);
      }
      .section-divider {
        border-top: 1px solid #e2e8f0;
        margin: 18px 0;
      }
    "))
  ),
  
  div(class = "app-header",
      h2(APP_TITLE),
      p("Interactive GMM / GAN Synthetic Data Generation & Visual Analytics Dashboard")
  ),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar-panel",
      
      radioButtons("sim_algorithm", "Simulation Algorithm:",
                   choices = c("GMM (Gaussian Mixture)" = "GMM",
                               "GAN (Generative Adversarial)" = "GAN"),
                   selected = "GMM"),
      
      numericInput("num_agents", "Number of Agents:", value = 1000, min = 100, max = 50000, step = 100),
      numericInput("random_seed", "Random Seed:", value = 123, min = 1, max = 999999),
      
      actionButton("btn_generate", "Generate Dataset", class = "btn-generate"),
      
      div(class = "section-divider"),
      
      h5("Interactive Data Filters", style = "font-size: 14px; font-weight: 700; color: #334155; margin-bottom: 12px;"),
      checkboxGroupInput("filter_clusters", "Filter Archetype Clusters:",
                         choices = c("Cluster 1", "Cluster 2", "Cluster 3"),
                         selected = c("Cluster 1", "Cluster 2", "Cluster 3")),
      sliderInput("debt_range", "Security Debt Threshold:",
                  min = 0, max = 100, value = c(0, 100))
    ),
    
    mainPanel(
      div(class = "main-content-card",
          tabsetPanel(
            id = "main_tabs",
            type = "tabs",
            
            tabPanel("Dataset", 
                     br(),
                     DTOutput("datasetTable")),
            
            tabPanel("Summary", 
                     br(),
                     fluidRow(
                       column(3, div(class = "summary-card", h4("Total Agents"), div(class = "stat-val", textOutput("statAgents")))),
                       column(3, div(class = "summary-card", h4("Avg Security Debt"), div(class = "stat-val", textOutput("statAvgDebt")))),
                       column(3, div(class = "summary-card", h4("Avg Team Size"), div(class = "stat-val", textOutput("statAvgTeam")))),
                       column(3, div(class = "summary-card", h4("Avg Scan Coverage"), div(class = "stat-val", textOutput("statAvgScan"))))
                     ),
                     br(),
                     div(class = "risk-cat-card",
                         h4("DevSecOps Risk Level Breakdown", style = "color: #334155; font-weight: 700; font-size: 15px; margin-bottom: 12px;"),
                         uiOutput("riskBreakdownUI")
                     ),
                     h4("Statistical Overview", style = "color: #334155; font-weight: 700; font-size: 16px; margin-bottom: 12px;"),
                     DTOutput("summaryTable")),
            
            tabPanel("Cluster Plot",
                     br(),
                     div(class = "plot-container",
                         plotOutput("clusterPlot", height = "480px"))
            ),
            
            tabPanel("Risk Distribution",
                     br(),
                     div(class = "plot-container",
                         plotOutput("riskDistPlot", height = "480px"))
            ),
            
            tabPanel("Scatter Plot",
                     br(),
                     div(class = "plot-container",
                         plotOutput("scatterPlot", height = "480px"))
            )
          )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Reactive values store for generated data
  rv <- reactiveValues(data = NULL)
  
  # Function to generate synthetic dataset (GMM or GAN simulation)
  generate_synthetic_data <- function(n, seed, algo) {
    set.seed(seed)
    
    # Assign cluster proportions: 45% Cluster 1, 35% Cluster 2, 20% Cluster 3
    cluster_assignment <- sample(
      c("Cluster 1", "Cluster 2", "Cluster 3"),
      size = n,
      replace = TRUE,
      prob = c(0.45, 0.35, 0.20)
    )
    
    # Pre-allocate data vectors
    team_size <- numeric(n)
    sprint_len <- numeric(n)
    commits <- numeric(n)
    debt <- numeric(n)
    vulns <- numeric(n)
    scan_cov <- numeric(n)
    
    for (i in 1:n) {
      cls <- cluster_assignment[i]
      if (cls == "Cluster 1") { # Mature / Low Risk
        team_size[i] <- round(rnorm(1, mean = 15, sd = 4))
        sprint_len[i] <- sample(c(1, 2), 1, prob = c(0.3, 0.7))
        commits[i] <- round(rnorm(1, mean = 12, sd = 3))
        debt[i] <- rnorm(1, mean = 25, sd = 8)
        vulns[i] <- round(rnorm(1, mean = 10, sd = 4))
        scan_cov[i] <- rnorm(1, mean = 82, sd = 8)
      } else if (cls == "Cluster 2") { # Moderate Risk
        team_size[i] <- round(rnorm(1, mean = 28, sd = 8))
        sprint_len[i] <- sample(c(2, 3), 1, prob = c(0.6, 0.4))
        commits[i] <- round(rnorm(1, mean = 8, sd = 3))
        debt[i] <- rnorm(1, mean = 50, sd = 12)
        vulns[i] <- round(rnorm(1, mean = 22, sd = 6))
        scan_cov[i] <- rnorm(1, mean = 58, sd = 10)
      } else { # Cluster 3 - High Risk / Critical Debt
        team_size[i] <- round(rnorm(1, mean = 45, sd = 12))
        sprint_len[i] <- sample(c(2, 3, 4), 1, prob = c(0.2, 0.5, 0.3))
        commits[i] <- round(rnorm(1, mean = 4, sd = 2))
        debt[i] <- rnorm(1, mean = 75, sd = 10)
        vulns[i] <- round(rnorm(1, mean = 38, sd = 8))
        scan_cov[i] <- rnorm(1, mean = 35, sd = 12)
      }
    }
    
    # GAN Simulation modifier (adds latent feature non-linear noise)
    if (algo == "GAN") {
      debt <- debt + sin(commits) * 3 + rnorm(n, 0, 2)
      scan_cov <- scan_cov + cos(team_size / 5) * 4
    }
    
    # Boundary Clipping
    team_size <- pmax(3, pmin(80, team_size))
    commits <- pmax(1, pmin(30, commits))
    debt <- pmax(1, pmin(100, round(debt, 2)))
    vulns <- pmax(0, pmin(100, vulns))
    scan_cov <- pmax(10, pmin(100, round(scan_cov, 2)))
    
    df <- data.frame(
      Agent_ID = paste0("AGT-", sprintf("%05d", 1:n)),
      Team_Size = team_size,
      Sprint_Length_Weeks = sprint_len,
      Commit_Frequency_Per_Day = commits,
      Security_Debt = debt,
      Vulnerabilities_Open = vulns,
      Automated_Scan_Coverage = scan_cov,
      Cluster = factor(cluster_assignment, levels = c("Cluster 1", "Cluster 2", "Cluster 3"))
    )
    return(df)
  }
  
  # Auto-generate on startup
  observe({
    if (is.null(rv$data)) {
      rv$data <- generate_synthetic_data(input$num_agents, input$random_seed, input$sim_algorithm)
    }
  })
  
  # Generate on button click
  observeEvent(input$btn_generate, {
    rv$data <- generate_synthetic_data(input$num_agents, input$random_seed, input$sim_algorithm)
  })
  
  # Filtered Data
  filtered_data <- reactive({
    req(rv$data, input$filter_clusters)
    df <- rv$data
    df <- df[df$Cluster %in% input$filter_clusters, ]
    df <- df[df$Security_Debt >= input$debt_range[1] & df$Security_Debt <= input$debt_range[2], ]
    df
  })
  
  custom_plot_theme <- function() {
    theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(hjust = 0.5, face = "bold", color = "#0f172a", size = 15),
        axis.title = element_text(face = "bold", color = "#334155"),
        axis.text = element_text(color = "#64748b"),
        panel.grid.major = element_line(color = "#f1f5f9"),
        panel.grid.minor = element_blank(),
        legend.title = element_text(face = "bold", color = "#334155"),
        legend.position = "right",
        plot.background = element_rect(fill = "#ffffff", color = NA),
        panel.background = element_rect(fill = "#ffffff", color = NA)
      )
  }
  
  # Output: Datatable
  output$datasetTable <- renderDT({
    datatable(
      filtered_data(),
      options = list(pageLength = 12, scrollX = TRUE, dom = 'ftp'),
      rownames = FALSE,
      style = "bootstrap4",
      class = "table table-hover table-striped"
    )
  })
  
  # Summary Cards
  output$statAgents <- renderText({ nrow(filtered_data()) })
  output$statAvgDebt <- renderText({ 
    df <- filtered_data()
    if(nrow(df) == 0) "0" else round(mean(df$Security_Debt), 2) 
  })
  output$statAvgTeam <- renderText({ 
    df <- filtered_data()
    if(nrow(df) == 0) "0" else round(mean(df$Team_Size), 1) 
  })
  output$statAvgScan <- renderText({ 
    df <- filtered_data()
    if(nrow(df) == 0) "0%" else paste0(round(mean(df$Automated_Scan_Coverage), 1), "%") 
  })
  
  # Risk breakdown badges
  output$riskBreakdownUI <- renderUI({
    df <- filtered_data()
    total <- nrow(df)
    if(total == 0) return(span("No data available."))
    
    low_cnt  <- sum(df$Security_Debt < 30)
    mod_cnt  <- sum(df$Security_Debt >= 30 & df$Security_Debt <= 60)
    crit_cnt <- sum(df$Security_Debt > 60)
    
    low_pct  <- round((low_cnt / total) * 100, 1)
    mod_pct  <- round((mod_cnt / total) * 100, 1)
    crit_pct <- round((crit_cnt / total) * 100, 1)
    
    tagList(
      span(class = "risk-badge risk-low", paste0("🟢 Low Risk (<30): ", low_pct, "% (", low_cnt, ")")),
      span(class = "risk-badge risk-mod", paste0("🟡 Moderate Risk (30-60): ", mod_pct, "% (", mod_cnt, ")")),
      span(class = "risk-badge risk-crit", paste0("🔴 Critical Debt (>60): ", crit_pct, "% (", crit_cnt, ")"))
    )
  })
  
  # Summary Data Table
  output$summaryTable <- renderDT({
    df <- filtered_data()[, c("Team_Size", "Sprint_Length_Weeks", "Commit_Frequency_Per_Day", "Security_Debt", "Vulnerabilities_Open", "Automated_Scan_Coverage")]
    if(nrow(df) == 0) return(NULL)
    
    summary_df <- data.frame(
      Metric = colnames(df),
      Min = apply(df, 2, min),
      Q1 = apply(df, 2, function(x) quantile(x, 0.25)),
      Median = apply(df, 2, median),
      Mean = round(apply(df, 2, mean), 2),
      Q3 = apply(df, 2, function(x) quantile(x, 0.75)),
      Max = apply(df, 2, max)
    )
    
    datatable(
      summary_df,
      options = list(dom = 't', ordering = FALSE, pageLength = 10),
      rownames = FALSE,
      style = "bootstrap4",
      class = "table table-bordered table-hover"
    )
  })
  
  # FIX: Safe Cluster Plot with stat_ellipse (prevents "argument observed missing" error)
  output$clusterPlot <- renderPlot({
    df <- filtered_data()
    req(nrow(df) > 0)
    
    p <- ggplot(df, aes(x = Team_Size, y = Security_Debt, color = Cluster)) +
      geom_point(alpha = 0.7, size = 2.5) +
      scale_color_manual(values = PALETTE) +
      custom_plot_theme() +
      labs(title = "Security Debt vs Team Size (GMM Archetypes)",
           x = "Team Size", y = "Security Debt Score", color = "Archetype")
    
    # Only render ellipses if there are enough points per group to calculate covariance
    if(nrow(df) >= 10 && length(unique(df$Cluster)) > 0) {
      p <- p + stat_ellipse(type = "norm", level = 0.8, linetype = 2, linewidth = 1)
    }
    p
  })
  
  # Risk Distribution Plot
  output$riskDistPlot <- renderPlot({
    df <- filtered_data()
    req(nrow(df) > 0)
    ggplot(df, aes(x = Security_Debt, fill = Cluster)) +
      geom_density(alpha = 0.55, color = NA) +
      geom_rug(aes(color = Cluster), alpha = 0.4) +
      scale_fill_manual(values = PALETTE) +
      scale_color_manual(values = PALETTE) +
      custom_plot_theme() +
      labs(title = "Distribution Density of Security Debt", x = "Security Debt Score", y = "Density Factor", fill = "Archetype")
  })
  
  # Scatter Plot
  output$scatterPlot <- renderPlot({
    df <- filtered_data()
    req(nrow(df) > 0)
    ggplot(df, aes(x = Commit_Frequency_Per_Day, y = Security_Debt, color = Cluster)) +
      geom_point(alpha = 0.7, size = 2.5) +
      geom_smooth(method = "lm", se = FALSE, color = "#1e293b", linetype = "dashed", linewidth = 1.1) +
      scale_color_manual(values = PALETTE) +
      custom_plot_theme() +
      labs(title = "Security Debt vs Daily Commit Frequency", x = "Commit Frequency (Per Day)", y = "Security Debt Score", color = "Archetype")
  })
}

shinyApp(ui = ui, server = server)