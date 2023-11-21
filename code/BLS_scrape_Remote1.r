# Header Info
#---------------------------------------------------------
library(rvest)
library(stringr)

getString <- function(myHTML, myCSS, myXpath) {
# Function gets the text from an individual HTML element
# specified by either CSS or XPATH
    if (missing(myXpath)) {
        (myString <- myHTML %>%
            html_node(myCSS) %>%
            html_text()
        )
    } else {
        (myString <- myHTML %>%
            html_node(xpath = myXpath) %>%
            html_text()
        )
    }
    return(myString)
}

getStrings <- function(myHTML, myCSS, myXpath) {
# Function gets the text from multiple HTML elements
# specified by either CSS or XPATH
    if (missing(myXpath)) {
        (myString <- myHTML %>%
            html_nodes(myCSS) %>%
            html_text()
        )
    } else {
        (myString <- myHTML %>%
            html_nodes(xpath = myXpath) %>%
            html_text()
        )
    }
    return(myString)
}

getNumber <- function(myHTML, myCSS, myXpath) {
# Function gets a number from an individual HTML element
# specified by either CSS or XPATH, and coerces to be numeric
    if (missing(myXpath)) {
        (myNumber <- myHTML %>%
            html_node(css = myCSS) %>%
            html_text() %>%
            as.numeric()
        )
    } else {
        (myNumber <- myHTML %>%
            html_node(xpath = myXpath) %>%
            html_text() %>%
            as.numeric()
        )
    }
    return(myNumber)
}

getNumbers <- function(myHTML, myCSS, myXpath) {
# Function gets numbers from multiple HTML elements
# specified by either CSS or XPATH, and coerces to be numeric
    if (missing(myXpath)) {
        (myNumber <- myHTML %>%
            html_nodes(css = myCSS) %>%
            html_text() %>%
            as.numeric()
        )
    } else {
        (myNumber <- myHTML %>%
            html_nodes(xpath = myXpath) %>%
            html_text() %>%
            as.numeric()
        )
    }
    return(myNumber)
}

getTable <- function(myHTML, myCSS, myXpath) {
# Function gets a <table> from an individual HTML element
# specified by either CSS or XPATH, and returns as a tibble
    if (missing(myXpath)) {
        (myTable <- myHTML %>%
            html_nodes(css = myCSS) %>%
            html_table(fill = TRUE)
        )
    } else {
        (myTable <- myHTML %>%
            html_nodes(xpath = myXpath) %>%
            html_table(fill = TRUE)
        )
    }
    return(myTable)
}
#---------------------------------------------------------

# Specify URL and get HTML
bls_url <- "https://www.bls.gov/opub/ted/2022/7-7-percent-of-workers-teleworked-due-to-covid-19-in-april-2022.htm"
bls_html <- read_html(bls_url)

# Specify XPATH addresses (could use CSS)
# headings_xpath <- "//table/preceding-sibling::h2[1]"
tables_xpath <- "//table[@id='BLStable_2022_5_9_10_10']"

# Scrape data using above paths and predefined funtions
# get a tibble
bls_table <- getTable(bls_html, myXpath = tables_xpath)
df = as.data.frame(bls_table)

# Drop the final row, which is nonsense not included in the original data
df = na.omit(df)

# Pivot to put the demographic groupings in one column
# with all the values in another
df <- df %>%
    pivot_longer(
        cols = -Month,
        names_to = 'group',
        values_to = 'values'
    )

# Drop the % sign so we can convert to numbers
df$values = str_replace(df$values,"%","")
df$values = as.numeric(df$values)

# Add a day to the date so we can format it as a date
df$Month = str_replace(df$Month," 2", " 1, 2")
df$Month = as.Date(df$Month, "%b %d, %Y")

# Set working director to the data folder and save to CSV
setwd("data")
write.csv(df, file = "BLS_Remote_Work_Data.csv")
