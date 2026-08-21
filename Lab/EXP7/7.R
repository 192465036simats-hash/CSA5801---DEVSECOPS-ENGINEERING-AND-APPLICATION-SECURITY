library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Vulnerabilities = c(12,10,9,7,6,5,4,3,3,2)
), order.by=as.Date("2026-08-03")+0:9)
dygraph(x, main="SAST Vulnerability Detection")