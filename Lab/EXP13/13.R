library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Developer -> Git -> CI -> Security_Check -> CD -> Kubernetes
}
")