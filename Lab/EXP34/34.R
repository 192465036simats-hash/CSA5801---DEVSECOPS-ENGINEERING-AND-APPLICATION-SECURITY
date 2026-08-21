library(DiagrammeR)
library(dygraphs)
x <- xts(cbind(
  MTTD = c(20,18,17,15,14,12,11,10,9,8),
  MTTR = c(40,38,35,33,30,28,25,22,20,18)
), order.by=as.Date("2026-10-26")+0:9)
dygraph(x, main="MTTD and MTTR")

library(xts)