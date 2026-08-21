library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Detected = c(4,6,5,8,10,7,6,5,3,2)
), order.by=as.Date("2026-10-12")+0:9)
dygraph(x, main="Continuous Security Monitoring")