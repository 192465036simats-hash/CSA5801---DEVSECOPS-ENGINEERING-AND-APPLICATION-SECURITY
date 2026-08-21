library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Vulnerabilities = c(15,13,12,10,9,8,6,5,4,3)
), order.by=as.Date("2026-08-07")+0:9)
dygraph(x, main="DAST Security Scan")