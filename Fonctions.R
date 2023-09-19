# Fonctions

# Fonction pour filtrer les données
filter_data <- function(data, input, return_columns = NULL) {
  # If no column is selected, return an empty data table
  if (length(input$column) == 0) {
    return(data[0])
  }
  
  filtered_data <- data[
    Annee_unique >= input$date_range[1] &
      Annee_unique <= input$date_range[2]
  ]
  
  pattern <- input$motcle
  
  # Create a logical vector to store matches across columns
  matches <- rep(FALSE, nrow(filtered_data))
  
  # Check each selected column for matches and combine results with "OR" logic
  for (col in input$column) {
    if(input$regex){
      matches <- matches | grepl(pattern, filtered_data[[col]])
    } else {
      matches <- matches | grepl(pattern, filtered_data[[col]], fixed = TRUE)
    }
  }
  
  # Filter the data based on the combined matches
  filtered_data <- filtered_data[matches, ]
  
  # If return_columns is specified, select only those columns
  if (!is.null(return_columns)) {
    filtered_data <- filtered_data[, ..return_columns]
  }
  
  return(filtered_data)
}

plot_histogram <- function(data_frame) {
  if ("Annee_unique" %in% names(data_frame) && nrow(data_frame) > 0) {
    min_year <- min(na.omit(data_frame[, Annee_unique]))
    max_year <- max(na.omit(data_frame[, Annee_unique]))
    breaks_hist <- seq(min_year, max_year, length.out = input$num_breaks + 1)
    
    if (input$dist_type == "raw") {
      hist(data_frame()[, Annee_unique],
           main = "Distribution brute des notices",
           xlab = "Année",
           ylab = "Nombre",
           border = "blue",
           col = "lightblue",
           breaks = breaks_hist)
    } else {
      # Compute relative distribution
      filtered_counts <- hist(data_frame[, Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
      total_counts <- hist(data[data$Annee_unique %in% data_frame[, Annee_unique], Annee_unique], plot=FALSE, breaks=breaks_hist)$counts
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
}