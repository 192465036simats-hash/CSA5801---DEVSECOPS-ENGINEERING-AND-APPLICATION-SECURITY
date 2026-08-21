library(DiagrammeR)
library(dygraphs)
library(xts)
grViz("
digraph G {
  User -> Role -> Permission -> Resource
}
")