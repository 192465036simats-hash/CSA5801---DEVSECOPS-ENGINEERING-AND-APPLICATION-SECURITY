library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  SecurityScore = c(65,68,70,72,75,74,78,80,83,85),
  Vulnerabilities = c(20,18,17,15,13,12,10,8,7,5)
), order.by=as.Date("2026-09-14")+0:9)
dygraph(x, main="DevSecOps Security Dashboard")