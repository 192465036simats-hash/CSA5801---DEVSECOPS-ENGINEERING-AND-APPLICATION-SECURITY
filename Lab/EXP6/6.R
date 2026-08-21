library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Code -> Security_Check -> Test -> Build -> Deploy
}
")