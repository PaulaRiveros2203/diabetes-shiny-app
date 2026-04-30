library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)

# Cargar datos
df <- read.csv("diabetes.csv", stringsAsFactors = FALSE)

# UI
ui <- fluidPage(
  
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Raleway:wght@300;400;600&display=swap');
      
      body {
        background-color: #1a1a2e;
        color: #e0e0e0;
        font-family: 'Raleway', sans-serif;
      }
      .well {
        background-color: #16213e;
        border: 1px solid #0f3460;
        color: #e0e0e0;
      }
      h2 {
        color: #e94560;
        font-family: 'Raleway', sans-serif;
        font-weight: 600;
      }
      .nav-tabs > li > a {
        color: #e0e0e0;
        background-color: #16213e;
        border-color: #0f3460;
      }
      .nav-tabs > li.active > a {
        background-color: #0f3460;
        color: #ffffff;
        border-color: #0f3460;
      }
      .nav-tabs > li > a:hover {
        background-color: #0f3460;
        color: #ffffff;
      }
      label {
        color: #e0e0e0;
        font-weight: 400;
      }
      .selectize-input {
        background-color: #16213e;
        color: #e0e0e0;
        border: 1px solid #0f3460;
      }
      .selectize-dropdown {
        background-color: #16213e;
        color: #e0e0e0;
      }
      .irs--shiny .irs-bar {
        background: #e94560;
        border-top: 1px solid #e94560;
        border-bottom: 1px solid #e94560;
      }
      .irs--shiny .irs-handle {
        background: #e94560;
        border: 1px solid #e94560;
      }
      .irs--shiny .irs-from, .irs--shiny .irs-to, .irs--shiny .irs-single {
        background: #0f3460;
      }
    "))
  ),
  
  titlePanel("Análisis de Diabetes - Pima Indians Dataset"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("age", "Rango de edad:",
                  min = min(df$Age),
                  max = max(df$Age),
                  value = c(min(df$Age), max(df$Age))),
      
      selectInput("outcome", "Diagnóstico:",
                  choices = c("Todos", "No diabético", "Diabético")),
      
      sliderInput("glucose", "Nivel de glucosa:",
                  min = min(df$Glucose),
                  max = max(df$Glucose),
                  value = c(min(df$Glucose), max(df$Glucose)))
    ),
    
    mainPanel(
      tabsetPanel(
        
        tabPanel("Barras", plotOutput("barPlot")),
        tabPanel("Scatter", plotOutput("scatterPlot")),
        tabPanel("Boxplot", plotOutput("boxPlot")),
        tabPanel("Histograma", plotOutput("histPlot")),
        tabPanel("Heatmap", plotOutput("heatmapPlot"))
        
      )
    )
  )
)

# SERVER
server <- function(input, output) {
  
  # Filtrado
  df_filtrado <- reactive({
    
    data <- df %>%
      filter(Age >= input$age[1],
             Age <= input$age[2],
             Glucose >= input$glucose[1],
             Glucose <= input$glucose[2])
    
    if (input$outcome == "No diabético") {
      data <- data %>% filter(Outcome == 0)
    } else if (input$outcome == "Diabético") {
      data <- data %>% filter(Outcome == 1)
    }
    
    return(data)
  })
  
  # Gráfica 1: Barras
  output$barPlot <- renderPlot({
    ggplot(df_filtrado(), aes(x = factor(Outcome), fill = factor(Outcome))) +
      geom_bar(width = 0.55) +
      scale_fill_manual(values = c("0" = "#0072B2", "1" = "#E69F00")) +
      scale_x_discrete(labels = c("0" = "No diabético (0)", "1" = "Diabético (1)")) +
      scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
      labs(
        title    = "Prevalencia por diagnóstico · Dataset Pima Indians Diabetes",
        subtitle = "2 de cada 3 pacientes no tienen diabetes",
        x        = "Tipo de paciente",
        y        = "Cantidad de pacientes"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        legend.position    = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor   = element_blank(),
        panel.grid.major.y = element_line(color = "#e0dfd8", linewidth = 0.4),
        axis.ticks         = element_blank(),
        plot.title         = element_text(face = "bold", size = 13),
        plot.subtitle      = element_text(color = "#5f5e5a", size = 10),
        plot.margin        = margin(16, 16, 12, 16)
      )
  })
  
  
  # Gráfica 2: Scatter
  output$scatterPlot <- renderPlot({
    req(nrow(df_filtrado()) > 0)
    
    ggplot(df_filtrado(), aes(x = Age, y = Glucose, color = factor(Outcome))) +
      geom_point(alpha = 0.45, size = 1.8) +
      scale_color_manual(
        values = c("0" = "#0072B2", "1" = "#E69F00"),
        labels = c("0" = "No diabético", "1" = "Diabético")
      ) +
      labs(
        title    = "A mayor edad, más pacientes diabéticos superan el umbral de 125 mg/dL",
        subtitle = "Relación entre edad y glucosa en ayunas por diagnóstico",
        x        = "Edad (años)",
        y        = "Glucosa (mg/dL)",
        color    = NULL
      ) +
      theme_minimal(base_size = 13) +
      theme(
        legend.position      = "top",
        legend.justification = "left",
        panel.grid.minor     = element_blank(),
        panel.grid.major     = element_line(color = "#e0dfd8", linewidth = 0.4),
        axis.ticks           = element_blank(),
        plot.title           = element_text(face = "bold", size = 13),
        plot.subtitle        = element_text(color = "#5f5e5a", size = 10),
        plot.margin          = margin(16, 16, 12, 16)
      )
  })
  
  #Grafica 3 histograma
  output$histPlot <- renderPlot({
    req(nrow(df_filtrado()) > 0)
    
    ggplot(df_filtrado(), aes(x = Glucose)) +
      geom_histogram(
        bins = 30,
        fill = "#E69F00",
        color = "white"
      ) +
      labs(
        title = "Distribución de niveles de glucosa",
        subtitle = "La mayoría de pacientes se concentran entre 100 y 150 mg/dL",
        x = "Glucosa (mg/dL)",
        y = "Frecuencia"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "#e0dfd8", linewidth = 0.4),
        axis.ticks = element_blank(),
        plot.title = element_text(face = "bold", size = 13),
        plot.subtitle = element_text(color = "#5f5e5a", size = 10),
        plot.margin = margin(16, 16, 12, 16)
      )
  })
  
  #Grafica 4 box plot
  
  output$boxPlot <- renderPlot({
    req(nrow(df_filtrado()) > 0)
    
    ggplot(df_filtrado(), aes(x = factor(Outcome), y = BMI, fill = factor(Outcome))) +
      geom_boxplot(width = 0.5, outlier.alpha = 0.3, outlier.size = 1.2) +
      scale_fill_manual(
        values = c("0" = "#0072B2", "1" = "#E69F00")
      ) +
      scale_x_discrete(labels = c("0" = "No diabético", "1" = "Diabético")) +
      labs(
        title    = "Pacientes diabéticos presentan IMC mediano más alto",
        subtitle = "Distribución del índice de masa corporal por diagnóstico",
        x        = NULL,
        y        = "IMC (kg/m²)"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        legend.position    = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor   = element_blank(),
        panel.grid.major.y = element_line(color = "#e0dfd8", linewidth = 0.4),
        axis.ticks         = element_blank(),
        plot.title         = element_text(face = "bold", size = 13),
        plot.subtitle      = element_text(color = "#5f5e5a", size = 10),
        plot.margin        = margin(16, 16, 12, 16)
      )
  })
  
  # Gráfica 5: Heatmap
  output$heatmapPlot <- renderPlot({
    
    data <- df_filtrado()
    req(nrow(data) > 1)
    
    cor_matrix <- cor(data)
    cor_data <- reshape2::melt(cor_matrix)
    
    ggplot(cor_data, aes(x = Var1, y = Var2, fill = value)) +
      geom_tile(color = "white") +
      geom_text(aes(label = ifelse(abs(value) > 0.2, round(value, 2), "")), size = 3) +
      scale_fill_gradient2(
        low = "#0072B2",
        mid = "white",
        high = "#E69F00",
        midpoint = 0,
        limits = c(-1, 1)
      ) +
      labs(
        title = "Correlación entre variables del dataset",
        subtitle = "Las variables presentan correlaciones débiles con el diagnóstico de diabetes",
        x = NULL,
        y = NULL,
        fill = "Correlación"
      ) +
      theme_minimal(base_size = 13) +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank(),
        plot.title = element_text(face = "bold", size = 13),
        plot.subtitle = element_text(color = "#5f5e5a", size = 10),
        plot.margin = margin(16, 16, 12, 16)
      )
  })
}



# Ejecutar app
shinyApp(ui = ui, server = server)
