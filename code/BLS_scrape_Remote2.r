# Header Info
#---------------------------------------------------------
library(rvest)
library(stringr)
library(dplyr)

#---------------------------------------------------------
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

# Drop the % sign so we can convert to numbers
columns = c("Total", "Men", "Women", "White", "Black.or.African.American", "Asian", "Hispanic.or.Latino")
df = df %>%
    mutate_at(vars(columns), ~ str_replace(., "%", ""))

# Convert datatypes for analysis
str(df)
df = df %>%
    mutate(across(.cols=2:8, .fns=as.numeric))
# Add a day to the date so we can format it as a date
df$Month = str_replace(df$Month," 2", " 1, 2")
df$Month = as.Date(df$Month, "%b %d, %Y")

# Set working director to the data folder and save to CSV
setwd("data")
write.csv(df, file = "BLS_Remote_Work_Data2.csv")
