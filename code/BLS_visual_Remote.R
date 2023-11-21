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

# Install extrafont for more font options and change to comment line after importing
# install.packages('extrafont', lib = "C:/Users/cassi/Documents/R")                                        
# install.packages('remotes', dependencies=TRUE, verbose=TRUE)        
# remotes::install_version("Rttf2pt1", version = "1.3.8", lib = "C:/Users/cassi/Documents/R")
# extrafont::font_import(path = "C:\\Users\\cassi\\AppData\\Local\\Microsoft\\Windows\\Fonts")
# fonts()

# Create dataframes from BLS files
working_directory = "C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data"
setwd(working_directory)
BLS_Remote = read.table("C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data\\BLS_Remote_Work_Data2.csv", header=T, sep=",")

# Change date field to "date" datatype and confirm datatypes of all columns using str()
BLS_Remote$Month = as.Date(as.character(BLS_Remote$Month), format = "%Y-%m-%d")
str(BLS_Remote)
BLS_Remote = subset(BLS_Remote, select = -c(X))
BLS_Remote = rename(BLS_Remote, date = Month)

# Add missing 2022 data (May, June, July, August, September)
date = c('2022-05-01', '2022-06-01', '2022-07-01', '2022-08-01', '2022-09-01')
Total =c(7.4, 7.1, 7.1, 6.5, 5.2)
Men = c(6.7, 6.4, 6.6, 6.2, 4.8)
Women = c(8.1, 7.8, 7.6, 6.9, 5.7)
White = c(6.8, 6.5, 6.5, 5.9, 4.6)
Black.or.African.American = c(6.0, 5.9, 6.1, 5.7, 4.1)
Asian = c(17.2, 15.8, 15.9, 15.3, 13.4)
Hispanic.or.Latino = c(4.2, 4.4, 4.8, 4.5, 2.8)
newrows_2022 = data.frame(date, Total, Men, Women, White, Black.or.African.American, Asian, Hispanic.or.Latino)
newrows_2022$date = as.Date(as.character(newrows_2022$date))
str(newrows_2022)
BLS_Remote = rbind(BLS_Remote, newrows_2022)

#######  PLOT THE DATA

# Create variables for important dates and telework. These can be used to customize the plot
BLS_Remote[,"date"]
x_start = BLS_Remote[1, "date"]
x_end = BLS_Remote[29,"date"]
x_change = BLS_Remote[21,"date"]

x_annotation = BLS_Remote[17,"date"]
y_annotation = 16.5
x_arrow_start = BLS_Remote[18, "date"]
y_arrow_start = 16
x_arrow_end = date_change
y_arrow_end = BLS_Remote[21, "Total"]

Total_max = max(BLS_Remote$Total)
Total_min = min(BLS_Remote$Total)

# Create rectangles to change plot colors over important dates
rects = data.frame(
  name = c('Before Policy Change', 'After Policy Change'),
  start = c(x_start, x_change),
  end = c(x_change, x_end)
  )
rects$start <- as.Date(rects$start)
rects$end <- as.Date(rects$end)

# Plot unemployment data using ggplot
Remote_Total_plot = ggplot(BLS_Remote, aes(date, Total)) +
  geom_line(color = "red", size = 1) +  
  scale_y_continuous(breaks = seq(0,40, by = 5), limits=c(1,40)) +                                                                 
  scale_x_date(date_breaks = "3 months", date_labels = "%b-%y", limits = c(x_start, x_end)) +
  theme_bw() +                                                                                        
  labs(                                                                                                
    title = "BLS:  Telework from 2020-2022",
    subtitle = "Percent of Employed who Teleworked due to Pandemic",
    x = "",
    y = "% Telework") +
theme(                                                                                                 
    legend.position = 'none',                                                                           
    panel.grid = element_line(color="gray", size = .2, linetype = 1),       
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", colour = "black", size = 2),      
    strip.background = element_rect(color = "black", size = 2),
    axis.title = element_text(size = 12, color = "black", family = "Cooper Black"),         
    axis.text.x = element_text(size = 10, color = "black", family = "Cooper Black"),
    axis.text.y = element_text(size = 10, color = "black", family = "Cooper Black"),   
    plot.title = element_text(size = 30, color = "black", family = "Cooper Black"), 
    plot.subtitle = element_text(size = 16, color = "black", family = "Cooper Black")) +
annotate("text", x = x_annotation, y = y_annotation, color = "black", size = 6, 
        label = "Return-to-Office\nMandates Start\nQ1 2022") +
geom_curve(data = BLS_Remote,   
    aes(x = x_arrow_start, y = y_arrow_start, xend = x_arrow_end, yend = y_arrow_end),
    arrow = arrow(length = unit(0.3, 'inch')), 
    size = 1,
    color = "red", 
    curvature = .2) +
geom_rect(data = rects, inherit.aes=FALSE,
          mapping = aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf, fill = name),
          alpha = 0.1) +
geom_hline(yintercept = Total_max, color = "red", size = 1, linetype = 2) +
annotate("text", x = as.Date(c("2020-07-01")), y = 36, color = "black", size = 6,                                      # annotate the highest unemployment using a text label
    label = "Telework Max") +
geom_hline(yintercept = Total_min, color = "red", size = 1, linetype = 2) +
annotate("text", x =  as.Date(c("2020-07-01")), y = 6, color = "black", size = 6,                                      # annotate the highest unemployment using a text label
    label = "Telework Min")
Remote_Total_plot


Footer
© 2022 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
