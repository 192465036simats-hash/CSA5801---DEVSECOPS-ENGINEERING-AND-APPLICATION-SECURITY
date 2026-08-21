library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Events = c(5,6,7,8,20,7,6,5,18,6)
), order.by=as.Date("2026-09-09")+0:9)
dygraph(x, main="Security Events and Anomalies")
