library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Build = c(70,72,75,78,80,82,84,86,88,90),
  Security = c(60,64,68,72,75,78,81,84,87,90),
  Deployment = c(55,60,65,68,72,76,80,84,87,91)
), order.by=as.Date("2026-11-09")+0:9)
dygraph(x, main="End-to-End DevSecOps Pipeline")