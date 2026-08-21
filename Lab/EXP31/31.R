library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Low = c(8,9,10,11,12,13,14,15,16,17),
  High = c(6,6,5,5,4,4,3,3,2,2),
  Critical = c(2,2,3,2,2,1,2,1,1,1)
), order.by=as.Date("2026-10-19")+0:9)
dygraph(x, main="Incident Severity")