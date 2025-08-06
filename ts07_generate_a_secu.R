# ts07_generate_a_secu.R

# Load necessary libraries
library(shiny)
library(shinydashboard)
library(crypto)

# Define UI
ui <- dashboardPage(
  dashboardHeader(title = "Secure Chatbot Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Chat", icon = icon("chat"), tabName = "chat", selected = TRUE)
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "chat",
              h2("Secure Chat"),
              textInput("message", "Enter message:"),
              actionButton("send", "Send"),
              verbatimTextOutput("chat_log")
      )
    )
  )
)

# Define server
server <- function(input, output) {
  # Initialize chat log
  chat_log <- reactiveValues(text = "")
  
  # Encrypt and decrypt functions
  encrypt <- function(text) {
    AES_encrypt(text, "my_secret_key")
  }
  
  decrypt <- function(text) {
    AES_decrypt(text, "my_secret_key")
  }
  
  # Send message
  observeEvent(input$send, {
    message <- input$message
    encrypted_message <- encrypt(message)
    chat_log$text <- paste0(chat_log$text, "You: ", decrypt(encrypted_message), "\n")
    output$chat_log <- renderText({
      chat_log$text
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)