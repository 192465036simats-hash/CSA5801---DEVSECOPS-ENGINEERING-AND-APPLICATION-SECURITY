library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  CVSS = c(3.2,5.1,6.4,7.2,8.1,9.0,6.8,4.5,8.7,7.5)
), order.by=as.Date("2026-09-25")+0:9)
dygraph(x, main="CVSS Vulnerability Scores")