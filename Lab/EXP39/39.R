library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  SecurityScore = c(60,64,68,70,73,76,79,82,85,88),
  Vulnerabilities = c(20,18,17,15,13,11,9,7,5,4)
), order.by=as.Date("2026-11-06")+0:9)
dygraph(x, main="Integrated Security Analytics")