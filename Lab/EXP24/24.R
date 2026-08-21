library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Vulnerabilities = c(16,15,13,12,10,9,7,6,4,3)
), order.by=as.Date("2026-10-02")+0:9)
dygraph(x, main="Web Application Vulnerabilities")