library(DiagrammeR)
library(dygraphs)
library(xts)
x <- xts(cbind(
  VulnerableDependencies = c(10,9,8,8,6,5,5,3,2,1)
), order.by=as.Date("2026-08-12")+0:9)
dygraph(x, main="SCA Dependency Vulnerabilities")
