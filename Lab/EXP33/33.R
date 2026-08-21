library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  IncidentEvents = c(1,2,4,8,12,9,5,3,2,1)
), order.by=as.Date("2026-10-23")+0:9)
dygraph(x, main="Incident Timeline")