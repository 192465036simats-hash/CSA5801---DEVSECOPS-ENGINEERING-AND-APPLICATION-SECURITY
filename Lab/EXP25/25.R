library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Allowed = c(8,9,10,11,12,13,14,15,16,17),
  Blocked = c(7,6,6,5,4,4,3,2,2,1)
), order.by=as.Date("2026-10-05")+0:9)
dygraph(x, main="Rule-Based Security Policy")