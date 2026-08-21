library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Risk = c(80,75,70,65,60,55,50,45,40,35)
), order.by=as.Date("2026-10-30")+0:9)
dygraph(x, main="Risk-Based Decision Making")
