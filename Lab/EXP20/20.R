library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Passed = c(3,4,5,6,7,7,8,9,9,10),
  Failed = c(7,6,5,4,3,3,2,1,1,0)
), order.by=as.Date("2026-09-23")+0:9)
dygraph(x, main="CI/CD Quality Gate")