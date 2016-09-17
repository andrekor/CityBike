ibrary(ggplot2)
library(scales)
library(RColorBrewer)

#Plot the reports
timePlot <- function(plotData, xVal, yVal, fillVal) {
  return (ggplot(data=plotData, aes(x=xVal, y=yVal, fill=fillVal))+
            geom_line() +
            theme_bw() + ylab("# Reports") +
            theme(axis.text.x = element_text(angle = 30, hjust = 1),
                  legend.position="bottom", legend.direction="vertical"))
}

#Plot the reports
timePlot1 <- function(plotData, xVal, yVal, fillVal, pos=position_stack(), labY = "") {
  return (ggplot(data=plotData, aes_string(x=xVal, y=yVal, fill=fillVal))+
            geom_bar(stat="identity", position = pos) +
            theme_bw() +
            scale_x_date(breaks = date_breaks("1 month")) +
            theme(axis.text.x = element_text(angle = 30, hjust = 1),
                  legend.position="bottom", legend.direction="vertical"))
}

categoryMeansPlot <- function(plotData, categoryColumn, yVal){
  limits <- aes(ymax=plotData$ConfidenceUpper, ymin=plotData$ConfidenceLower)
  return(ggplot(plotData, aes_string(x=categoryColumn, y=yVal, fill=categoryColumn)) + geom_bar(stat="identity") +
           geom_errorbar(limits, width=0.5, size=0.5) + scale_y_continuous(labels=percent) + scale_fill_brewer(palette="Set1") + theme_bw())
}

#' Plots a given dataset as a heatmap
#'
#' @param plotData, data to be plotted as a heatmap
#' @param xVal, what should be plotted on the x-axis
#' @param yVal, what should be plotted on the y-axis
#' @param fillVal, what the intensity should be plotted based on
#' @param lab, label is default set to showing the percentage
#' @return ggplot containing the heatmap with the provided properties
heatPlot <- function(plotData, xVal, yVal, fillVal, lab=percent) {
  bgcolor = "white"
  palette = rev(brewer.pal(9,"RdYlGn"))[c(1,3,7,9)]
  #plotData[[xVal]] <- as.factor(plotData[[xVal]])
  return(ggplot(plotData, aes_string(x=xVal, y=yVal, fill=fillVal)) + geom_tile(colour=bgcolor) + theme_bw() +
           theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.key.width=unit(1,"cm"), legend.box.just="left"))
}
         
         