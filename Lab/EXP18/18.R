library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Application -> OWASP_Top_10 -> Risk_Classification
}
")