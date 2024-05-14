library(shiny)
library(DBI)
library(ggplot2)

# Create SQLite database and table
con <- dbConnect(RSQLite::SQLite(), "productivity.db")
dbExecute(con, "CREATE TABLE IF NOT EXISTS productivity (
                task TEXT,
                minutes INTEGER
                )")

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Productivity Tracker"),
  
  # Sidebar layout with inputs for minutes worked on each task
  sidebarLayout(
    sidebarPanel(
      # Numeric inputs for minutes worked on each task
      numericInput("study_minutes", "Study:", value = 0, min = 0),
      numericInput("programming_minutes", "Programming:", value = 0, min = 0),
      numericInput("workout_minutes", "Workout:", value = 0, min = 0),
      actionButton("calculate", "Calculate"),
      actionButton("reset", "Reset All Values")  # Add reset button
    ),
    
    # Main panel to display productivity and plots
    mainPanel(
      h4("Productivity:"),
      verbatimTextOutput("productivity_output"),
      plotOutput("pie_chart"),
      dataTableOutput("productivity_table"),
      plotOutput("activity_stats")  # Add plot output for activity stats bar graph
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Function to calculate total time spent across all sessions
  calculate_total_time <- function() {
    # Query total time spent on each task
    productivity_data <- dbGetQuery(con, "SELECT task, SUM(minutes) as total_minutes FROM productivity GROUP BY task")
    return(productivity_data)
  }
  
  # Function to calculate stats for each activity
  calculate_activity_stats <- function() {
    # Query total time spent on each task
    activity_stats_data <- dbGetQuery(con, "SELECT task, AVG(minutes) as avg_minutes, MAX(minutes) as max_minutes, MIN(minutes) as min_minutes FROM productivity GROUP BY task")
    return(activity_stats_data)
  }
  
  # Calculate initial total time spent and activity stats
  productivity_data <- calculate_total_time()
  activity_stats_data <- calculate_activity_stats()
  
  # Display initial productivity
  output$productivity_output <- renderText({
    paste("Productivity:")
  })
  
  # Generate initial pie chart
  output$pie_chart <- renderPlot({
    pie(productivity_data$total_minutes, labels = paste(productivity_data$task, ": ", productivity_data$total_minutes, " minutes"), col = rainbow(length(productivity_data$total_minutes)))
  })
  
  # Display initial table of total time spent on each task
  output$productivity_table <- renderDataTable({
    productivity_data
  })
  
  # Generate initial activity stats bar graph
  output$activity_stats <- renderPlot({
    ggplot(activity_stats_data, aes(x = task)) +
      geom_bar(aes(y = avg_minutes), stat = "identity", fill = "steelblue", alpha = 0.7) +
      geom_errorbar(aes(ymin = min_minutes, ymax = max_minutes), width = 0.4, size = 1.5, color = "red") +
      labs(title = "Activity Statistics", x = "Activity", y = "Minutes") +
      theme_minimal()
  })
  
  # Update productivity, update database, and update table, pie chart, and activity stats when the calculate button is clicked
  observeEvent(input$calculate, {
    # Calculate total minutes worked in the current session
    total_minutes <- sum(input$study_minutes, input$programming_minutes, input$workout_minutes)
    
    # Update SQLite database with the latest values
    dbExecute(con, "INSERT INTO productivity (task, minutes) VALUES ('Study', ?)", input$study_minutes)
    dbExecute(con, "INSERT INTO productivity (task, minutes) VALUES ('Programming', ?)", input$programming_minutes)
    dbExecute(con, "INSERT INTO productivity (task, minutes) VALUES ('Workout', ?)", input$workout_minutes)
    
    # Calculate total time spent across all sessions and activity stats
    productivity_data <- calculate_total_time()
    activity_stats_data <- calculate_activity_stats()
    
    # Update productivity table
    output$productivity_table <- renderDataTable({
      productivity_data
    })
    
    # Update pie chart with new data
    output$pie_chart <- renderPlot({
      pie(productivity_data$total_minutes, labels = paste(productivity_data$task, ": ", productivity_data$total_minutes, " minutes"), col = rainbow(length(productivity_data$total_minutes)))
    })
    
    # Update activity stats bar graph with new data
    output$activity_stats <- renderPlot({
      ggplot(activity_stats_data, aes(x = task)) +
        geom_bar(aes(y = avg_minutes), stat = "identity", fill = "steelblue", alpha = 0.7) +
        geom_errorbar(aes(ymin = min_minutes, ymax = max_minutes), width = 0.4, size = 1.5, color = "red") +
        labs(title = "Activity Statistics", x = "Activity", y = "Minutes") +
        theme_minimal()
    })
  })
  
  # Define action for the reset button
  observeEvent(input$reset, {
    # Remove all data from the SQLite database
    dbExecute(con, "DELETE FROM productivity")
    
    # Reset numeric inputs to zero
    updateNumericInput(session, "study_minutes", value = 0)
    updateNumericInput(session, "programming_minutes", value = 0)
    updateNumericInput(session, "workout_minutes", value = 0)
    
    # Reset the productivity table, pie chart, and activity stats
    output$productivity_table <- renderDataTable({
      NULL  # Empty table
    })
    output$pie_chart <- renderPlot({
      NULL  # Empty plot
    })
    output$activity_stats <- renderPlot({
      NULL  # Empty plot
    })
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
