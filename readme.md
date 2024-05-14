
# Productivity Tracker
https://github.com/ProgrammerPratik/R-projects/assets/84035830/eed48d05-a293-488b-8afa-6ca1708b721c

## Overview

This is a simple Shiny web application for tracking productivity. Users can input the minutes worked on different tasks, such as studying, programming, and working out. The application then calculates and displays productivity metrics and generates visualizations like pie charts and bar graphs.

## Prerequisites

Before running this application, make sure you have the following prerequisites installed:

1. R programming language: Install R from the official website [here](https://www.r-project.org/).

2. RStudio (optional but recommended): Install RStudio from the official website [here](https://www.rstudio.com/products/rstudio/download/).

3. Required R packages:
   - Shiny: Install using `install.packages("shiny")` within R or RStudio.
   - DBI: Install using `install.packages("DBI")` within R or RStudio.
   - ggplot2: Install using `install.packages("ggplot2")` within R or RStudio.
   - RSQLite: Install using `install.packages("RSQLite")` within R or RStudio.

## Running the Application

1. Download or clone this repository to your local machine.

2. Open RStudio (if installed) or R.

3. Set your working directory to the location where you downloaded/cloned the repository.

4. Open the `productivity-tracker-using-shiny.R` file in RStudio or run the code directly in R.

5. Run the application by executing the code (`shinyApp(ui = ui, server = server)`).

6. The application should open in your default web browser. If not, check the R console for the application URL.

## Usage

- Enter the minutes worked for each task in the input fields on the left sidebar.
- Click the "Calculate" button to update productivity metrics and visualizations.
- Use the "Reset All Values" button to clear data and start over.

## Support

For any issues or questions, please contact me [here](mailto:psmerekar@gmail.com).