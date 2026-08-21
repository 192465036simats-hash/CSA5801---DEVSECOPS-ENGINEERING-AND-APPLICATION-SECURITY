library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Events = c(4,5,6,15,7,6,18,8,5,4),
  Correlated = c(1,2,2,8,3,3,10,4,2,1)
), order.by=as.Date("2026-10-14")+0:9)
dygraph(x, main="Security Event Correlation")