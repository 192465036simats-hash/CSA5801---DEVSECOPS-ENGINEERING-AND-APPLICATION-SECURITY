library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Critical = c(8,7,6,5,4,3,3,2,1,1),
  High = c(12,11,10,9,8,7,6,5,4,3)
), order.by=as.Date("2026-08-17")+0:9)
dygraph(x, main="Vulnerability Trends")