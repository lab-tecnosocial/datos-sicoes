library(tidyverse)

# Exportar a CSV y JSON
export_csv_json <- function(df, path = "todo/covid/v2/") {
  name_df <- deparse(substitute(df))
  write_csv(df, paste0(path, name_df, ".csv" ), na = "")
  write(jsonlite::toJSON(df, pretty = T), paste0(path, name_df, ".json"))
}

# Homogeneizar uso de puntos y comas en numeros
parsear_numero_diverso <- function(n) {
  punto_decimal <- ".*,.*\\..*"
  coma_decimal <- ".*\\..*,.*"
  if_else(str_detect(n, punto_decimal), parse_number(n), parse_number(n, locale = locale(decimal_mark = ",", grouping_mark = ".")))
}

# Montos totales
totales <- read_csv("scripts/python/out/v2/tablas_totales.csv", col_types = "cccccccc")

totales_clean <- totales %>%
  mutate(
    monto_a = parsear_numero_diverso(monto_a),
    monto_b = parsear_numero_diverso(monto_b),
    monto_c = parsear_numero_diverso(monto_c)
  ) %>%
  select(-list_n)

export_csv_json(totales_clean)

# Adjudicados
adjudicados <- read_csv("scripts/python/out/v2/tablas_clean_adjudicado.csv", col_types = "cccccccccccc")

adjudicados_clean <- adjudicados %>%
  mutate(
    monto_adjudicado = parsear_numero_diverso(monto_adjudicado),
    monto_de = parsear_numero_diverso(monto_de),
    monto = parsear_numero_diverso(monto)
  ) %>%
  select(-list_n)

export_csv_json(adjudicados_clean)


# Items
items <- read_csv("scripts/python/out/v2/tablas_clean_item.csv", col_types = "cccccccccccccccccc")

items_clean <- items %>%
  mutate(
    cantidad = parsear_numero_diverso(cantidad),
    precio_referencial_unitario = parsear_numero_diverso(precio_referencial_unitario),
    precio_referencial_total = parsear_numero_diverso(precio_referencial_total),
    precio_unitario_adjudicado = parsear_numero_diverso(precio_unitario_adjudicado),
    total_adjudicado = parsear_numero_diverso(total_adjudicado),
    cantidad_recepcionada = parsear_numero_diverso(cantidad_recepcionada),
    precio_unitario_real = parsear_numero_diverso(precio_unitario_real),
    monto_real_ejecutado = parsear_numero_diverso(monto_real_ejecutado),
  ) %>%
  select(-list_n)

export_csv_json(items_clean)