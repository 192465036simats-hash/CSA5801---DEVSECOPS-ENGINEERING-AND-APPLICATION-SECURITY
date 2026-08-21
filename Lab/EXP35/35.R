library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Compliance = c(70,72,75,77,80,82,84,87,90,92)
), order.by=as.Date("2026-10-28")+0:9)
dygraph(x, main="Security Compliance")
