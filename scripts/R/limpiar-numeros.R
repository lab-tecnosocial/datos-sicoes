library(tidyverse)
library(jsonlite)
totales <- read_csv("todo/covid/tablas_totales.csv")

parsear_numero_diverso <- function(n) {
  punto_decimal <- ".*,.*\\..*"
  coma_decimal <- ".*\\..*,.*"
  if_else(str_detect(n, punto_decimal), parse_number(n), parse_number(n, locale = locale(decimal_mark = ",", grouping_mark = ".")))
}

totales_clean <- totales %>%
  mutate(
    monto_a = parsear_numero_diverso(monto_a),
    monto_b = parsear_numero_diverso(monto_b),
    monto_c = parsear_numero_diverso(monto_c)
  )

export_csv_json(totales_clean)


adjudicados <- read_csv("todo/covid/adjudicados.csv", col_types = "cccccccc")

adjudicados <- adjudicados %>%
  mutate(
    monto_adjudicado = parsear_numero_diverso(monto_adjudicado),
    monto_de = parsear_numero_diverso(monto_de),
    monto = parsear_numero_diverso(monto)
  )

export_csv_json(adjudicados)
