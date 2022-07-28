library(tidyverse)
source("scripts/R/mis-funciones.R")

# Tabla de totales
totales <- read_csv("todo/covid/tablas_totales.csv")

totales_clean <- totales %>%
  mutate(
    monto_a = parsear_numero_diverso(monto_a),
    monto_b = parsear_numero_diverso(monto_b),
    monto_c = parsear_numero_diverso(monto_c)
  )

export_csv_json(totales_clean)

# Tabla de adjudicados
adjudicados <- read_csv("todo/covid/adjudicados.csv", col_types = "cccccccc")

adjudicados <- adjudicados %>%
  mutate(
    monto_adjudicado = parsear_numero_diverso(monto_adjudicado),
    monto_de = parsear_numero_diverso(monto_de),
    monto = parsear_numero_diverso(monto)
  )

export_csv_json(adjudicados)
