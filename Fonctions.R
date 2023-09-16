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




