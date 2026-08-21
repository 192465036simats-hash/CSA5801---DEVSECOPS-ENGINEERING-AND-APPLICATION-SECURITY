library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Threats = c(2,4,6,9,12,10,8,6,4,3),
  AttackSurface = c(10,15,20,28,35,32,27,22,18,15)
), order.by=as.Date("2026-07-01")+0:9)
dygraph(x, main="Threat Propagation")