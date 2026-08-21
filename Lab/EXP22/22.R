library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  SecretsFound = c(12,10,9,8,6,5,4,3,2,1)
), order.by=as.Date("2026-09-28")+0:9)
dygraph(x, main="Secrets Detection")