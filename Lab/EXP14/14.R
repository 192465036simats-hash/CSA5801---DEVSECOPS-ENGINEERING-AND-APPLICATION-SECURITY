library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Vulnerabilities = c(14,13,11,10,8,7,6,4,3,2)
), order.by=as.Date("2026-09-04")+0:9)
dygraph(x, main="Container Vulnerability Assessment")