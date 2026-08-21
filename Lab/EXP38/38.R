library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  Secure = c(90,91,92,93,94,95,96,97,98,99),
  Insecure = c(70,68,72,65,67,64,62,60,58,55)
), order.by=as.Date("2026-11-04")+0:9)
dygraph(x, main="Secure vs Insecure CI/CD")