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

total_1 <- select(totales_clean, cuce, tipo = tipo_a, monto = monto_a)
total_2 <- select(totales_clean, cuce, tipo = tipo_b, monto = monto_b)
total_3 <- select(totales_clean, cuce, tipo = tipo_c, monto = monto_c)

totales_longer <- bind_rows(total_1, total_2, total_3) %>%
  arrange(cuce) %>%
  na.omit()

totales_wider <- totales_longer %>%
  pivot_wider(names_from = tipo, values_from = monto, values_fn = sum)

export_csv_json(totales_wider)

# Adjudicados
adjudicados <- read_csv("scripts/python/out/v2/tablas_adjudicado_clean.csv", col_types = "cccccccccccc")

adjudicados_clean <- adjudicados %>%
  mutate(
    monto_adjudicado = parsear_numero_diverso(monto_adjudicado),
    monto_de = parsear_numero_diverso(monto_de),
    monto = parsear_numero_diverso(monto)
  ) %>%
  select(-list_n)

export_csv_json(adjudicados_clean)


# Items
items <- read_csv("scripts/python/out/v2/tablas_item_clean.csv", col_types = "cccccccccccccccccc")

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