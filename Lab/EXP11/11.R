library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  rankdir=LR
  Developer -> Git -> IaC -> Cloud -> Secure_Application
}
")