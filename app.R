library(dplyr)
library(ggplot2)
library(randomForest)
library(rsconnect)
library(shiny)
library(shinydashboard)

# Read data set that is processed and cleaned
ds <- read.csv("Cleaned.csv", header=TRUE)

# Data dictionary
Feature <- names(ds)
Description <- c(
    "student's age (numeric: from 15 to 22)",
    "student's home address type (binary: U - urban or R - rural)",
    "family size (binary: LE3 - less or equal to 3 or GT3 - greater than 3)",
    "parent's cohabitation status (binary: T - living together or A - apart)",
    "mother's education (numeric: 0 - none,  1 - primary education (4th grade), 2 - 5th to 9th grade, 3 - secondary education or 4 - higher education)",
    "father's education (numeric: 0 - none,  1 - primary education (4th grade), 2 - 5th to 9th grade, 3 - secondary education or 4 - higher education)",
    "home to school travel time (numeric: 1 - <15 min., 2 - 15 to 30 min., 3 - 30 min. to 1 hour, or 4 - >1 hour)",
    "weekly study time (numeric: 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours)",
    "number of past class failures (numeric: n for 0<= n <=3)",
    "extra educational support (binary: yes or no)",
    "family educational support (binary: yes or no)",
    "extra paid classes within the subject (binary: yes or no)",
    "extra-curricular activities (binary: yes or no)",
    "attended nursery school (binary: yes or no)",
    "wants to take higher education (binary: yes or no)",
    "Internet access at home (binary: yes or no)",
    "in a romantic relationship (binary: yes or no)",
    "quality of family relationships (numeric: from 1 - very bad to 5 - excellent)",
    "free time after school (numeric: from 1 - very low to 5 - very high)",
    "going out with friends (numeric: from 1 - very low to 5 - very high)",
    "current health status (numeric: from 1 - very bad to 5 - very good)",
    "number of school absences (numeric: from 0 to 93)",
    "average result for the subject within 3 period (continuos: 0 to 20)"
)
dict <- cbind(Feature, Description)

# Obtain the features that is needed to train the Random Forest Model
ds.model <- data.frame(
    Age = ds$Age,
    Time.from.home.to.school = as.factor(ds$Time.from.home.to.school),
    Number.of.past.class.failures = as.factor(ds$Number.of.past.class.failures),
    Extra.educational.support = as.factor(ds$Extra.educational.support),
    Family.educational.support = as.factor(ds$Family.educational.support),
    Extra.paid.class = as.factor(ds$Extra.paid.class),
    Extra.curricular.activity = as.factor(ds$Extra.curricular.activity),
    Attended.nursery.school = as.factor(ds$Attended.nursery.school),
    Aims.for.higher.education = as.factor(ds$Aims.for.higher.education),
    Internet.access = as.factor(ds$Internet.access),
    In.romantic.relationship = as.factor(ds$In.romantic.relationship),
    Average.result = ds$Average.result)

# Split the ds.model to train dataframe and test dataframe
dt <- sort(sample(nrow(ds.model), nrow(ds.model)*0.7))
train <- ds.model[dt,]
test <- ds.model[-dt,]

# Remove the average result from the test data frame
test <- select(test, -Average.result)

# Train the Random Forest model
model <- randomForest(formula=Average.result ~., data=train)

# Finding root mean square error
actual <- select(ds.model[-dt,], Average.result)
names(actual) <- "actual"
predicted <- predict(model, test)
cal_df <- cbind(actual, predicted)
cal_df$error <- cal_df$actual - cal_df$predicted
rmse <- sqrt(mean(cal_df$error^2))

# Plot to see the difference between the actual and predicted based on test set
value <- select(cal_df, actual)
names(value) <- "value"
index_value <- c(1:nrow(value))
group <- "Actual"
actual_df <- cbind(value, index_value, group)
value <- select(cal_df, predicted)
names(value) <- "value"
index_value <- c(1:nrow(value))
group <- "Predicted"
predicted_df <- cbind(value, index_value, group)
plot_df <- rbind(actual_df, predicted_df)

ui <- dashboardPage(
    title = "Predict your grade",
    skin = "purple",
    dashboardHeader(title = "Predict Your Grade"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("About", tabName = "about", icon = icon("info")),
            menuItem("Graph", tabName = "graph", icon = icon("chart-bar")),
            menuItem("Prediction", tabName = "prediction", icon = icon("smile-wink"))
        )
    ),
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "about",
                    fluidRow(
                        box(
                            width = 12,
                            title = "Questions",
                            h4("i.   What are the factors that can affect grade of students?"),
                            h4("ii.  How much do these factors affect grade of the students?"), 
                            h4("iii. What is the relationship between these factors?")
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12,
                            title = "Data Dictionary",
                            tableOutput("details")
                        )
                    ),
                    fluidRow(
                        box(
                            width = 12,
                            title = "Want to understand more?",
                            h3("Please go to the link: https://github.com/YeongLIM99/grade")
                        )
                    )
            ),
            tabItem(tabName = "graph",
                    fluidRow(
                        box(
                            title = "Parameter",
                            sliderInput("Population", "Choose number of students", min = 30, max = 395, value = 200),
                            # Below are inputs for graph
                            selectInput("x_axis", "Choose for X-axis", choices=names(ds), selected=names(ds)[1]),
                            selectInput("y_axis", "Choose for Y-axis", choices=names(ds), selected=names(ds)[2]),
                            # None would be represented with "." in syntax, where there will be no chosen variable 
                            selectInput('facet_row', 'Choose the facet row', choices=c(None='.', names(ds))), 
                            selectInput('facet_col', 'Choose the facet column', choices=c(None='.', names(ds)))
                        ),
                        box(
                            title = h1("Plot for variables"),
                            plotOutput("graph"),
                            helpText("Please refer to About for more information.")
                        )
                    )
                    
            ),
            tabItem(tabName = "prediction",
                    fluidRow(
                        box(
                            title = "Parameter",
                            # Below are inputs for prediction
                            checkboxGroupInput('check_box', 'Select the variable(s) to be TRUE',
                                               choiceNames=c('Extra.educational.support','Family.educational.support','Extra.paid.class',
                                                             'Extra.curricular.activity', 'Attended.nursery.school', 'Aims.for.higher.education',
                                                             'Internet.access', 'In.romantic.relationship'),
                                               choiceValues=c('Extra.educational.support','Family.educational.support','Extra.paid.class',
                                                              'Extra.curricular.activity', 'Attended.nursery.school', 'Aims.for.higher.education',
                                                              'Internet.access', 'In.romantic.relationship')
                            ),
                            selectInput('age', 'Age', choices = as.integer(levels(factor(ds$Age)))),
                            selectInput('time', 'Time.from.home.to.school', choices = c("< 15min","15 - 30min","30min - 1hour", "> 1hour")),
                            selectInput('fail', 'Number.of.past.class.failures', choices = levels(factor(ds$Number.of.past.class.failures)))
                        ),
                        box(
                            title = h1("Predict the grade"),
                            h4("Root mean square error for this prediction model"), verbatimTextOutput("rmse"),
                            h4("Plot showing difference for actual and prediction based on test dataset"), plotOutput("difference"),
                            h4("Prediction for average result of the student according to the condition chosen (0-20)"),  verbatimTextOutput("predict")
                        )
                    )
            )
        )
        
    )
)

server <- function(input, output){
    
    data_shown <- reactive({
        ds[1:input$Population,]
    })
    
    # Prevent facet row and column having same variables chosen 
    facet_row <- reactive({
        validate(
            need((input$facet_row != input$facet_col) || input$facet_row == '.', 
                 "Please choose another variable for facet row")
        )
        input$facet_row
    })
    facet_column <- reactive({
        validate(
            need((input$facet_row != input$facet_col) || input$facet_col == '.',
                 "Please choose another variable for facet row")
        )
        input$facet_col
    })
    
    # For graph tab
    output$graph <- renderPlot({
        # Jitter graph or scatter graph is drawn to show distribution for the variables
        p <- ggplot(data_shown(), aes_string(x=input$x_axis, y=input$y_axis)) +
            geom_jitter(width = 0.25, height = 0.25)
        # Declare for facet row and facet column to be shown in graph in case not a null value
        facets <- paste(facet_row(), '~', facet_column())
        if (facets != '. ~ .')
            p <- p + facet_grid(facets)
        # Output the graph
        p
    })
    
    # For prediction tab menu
    output$predict <- renderText({
        # Code the user input
        if (input$time == "< 15min") {
            time = 1
        }
        else if (input$time == "15 - 30min") {
            time = 2
        }
        else if (input$time == "30min - 1hour") {
            time = 3
        }
        else if (input$time == "> 1hour"){
            time = 4
        }
        # Let those boolean variable to be in form of factor and FALSE at neutral
        input_data <- data.frame(
            Age = as.integer(input$age),
            Time.from.home.to.school = factor(time, levels=levels(ds.model$Time.from.home.to.school)),
            Number.of.past.class.failures = factor(input$fail, levels=levels(ds.model$Number.of.past.class.failures)),
            Extra.educational.support = factor(FALSE, levels=levels(ds.model$Extra.educational.support)),
            Family.educational.support = factor(FALSE, levels=levels(ds.model$Family.educational.support)),
            Extra.paid.class = factor(FALSE, levels=levels(ds.model$Extra.paid.class)),
            Extra.curricular.activity = factor(FALSE, levels=levels(ds.model$Extra.curricular.activity)),
            Attended.nursery.school = factor(FALSE, levels=levels(ds.model$Attended.nursery.school)),
            Aims.for.higher.education = factor(FALSE, levels=levels(ds.model$Aims.for.higher.education)),
            Internet.access = factor(FALSE, levels = levels(ds.model$Internet.access)),
            In.romantic.relationship = factor(FALSE, levels=levels(ds.model$In.romantic.relationship))
        )
        # If checkbox tick for the boolean variable, set as true for those applicable
        if(length(input$check_box) > 0){
            if("Extra.educational.support" %in% input$check_box){
                input_data$Extra.educational.support = TRUE
            }
            if("Family.educational.support" %in% input$check_box){
                input_data$Family.educational.support = TRUE
            }
            if("Extra.paid.class" %in% input$check_box){
                input_data$Extra.paid.class = TRUE
            }
            if("Extra.curricular.activity" %in% input$check_box){
                input_data$Extra.curricular.activity = TRUE
            }
            if("Attended.nursery.school" %in% input$check_box){
                input_data$Attended.nursery.school = TRUE
            }
            if("Aims.for.higher.education" %in% input$check_box){
                input_data$Aims.for.higher.education = TRUE
            }
            if("Internet.access" %in% input$check_box){
                input_data$Internet.access = TRUE
            }
            if("In.romantic.relationship" %in% input$check_box){
                input_data$In.romantic.relationship = TRUE
            }
        }
        test <- rbind(test, input_data)
        testrow <- test[nrow(test), ]
        test <- test[1:nrow(test) - 1, ]
        predict(model, testrow)
    })
    # Render rsme
    output$rmse <- renderText({
        paste(sqrt(mean(cal_df$error^2)))
    })
    
    # Render prediction plot to visualize the accuracy
    output$difference <- renderPlot({
        ggplot(plot_df, aes(index_value, value, colour=group)) + geom_point() + ggtitle("Comparison between Actual and Predicted Values based on Test Dataset")  
    })
    
    # Render the data dictionary table
    output$details <- renderTable({
        dict
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
