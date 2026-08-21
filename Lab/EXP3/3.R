library(DiagrammeR)
library(dygraphs)
library(xts)
d <- 1:10
x <- xts(cbind(
  DevOps = c(60,62,65,63,68,70,72,71,75,76),
  DevSecOps = c(65,67,70,72,74,76,79,82,84,87)
), order.by=as.Date("2026-07-01")+d-1)
dygraph(x, main="DevOps vs DevSecOps")