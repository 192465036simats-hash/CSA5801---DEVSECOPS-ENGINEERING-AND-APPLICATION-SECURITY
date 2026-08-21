library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Detect -> Classify -> Contain -> Eradicate -> Recover
}
")
