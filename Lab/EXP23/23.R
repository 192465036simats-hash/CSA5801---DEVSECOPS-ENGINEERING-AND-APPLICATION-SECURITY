library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Vulnerabilities = c(10,9,8,7,6,5,4,3,2,1)
), order.by=as.Date("2026-09-30")+0:9)
dygraph(x, main="API Security Testing")