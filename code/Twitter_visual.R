# Load Libraries for plotting and color reference
library(ggplot2)
.libPaths()
# GGPlot2 Quick Color Reference
# http://sape.inf.usi.ch/quick-reference/ggplot2/colour
d=data.frame(c=colors(), y=seq(0, length(colors())-1)%%66, x=seq(0, length(colors())-1)%/%66)
ggplot() +
  scale_x_continuous(name="", breaks=NULL, expand=c(0, 0)) +
  scale_y_continuous(name="", breaks=NULL, expand=c(0, 0)) +
  scale_fill_identity() +
  geom_rect(data=d, mapping=aes(xmin=x, xmax=x+1, ymin=y, ymax=y+1), fill="white") +
  geom_rect(data=d, mapping=aes(xmin=x+0.05, xmax=x+0.95, ymin=y+0.5, ymax=y+1, fill=c)) +
  geom_text(data=d, mapping=aes(x=x+0.5, y=y+0.5, label=c), colour="black", hjust=0.5, vjust=1, size=3)

# Install extrafont for more font options
# install.packages('extrafont', lib = "C:/Users/cassi/Documents/R")                                         # change to comment line after installing
# install.packages('remotes', dependencies=TRUE, verbose=TRUE)          # change to comment line after installing
# remotes::install_version("Rttf2pt1", version = "1.3.8", lib = "C:/Users/cassi/Documents/R")
# extrafont::font_import(path = "C:\\Users\\cassi\\AppData\\Local\\Microsoft\\Windows\\Fonts")
# fonts()

# Create dataframe and transform data as needed
working_directory = "C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data"
setwd(working_directory)
Sentiment = read.csv("C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data\\Tweets_with_Sentiment.csv", header=T, sep=",") 
head(Sentiment)
str(Sentiment)
# Remove extra characters at the end of date/time (created_at) and change to date/time datatype
library(stringr) 
Sentiment$created_at = str_sub(Sentiment$created_at, end = -7)
Sentiment$created_at = as.Date(as.character(Sentiment$created_at, "%Y-%m-%d H:M:S"))

labels = table(Sentiment$label)

# Plot data
Sentiment_plot = ggplot(Sentiment, aes(x = label, fill = label)) +
  geom_bar() +
  stat_count(geom = "text", size = 16, aes(label = after_stat(count))) +
    scale_y_continuous(breaks = seq(0,500, by = 100), limits=c(0,500)) +                                                                  # change y-axis to go from 0 to 10
    theme_bw() +                                                                                        # change the background color of the plot itself
    labs(                                                                                                 # use labs() to add labels for the axis and add titles
    title = "Twitter Sentiment for Return-to-Office Policies",
    subtitle = "Data Pulled Q4 2022",
    x = "",
    y = "Number Tweets") +
    theme(                                                                                                 
    legend.title = element_text(
      family = "Calibri",
      colour = "black",
      face = "bold",
      size = 16),
    legend.position = c(1, 1),
    legend.justification = c(1, 1),
    legend.background = element_rect(fill = "white", colour = "black"),
    panel.grid = element_line(color="white"),       
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", colour = "black", linewidth = 2),      
    strip.background = element_rect(color = "black", size = 2),
    axis.title = element_text(size = 16, color = "black", family = "Cooper Black"),         
    axis.text.x = element_text(size = 16, color = "black", family = "Cooper Black"),
    axis.text.y = element_text(size = 16, color = "black", family = "Cooper Black"),   
    plot.title = element_text(size = 30, color = "black", family = "Cooper Black"), 
    plot.subtitle = element_text(size = 16, color = "black", family = "Cooper Black"))
Sentiment_plot


