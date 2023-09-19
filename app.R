library(shiny)
library(DT)
library(shinyWidgets)
library(data.table)
library(stringr)
library(markdown)

data <- readRDS("donnees_nettes/dolq_min.RDS") |> setDT()

readme_content <- readLines("README.md", warn = FALSE)

source("Fonctions.R")

ui <- fluidPage(
  titlePanel("Dictionnaire des oeuvres littéraires du Québec, t. 1-6"),
  tabsetPanel(
    tabPanel("Recherche plein texte",
    sidebarLayout(
      sidebarPanel(
        noUiSliderInput(inputId = "date_range", 
                        label = "Sélectionner une période:",
                        min = 1830,
                        max = 1980,
                        value = c(1830, 1980),
                        format = wNumbFormat(decimals = 0),
                        tooltips = TRUE),
        br(),

        pickerInput(
          inputId = "column",
          label = h5("Choisissez les colonnes où effectuer la recherche:"),
          choices = c("Auteur_oeuvre", "Titre", "Auteur_notice", "Article",
                      "Depouillement", "Details_bibliographiques"),
          selected = "Article",
          options = list(`actions-box` = TRUE),
          multiple = TRUE
        ),
        pickerInput(
          inputId = "additional_columns",
          label = h5("Choisissez les colonnes à afficher:"),
          choices = c("Id", "Auteur_oeuvre", "Titre", "Annee_parution",  "Auteur_notice", "Article", "Volume", "Depouillement", "Details_bibliographiques"),
          selected = c("Auteur_oeuvre", "Titre", "Article"),
          options = list(`actions-box` = TRUE),
          multiple = TRUE
        ),
        textInput(
          inputId = "motcle",
          label = h5("Chaine de caractères à rechercher"),
          value = "Montréal"
        ),
        prettySwitch(
          inputId = "regex",
          label = "Utiliser une expression régulière?",
          fill = FALSE,
          status = "primary"
        ),
        downloadButton("downloadData", "Exporter le résultat (csv)"),
        width = 4,
         hr(),
        
        tags$head(tags$link(rel = "stylesheet", href = "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css")),
        
        
        h5("Antisèche - expressions régulières"),
        tags$a(href = "regex.pdf", target = "_blank",
               tags$img(src = "regex.jpg", alt = "Thumbnail", width = "100%")),
        
        hr(),
        h5("Accéder aux volumes (pdf)"),
        # Add clickable images for each volume
        tags$a(href = "https://crilcq.org/dictionnaire-des-oeuvres-litteraires-du-quebec-tome-1-des-origines-a-1900/", target = "_blank",
               tags$img(src = "DOLQ_01.jpg", alt = "Volume 1", width = "50%")),
        tags$a(href = "https://crilcq.org/dictionnaire-des-oeuvres-litteraires-du-quebec-tome-2-1900-a-1939/", target = "_blank",
               tags$img(src = "DOLQ_02.jpg", alt = "Volume 2", width = "50%")),
        tags$a(href = "https://crilcq.org/dictionnaire-des-oeuvres-litteraires-du-quebec-tome-3-1940-a-1959/", target = "_blank",
               tags$img(src = "DOLQ_03.jpg", alt = "Volume 3", width = "50%")),
        tags$a(href = "https://crilcq.org/dictionnaire-des-oeuvres-litteraires-du-quebec-tome-4-1960-1969/", target = "_blank",
               tags$img(src = "DOLQ_04.jpg", alt = "Volume 4", width = "50%")),
        tags$a(href = "https://crilcq.org/dictionnaire-des-oeuvres-litteraires-du-quebec-tome-5-1970-1975/", target = "_blank",
               tags$img(src = "DOLQ_05.jpg", alt = "Volume 5", width = "50%")),
        tags$a(href = "https://crilcq.org/dictionnaire-des-oeuvres-litteraires-du-quebec-tome-5-1970-1975/", target = "_blank",
               tags$img(src = "DOLQ_06.jpg", alt = "Volume 6", width = "50%")),
      ),
      
      mainPanel(h3("Distribution chronologique des notices"),
                
                radioButtons(inputId = "dist_type", 
                             label = "Type de distribution:",
                             choices = list("Distribution brute" = "raw", 
                                            "Distribution relative" = "relative"),
                             selected = "raw"),
                
                numericInput("num_breaks", label = "Nombre de colonnes:", value = 65, min = 1),
              
                plotOutput("histogram"),
                
                downloadButton("download_graph", "Download Graph"),
                downloadButton("download_table", "Download Table"),
                
                h3("Table"),
                textOutput("filtered_count"),
                
                DT::dataTableOutput('table'))
    )
    ),
    
    # Second tab: Documentation
    
    tabPanel("Documentation",
             uiOutput("readme") 
    )
  )
)

server <- function(input, output) {

  reactive_data <- reactive({
    filter_data(data, input, input$additional_columns)
  })
  
  reactive_data1 <- reactive({
    filter_data(data, input)
  })
  
  filtered_count <- reactive({
    nrow(reactive_data())
  })
  
  hist_data <- reactive({
    if ("Annee_unique" %in% names(reactive_data1()) && nrow(reactive_data1()) > 0) {
      # Ensure the data is numeric
      data_numeric <- as.numeric(reactive_data1()[, Annee_unique])
      
      # Remove NA values
      data_numeric <- na.omit(data_numeric)
      
      if (length(data_numeric) > 0) {
        min_year <- min(data_numeric)
        max_year <- max(data_numeric)
        breaks_hist <- seq(min_year, max_year, length.out = input$num_breaks + 1)
        
        # Raw counts
        raw_counts <- hist(data_numeric, plot=FALSE, breaks=breaks_hist)$counts
        
        # Relative counts
        total_counts <- hist(data[data$Annee_unique %in% reactive_data1()[, Annee_unique], Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
        
        relative_counts <- ifelse(total_counts == 0, 0, raw_counts / total_counts)
        
        breaks <- round(seq(min_year, max_year, length.out = length(raw_counts)))
        
        # Return data based on user's selection
        if (input$dist_type == "raw") {
          return(data.frame(Breaks = breaks, Counts = raw_counts))
        } else {
          return(data.frame(Breaks = breaks, RelativeCounts = relative_counts))
        }
      }
    }
    # Ensure a dataframe is always returned
    return(data.frame(Breaks = numeric(0), Counts = numeric(0)))
  })
  
  
  output$filtered_count <- renderText({
    paste("Nombre de notices filtrées:", filtered_count())
  })
  
  output$table <- DT::renderDataTable({
    datatable(reactive_data(), options = list(searching = FALSE), 
              callback = JS(paste0("
                table.on('draw.dt', function() {
                  var keyword = '", input$motcle, "';
                  $('td').each(function() {
                    var content = $(this).html();
                    var highlighted = content.replace(new RegExp(keyword, 'gi'), function(match) {
                      return '<span style=\"background-color: yellow;\">' + match + '</span>';
                    });
                    $(this).html(highlighted);
                  });
                });
              ")))
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("filtered_data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      fwrite(reactive_data(), file)
    }
  )
  
  output$histogram <- renderPlot({
    # Check if 'Annee_unique' column exists and has data
    if ("Annee_unique" %in% names(reactive_data1()) && nrow(reactive_data1()) > 0) {
      min_year <- min(na.omit(reactive_data1()[, Annee_unique]))
      max_year <- max(na.omit(reactive_data1()[, Annee_unique]))
      breaks_hist <- seq(min_year, max_year, length.out = input$num_breaks + 1)
      
      if (input$dist_type == "raw") {
        hist(reactive_data1()[, Annee_unique],
             main = "Distribution brute des notices",
             xlab = "Année",
             ylab = "Nombre",
             border = "blue",
             col = "lightblue",
             breaks = breaks_hist)
      } else {
        # Compute relative distribution
        filtered_counts <- hist(reactive_data1()[, Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
        total_counts <- hist(data[data$Annee_unique %in% reactive_data1()[, Annee_unique], Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
        relative_counts <- ifelse(total_counts == 0, 0, filtered_counts / total_counts)
        
        # Ensure names.arg matches the length of relative_counts
        names_for_bars <- round(seq(min_year, max_year, length.out = length(relative_counts)))
        
        barplot(relative_counts, 
                main = "Distribution relative des notices",
                xlab = "Année",
                ylab = "Fréquence relative",
                border = "blue",
                col = "lightblue",
                space = 0,
                names.arg = names_for_bars)
      }
    } else {
      plot.new()
      title(main = "No data available for the selected criteria")
    }
  })
  
  output$download_graph <- downloadHandler(
    filename = function() {
      paste("histogram_graph", Sys.Date(), ".png", sep = "_")
    },
    content = function(file) {
      png(file)
        # Check if 'Annee_unique' column exists and has data
        if ("Annee_unique" %in% names(reactive_data1()) && nrow(reactive_data1()) > 0) {
          min_year <- min(na.omit(reactive_data1()[, Annee_unique]))
          max_year <- max(na.omit(reactive_data1()[, Annee_unique]))
          breaks_hist <- seq(min_year, max_year, length.out = input$num_breaks + 1)
          
          if (input$dist_type == "raw") {
            hist(reactive_data1()[, Annee_unique],
                 main = "Distribution brute des notices",
                 xlab = "Année",
                 ylab = "Nombre",
                 border = "blue",
                 col = "lightblue",
                 breaks = breaks_hist)
          } else {
            # Compute relative distribution
            filtered_counts <- hist(reactive_data1()[, Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
            total_counts <- hist(data[data$Annee_unique %in% reactive_data1()[, Annee_unique], Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
            relative_counts <- ifelse(total_counts == 0, 0, filtered_counts / total_counts)
            
            # Ensure names.arg matches the length of relative_counts
            names_for_bars <- round(seq(min_year, max_year, length.out = length(relative_counts)))
            
            barplot(relative_counts, 
                    main = "Distribution relative des notices",
                    xlab = "Année",
                    ylab = "Fréquence relative",
                    border = "blue",
                    col = "lightblue",
                    space = 0,
                    names.arg = names_for_bars)
          }
        } else {
          plot.new()
          title(main = "No data available for the selected criteria")
        }
      dev.off()
    }
  )
  
  output$download_table <- downloadHandler(
    filename = function() {
      paste("histogram_data", Sys.Date(), ".csv", sep = "_")
    },
    content = function(file) {
      write.csv(hist_data(), file, row.names = FALSE)
    }
  )
  output$readme <- renderUI({
    # Read the content of the README.md file
    readme_content <- readLines("README.md", warn = FALSE)
    
    # Convert the markdown content to HTML for rendering in the Shiny app
    HTML(markdown::markdownToHTML(text = readme_content, fragment.only = TRUE))
  })
  
}


shinyApp(ui = ui, server = server)