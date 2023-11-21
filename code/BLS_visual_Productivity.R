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
install.packages('extrafont', lib = "C:/Users/cassi/Documents/R")                                         # change to comment line after installing
# install.packages('remotes', dependencies=TRUE, verbose=TRUE)          # change to comment line after installing
remotes::install_version("Rttf2pt1", version = "1.3.8", lib = "C:/Users/cassi/Documents/R")
extrafont::font_import(path = "C:\\Users\\cassi\\AppData\\Local\\Microsoft\\Windows\\Fonts")
fonts()

# Create dataframes from BLS files
working_directory = "C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data"
setwd(working_directory)
BLS_Productivity = read.table("C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data\\bls_clean.csv", header=T, sep=",")

# Productivity: Remove rows

# Create date column from year and period
for (i in 1:nrow(BLS_Productivity)){
    if (BLS_Productivity$period[i] == 'Q01') {
        BLS_Productivity$date[i] = paste(BLS_Productivity$year[i],'03','31', sep="-")
    } 
    else if (BLS_Productivity$period[i] == 'Q02') {
        BLS_Productivity$date[i] = paste(BLS_Productivity$year[i],'06','30', sep="-")
    } 
    else if (BLS_Productivity$period[i] == 'Q03') {
        BLS_Productivity$date[i] = paste(BLS_Productivity$year[i],'09','30', sep="-")
    } else {
        BLS_Productivity$date[i] = paste(BLS_Productivity$year[i],'12','31', sep="-")
    }
}

# Change date field to "date" datatype and confirm datatypes of all columns using str()
BLS_Productivity$date = as.Date(as.character(BLS_Productivity$date), format = "%Y-%m-%d")
str(BLS_Productivity)

# Add missing 2022 data
date = c('2022-03-31', '2022-06-30', '2022-09-30')
hours = c(112.393, 113.200, 113.883)
output = c(128.365, 127.964, 128.841)
productivity = c(114.221, 113.042, 113.135)
newrows_2022 = data.frame(date, hours, output, productivity)
newrows_2022$date = as.Date(as.character(newrows_2022$date))
str(newrows_2022)
BLS_Productivity = subset(BLS_Productivity, select = -c(year, period, periodName))
BLS_Productivity = BLS_Productivity[,c(4,1,2,3)]
BLS_Productivity = rbind(BLS_Productivity, newrows_2022)

#######  PLOT THE DATA

# Start by creating a dataframe for the two rectangles which will be used later to add boxes around certain data, 
# ensuring the data types are dates to match unemployment dataframe
rects = data.frame(
  name = c('Before Lockdowns', 'During Lockdowns', 'After Lockdowns'),
  start = c('2012-01-01', '2020-03-31', '2021-12-31'),
  end = c('2020-03-31', '2021-12-31', '2022-12-31')
  )
rects$start <- as.Date(rects$start)
rects$end <- as.Date(rects$end)

# Now create variable that will be used later to productivity increase/decrease around remote work policies
firstDatex = as.Date("2018-03-30")
lineend = as.Date("2020-02-25")
linestart = as.Date("2019-01-01")

nextDatex = as.Date("2019-04-01")
nextlineend = as.Date("2021-11-30")
nextlinestart = as.Date("2019-11-30")

productivity_high =  max(BLS_Productivity$productivity)
high_x = as.Date("2013-06-30")
lineend_high = as.Date("2021-12-31")
linestart_high = as.Date("2019-12-31")

productivity_now =  last(BLS_Productivity$productivity)
now_x = as.Date("2013-06-30")
lineend_high = as.Date("2022-09-30")
linestart_high = as.Date("2021-12-31")

# Plot unemployment data using ggplot
Productvity_plot = ggplot(BLS_Productivity, aes(date, productivity)) +
  geom_line(color = "red", size = 1) +  
  scale_y_continuous(breaks = seq(100,120, by = 5), limits=c(99,117)) +                                                                  # change y-axis to go from 0 to 10
  scale_x_date(date_breaks = "12 months", date_labels = "%b-%y", limits = as.Date(c("2011-08-01","2023-03-01"))) +
  theme_bw() +                                                                                        # change the background color of the plot itself
  labs(                                                                                                 # use labs() to add labels for the axis and add titles
    title = "BLS:  Productivity from 2012-2022",
    subtitle = "Productivity Measured as Output per Hour Worked",
    x = "",
    y = "Productivity (Index: 2012=100)") +
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
    plot.subtitle = element_text(size = 16, color = "black", family = "Cooper Black"))  +            
annotate("text", x = firstDatex, y = 109.5, color = "black", size = 6,                                    
    label = "Remote Work Takes Off\nQ2 2020\nProductivity Skyrockets") +
geom_curve(data = BLS_Productivity,                                                                         
    aes(x = linestart, y = 108.8, xend = lineend, yend = 108.4),
    arrow = arrow(length = unit(0.3, 'inch')), 
    size = 1,
    color = 'red', 
    curvature = 0.2) +
annotate("text", x = nextDatex, y = 115.3, color = "black", size = 6,                                    
    label = "Return-to-Office Mandates Start\nQ1 2022\nProductivity Falls") +
geom_curve(data = BLS_Productivity,                                                                        
    aes(x = nextlinestart, y = 115.4, xend = nextlineend, yend = 115.9),
    arrow = arrow(length = unit(0.3, 'inch')), 
    size = 1,
    color = 'red', 
    curvature = .2) +
geom_rect(data = rects, inherit.aes=FALSE, mapping=aes(xmin = start, xmax = end,                    
                                    ymin = -Inf, ymax = Inf, fill = name), alpha = 0.1) +
geom_hline(yintercept = productivity_high, color = "red", size = 1.0, linetype = 2) +
annotate("text", x = high_x, y = 116.4, color = "black", size = 6,                                      
    label = "Productivity High") +
geom_hline(yintercept = productivity_now, color = "red", size = 1.0, linetype = 2) +
annotate("text", x = now_x, y = 113.5, color = "black", size = 6,                                      
    label = "Productivity Now")
Productvity_plot


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
