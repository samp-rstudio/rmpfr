library(shiny)
library(bslib)
library(Rmpfr)

ui <- page_sidebar(
  title = "Multiple-Precision Floating Point Calculator",
  sidebar = sidebar(
    numericInput("number", "Enter a number:", value = 1.2345),
    sliderInput("precBits", "Precision (bits):", 
                min = 32, max = 256, value = 64, step = 8),
    helpText("Standard double precision is 53 bits."),
    helpText("Higher precision shows more decimal places accurately.")
  ),
  card(
    card_header("Multiple-Precision Representation"),
    card_body(
      verbatimTextOutput("mpfrOutput"),
      verbatimTextOutput("digits")
    )
  ),
  card(
    card_header("About Multiple-Precision Floating Point"),
    card_body(
      p("The Rmpfr package provides multiple-precision floating-point arithmetic using the GNU MPFR library."),
      p("This allows for arbitrary precision arithmetic beyond the standard double precision (53 bits) in R."),
      p("Examples where high precision is useful:"),
      tags$ul(
        tags$li("Mathematical constants (π, e, etc.)"),
        tags$li("Scientific computing"),
        tags$li("Financial calculations requiring high accuracy")
      )
    )
  )
)

server <- function(input, output) {
  output$mpfrOutput <- renderPrint({
    # Create MPFR number with specified precision
    mpfr_num <- Rmpfr::mpfr(input$number, precBits = input$precBits)
    print(mpfr_num, digits = 50)
  })
  
  output$digits <- renderPrint({
    # Calculate and display approximately how many decimal digits this corresponds to
    decimal_digits <- ceiling(input$precBits * log10(2))
    cat("Approximately", decimal_digits, "decimal digits of precision\n")
    
    # Show comparison with standard R double
    cat("\nStandard R double precision:\n")
    cat(format(input$number, digits = 22), "\n")
  })
}

shinyApp(ui = ui, server = server)
