library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Risk = c(20,35,45,30,55,40,25,60,50,30)
), order.by=as.Date("2026-07-01")+0:9)
dygraph(x, main="Security Risk Simulation")