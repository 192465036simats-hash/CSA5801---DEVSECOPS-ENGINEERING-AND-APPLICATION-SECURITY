library(DiagrammeR)
library(dygraphs)
library(xts)
set.seed(1)
risk <- rnorm(100, mean=50, sd=10)
x <- xts(
  cbind(Risk=sort(risk)),
  order.by=as.Date("2026-11-02")+0:99
)
dygraph(x, main="Monte Carlo Risk Simulation")
