library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Plan -> Code -> Build -> Test -> Deploy -> Monitor -> Plan
}
")