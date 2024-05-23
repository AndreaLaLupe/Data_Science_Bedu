#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Sesión 8 Dashboards con Shiny, GUI

library(shiny)

# UI
ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
  
  # Dashboard layout
  dashboardPage(
    dashboardHeader(title = "Dashboard de World Happiness"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Histograma", tabName = "dashboard", icon = icon("dashboard")),
        menuItem("Dispersión", tabName = "scatter", icon = icon("area-chart")),
        menuItem("Tabla de Datos", tabName = "data_table", icon = icon("table")),
        menuItem("Heatmap Imagen", tabName = "image", icon = icon("file-picture-o")),
        menuItem("Gráfico de Línea", tabName = "line_chart", icon = icon("line-chart"))
      )
    ),
    dashboardBody(
      tabItems(
        # Histogram tab
        tabItem(tabName = "dashboard",
                fluidRow(
                  titlePanel("Histograma de World Happiness"),
                  selectInput("x", "Selecciona una variable:",
                              choices = c("GDP", "Social_support", "Life_expectancy", 
                                          "Freedom", "Generosity", "Corruption", 
                                          "Dystopia_residual", "Happiness_score")),
                  box(plotOutput("histogram", height = 250)),
                  box(
                    title = "Controles",
                    sliderInput("bins", "Número de observaciones:", 1, 30, 15)
                  )
                )
        ),
        
        # Scatterplot tab
        tabItem(tabName = "scatter",
                fluidRow(
                  titlePanel("Gráficos de Dispersión de World Happiness"),
                  selectInput("x_scatter", "Selecciona el eje X:",
                              choices = c("GDP", "Social_support", "Life_expectancy", 
                                          "Freedom", "Generosity", "Corruption", 
                                          "Dystopia_residual", "Happiness_score")),
                  selectInput("y_scatter", "Selecciona el eje Y:",
                              choices = c("GDP", "Social_support", "Life_expectancy", 
                                          "Freedom", "Generosity", "Corruption", 
                                          "Dystopia_residual","Happiness_score")),
                  box(plotOutput("scatterplot", height = 300, width = 460))
                )
        ),
        
        # Data Table tab
        tabItem(tabName = "data_table",
                fluidRow(
                  titlePanel("Tabla de Datos de World Happiness"),
                  DT::dataTableOutput("table")
                )
        ),
        
        # Image tab
        tabItem(tabName = "image",
                fluidRow(
                  titlePanel(h3("Mapa calor para la correlación de las variables")),
                  img(src = "Heatmap.png", 
                      height = 400, width = 750)
                )
        ),
        
        # Line_chart
        tabItem(tabName = "line_chart",
                fluidRow(
                  titlePanel("Gráfico de Línea de World Happiness"),
                  plotOutput("line_chart", height = 400)
                )
        )
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Histogram plot
  output$histogram <- renderPlot({
    ggplot(world_happiness, aes_string(x = input$x, fill = "Continent")) + 
      geom_histogram(bins = input$bins) +
      labs(x = input$x, y = "Frecuencia") +
      theme_light()
  })
  
  # Scatterplot
  output$scatterplot <- renderPlot({
    ggplot(world_happiness, aes_string(x = input$x_scatter, y = input$y_scatter, color = "Continent")) +
      geom_point() +
      labs(x = input$x_scatter, y = input$y_scatter) +
      theme_minimal()
  })
  
  # Data Table
  output$table <- DT::renderDataTable({
    DT::datatable(world_happiness, options = list(pageLength = 5))
  })
  
  # Gráfico de Línea
  output$line_chart <- renderPlot({
    ggplot(world_happiness, aes(x = Date, y = Happiness_score)) +
      geom_line() +
      labs(x = "Fecha", y = "Puntuación de Felicidad") +
      theme_minimal()
  })
}

shinyApp(ui, server)