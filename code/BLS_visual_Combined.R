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

# Create dataframes from BLS files
working_directory = "C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data"
setwd(working_directory)
BLS_Productivity = read.table("C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data\\bls_clean.csv", header=T, sep=",")
BLS_Remote = read.table("C:\\Users\\cassi\\Documents\\MSIS-5193\\Project\\project-deliverable-2-return-to-work\\data\\BLS_Remote_Work_Data2.csv", header=T, sep=",")


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

BLS_Remote$Month = as.Date(as.character(BLS_Remote$Month), format = "%Y-%m-%d")
str(BLS_Remote)
BLS_Remote = subset(BLS_Remote, select = -c(X))
BLS_Remote = rename(BLS_Remote, date = Month)

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


# MERGE AND SORT THE DATA
head(BLS_Productivity)
head(BLS_Remote)
BLS_Combined = full_join(BLS_Remote, BLS_Productivity, 
                       by = c("date" = "date"))
# BLS_Combined[order(as.Date(BLS_Combined$date, format="%Y-%m-%d")),]
library(lubridate)
BLS_Combined = BLS_Combined %>% arrange(ymd(BLS_Combined$date))
# Remove extra columns
BLS_Combined2 = subset(BLS_Combined, select = -c(Men, Women, White, Black.or.African.American, Asian, Hispanic.or.Latino, hours, output))
BLS_Combined2 = rename(BLS_Combined2, Telework = Total, Productivity = productivity)
# Use reshape2 to conform data for plot with both values, ignoring NA values
# install.packages('reshape2', lib = "C:/Users/cassi/Documents/R")
library(reshape2)
BLS_Combined2 = melt(BLS_Combined2, id.var='date')
BLS_Combined2 = na.omit(BLS_Combined2)
# Remove rows for dates before 2020-05-01 (when telework started being reported)
BLS_Combined2 = BLS_Combined2 %>% 
    filter(date >= "2020-01-01")
BLS_Combined2 = rename(BLS_Combined2, Telework = Total, Productivity = productivity)
BLS_Combined2

#######  PLOT THE DATA
Combined2_plot = ggplot(BLS_Combined2, aes(x=date, y=value, color=variable)) + 
  geom_line() +
  facet_wrap(~ variable, scales = "free_y", ncol = 1, strip.position = "left") +
  scale_color_manual(values=c('blue', 'purple')) +
  scale_x_date(date_breaks = "6 months", date_labels = "%b-%y", limits = as.Date(c("2020-01-01","2023-01-01"))) +
  theme_bw() +                                                                                        
  labs(                                                                                               
    title = "% Telework vs. Productivity Levels",
    subtitle = "",
    x = "",
    y = "") +
theme(                                                                                                 
    legend.position = 'none',                                                                           
    panel.grid = element_line(color="light gray", size = .0005, linetype = 5),       
    panel.background = element_rect(fill = "white", color = "white"),
    plot.background = element_rect(fill = "white", colour = "black", size = 2),      
    strip.background = element_rect(color = "black", size = 2),
    axis.title = element_text(size = 12, color = "black", family = "Cooper Black"),         
    axis.text.x = element_text(size = 10, color = "black", family = "Cooper Black"),
    axis.text.y = element_text(size = 10, color = "black", family = "Cooper Black"),   
    plot.title = element_text(size = 30, color = "black", family = "Cooper Black"), 
    plot.subtitle = element_text(size = 16, color = "black", family = "Cooper Black"))  +            
Combined2_plot


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
