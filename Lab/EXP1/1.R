library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Git -> GitHub -> RStudio -> DevSecOps_Tools
}
")
