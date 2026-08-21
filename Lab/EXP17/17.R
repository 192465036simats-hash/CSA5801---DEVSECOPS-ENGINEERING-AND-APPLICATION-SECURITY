library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Vulnerabilities = c(18,16,15,13,11,9,8,6,4,3)
), order.by=as.Date("2026-09-16")+0:9)
dygraph(x, main="Secure Coding Simulation")