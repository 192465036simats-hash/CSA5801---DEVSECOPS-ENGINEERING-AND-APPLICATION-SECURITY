library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  SecurityKPI = c(60,63,66,68,71,74,76,79,82,85)
), order.by=as.Date("2026-10-09")+0:9)
dygraph(x, main="Security KPI Trend")