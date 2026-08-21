library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Passed = c(5,6,7,7,8,9,9,10,10,10),
  Failed = c(5,4,3,3,2,1,1,0,0,0)
), order.by=as.Date("2026-09-21")+0:9)
dygraph(x, main="Automated Security Verification")