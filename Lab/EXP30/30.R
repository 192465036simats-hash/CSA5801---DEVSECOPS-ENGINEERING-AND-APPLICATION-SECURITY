library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Normal = c(20,22,21,23,22,21,24,23,22,21),
  Anomaly = c(1,2,1,3,10,2,1,8,2,1)
), order.by=as.Date("2026-10-16")+0:9)
dygraph(x, main="Intrusion and Anomaly Detection")
